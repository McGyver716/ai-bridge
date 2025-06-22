# 🌉 AI Bridge - Multi-AI Proxy Server

> **Deploy in 5 minutes** • Connect Claude, GPT, and Grok through one API

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template)

## 🚀 Quick Deploy

1. **Clone and Install:**
   ```bash
   git clone https://github.com/your-username/ai-bridge
   cd ai-bridge
   npm install
   cp .env.example .env
   ```

2. **Add Your API Keys to .env:**
   ```env
   OPENAI_API_KEY=sk-...
   GROK_API_KEY=xai-...
   CLAUDE_API_KEY=sk-ant-...
   ```

3. **Start Server:**
   ```bash
   npm start
   ```

4. **Test It:**
   ```bash
   curl "http://localhost:3000/ai-bridge?query=hello&ai=all"
   ```

## 🎯 API Usage

### Single AI Query
```
GET /ai-bridge?query=Write a poem&ai=gpt
```

### Multi-AI Comparison
```
GET /ai-bridge?query=Explain quantum computing&ai=all
```

### Health Check
```
GET /health
```

## 📦 Response Format
```json
{
  "success": true,
  "query": "hello",
  "ai": "all",
  "responses": {
    "gpt": "Hello! How can I help you today?",
    "grok": "Hey there! What's up?",
    "claude": "Hello! I'm here to assist you."
  },
  "timestamp": "2025-06-21T...",
  "bridge_version": "1.0.0"
}
```

## 🚀 Deployment Options

### Railway (Recommended)
1. Fork this repo
2. Connect to Railway
3. Add environment variables
4. Deploy!

### Vercel
1. Fork this repo
2. Import to Vercel
3. Add environment variables
4. Deploy!

### Docker
```bash
docker build -t ai-bridge .
docker run -p 3000:3000 --env-file .env ai-bridge
```

## 🔧 Local Development
```bash
npm run dev  # Uses nodemon for auto-restart
```

## 🤝 Contributing

Built for the Sage AI Assistant project. Issues and PRs welcome!