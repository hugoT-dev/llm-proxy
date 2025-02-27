# llm-proxy
 LLM Proxy is a proxy software that can configure and integrate multiple LLM platforms, such as groq, openai, deepseek, siliconflow, cohere, openrouter, etc., while addressing the token limits of each platform through a unified routing.
 # Configuration
   You can edit lua/config.lua to configure platform information and model information.
   
   -- platform
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

-- models
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
 # deployment
 ## window
 1. Make sure to install the Docker environment.
 2. In PowerShell, run start.bat to complete the Docker environment deployment.
 ## linux
 1. Make sure to install the Docker environment.
 2. In Shell, run start.sh to complete the Docker environment deployment.
 # Test
 ## Request
   curl --request POST \
    --url http://127.0.0.1:8090/chat/completions \
    --header 'Content-Type: application/json' \
    --data '{
    "messages": [
      {
        "content": "Hi",
        "role": "user"
      }
    ],
    "stream": true
  }'
## Response
data: {"id":"0195474971f427ef3dd4d6db09a8e663","object":"chat.completion.chunk","created":1740657750,"model":"deepseek-ai/deepseek-vl2","choices":[{"index":0,"delta":{"content":"","reasoning_content":null},"finish_reason":"stop","content_filter_results":{"hate":{"filtered":false},"self_harm":{"filtered":false},"sexual":{"filtered":false},"violence":{"filtered":false}}}],"system_fingerprint":"","usage":{"prompt_tokens":12,"completion_tokens":9,"total_tokens":21}}

data: [DONE]

 # Coming soon
 Currently, only the /chat/completions and /embeddings interfaces have been integrated. 
 Follow-up will require the integration of TTS, image generation, and other interfaces.
 # Reference 
 To find more free LLM resources, you can visit.：https://github.com/cheahjs/free-llm-api-resources.
 
