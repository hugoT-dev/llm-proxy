-- 定义平台配置
local backend = {
    siliconflow_backend = {
        url = "https://api.siliconflow.cn/v1",
        api_key = "sk-xxxxxx"
    },
    -- ollama_backend = {
    --     url = "http://localhost:11434/v1",
    --     api_key = "ollama_api_key_here"
    -- },
    groq_backend = {
        url = "https://api.groq.com/openai/v1",
        api_key = "gsk_xxxx"
    }
}

-- 定义模型配置
local models = {
    embeddings = {
        -- { model = "deepseek_embeddings-model-1", weight = 3, provider = backend.siliconflow_backend },
        -- { model = "ollama_embeddings-model-2", weight = 2, provider = backend.ollama_backend },
        { model = "BAAI/bge-large-en-v1.5", weight = 2, provider = backend.siliconflow_backend },
        { model = "BAAI/bge-large-zh-v1.5", weight = 1, provider = backend.siliconflow_backend }
    },
    completions = {
        { model = "Qwen/Qwen2.5-Coder-32B-Instruct", weight = 1, provider = backend.siliconflow_backend },
        { model = "deepseek-ai/deepseek-vl2", weight = 1, provider = backend.siliconflow_backend },
        -- { model = "llama-3.3-70b-versatile", weight = 1, provider = backend.groq_backend },
        -- { model = "qwen-2.5-coder-32b", weight = 1, provider = backend.groq_backend }
    }
}

-- 返回配置
return {
    backend = backend,
    models = models
}
