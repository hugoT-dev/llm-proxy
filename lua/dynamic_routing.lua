-- 引入 JSON 库
local cjson = require "cjson"

-- 配置 cjson 不转义斜杠
cjson.encode_escape_forward_slash(false)

-- 加载配置文件
local config = require "config"
local backend = config.backend
local models = config.models

-- 记录请求头和请求体的函数
local function log_request()
    -- 记录所有请求头
    local headers = ngx.req.get_headers()
    local headers_str = ""
    for k, v in pairs(headers) do
        headers_str = headers_str .. string.format("%s: %s, ", k, v)
    end
    ngx.log(ngx.NOTICE, "Request Headers: ", headers_str)

    -- 记录请求体
    local body = ngx.req.get_body_data()
    if body then
        ngx.log(ngx.NOTICE, "Request Body: ", body)
    end
end

-- 根据权重选择一个模型
local function choose_model(models)
    if not models then
        return nil
    end

    -- 计算总权重
    local total_weight = 0
    for _, model in ipairs(models) do
        total_weight = total_weight + model.weight
    end

    -- 随机选择一个模型
    local random_value = math.random(total_weight)
    local current_weight = 0
    for _, model in ipairs(models) do
        current_weight = current_weight + model.weight
        if random_value <= current_weight then
            return model
        end
    end
end

-- 读取请求体
ngx.req.read_body()
local body = ngx.req.get_body_data()

-- 记录原始请求信息
log_request()

-- 解析请求体
local request_data = cjson.decode(body)

-- 获取用户请求的路径
local request_path = ngx.var.request_uri

-- 根据请求路径确定模型类型
local model_type
if request_path:match("^/chat/completions") then
    model_type = "completions"  -- 将 chat/completions 映射到 completions
elseif request_path:match("^/embeddings") then
    model_type = "embeddings"
else
    ngx.status = ngx.HTTP_BAD_REQUEST
    ngx.say("Invalid request path")
    return ngx.exit(ngx.HTTP_BAD_REQUEST)
end

-- 根据模型类型选择模型
local model_list = models[model_type]
if not model_list then
    ngx.status = ngx.HTTP_INTERNAL_SERVER_ERROR
    ngx.say("No available models for the selected type: " .. model_type)
    return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

-- 选择模型
local selected_model = choose_model(model_list)
if not selected_model then
    ngx.status = ngx.HTTP_INTERNAL_SERVER_ERROR
    ngx.say("Failed to select a model")
    return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

-- 获取平台信息
local provider = selected_model.provider
if not provider then
    ngx.status = ngx.HTTP_INTERNAL_SERVER_ERROR
    ngx.say("No provider found for the selected model")
    return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

-- 添加 model 参数到请求体
request_data.model = selected_model.model

-- 重新编码请求体
local new_body = cjson.encode(request_data)

-- 设置请求头
ngx.req.set_header("Content-Type", "application/json")
ngx.req.set_header("Authorization", "Bearer " .. provider.api_key)

-- 更新请求体
ngx.req.set_body_data(new_body)

-- 构建完整的请求URL
local backend_url = provider.url .. request_path

-- 设置后端URL
ngx.var.backend_url = backend_url

-- 记录转发信息
ngx.log(ngx.NOTICE, "Selected model: ", selected_model.model, ", provider: ", provider.url, ", full URL: ", backend_url)
ngx.log(ngx.NOTICE, "Modified Request Body: ", new_body)
ngx.log(ngx.NOTICE, "Modified Headers: Authorization: Bearer " .. string.sub(provider.api_key, 1, 10) .. "...")