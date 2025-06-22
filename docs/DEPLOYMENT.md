# Deployment Guide

## Railway Deployment

1. Fork this repository
2. Go to [Railway](https://railway.app)
3. Click "New Project" -> "Deploy from GitHub repo"
4. Select your forked repository
5. Add environment variables:
   - `OPENAI_API_KEY`
   - `GROK_API_KEY`
   - `CLAUDE_API_KEY`
6. Deploy!

## Vercel Deployment

1. Fork this repository
2. Go to [Vercel](https://vercel.com)
3. Import your repository
4. Add environment variables
5. Deploy!

## Docker Deployment

```bash
docker build -t ai-bridge .
docker run -p 3000:3000 --env-file .env ai-bridge
```