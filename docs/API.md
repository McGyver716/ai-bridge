# AI Bridge API Documentation

## Endpoints

### GET /ai-bridge
Main endpoint for AI queries

**Parameters:**
- `query` (required): The question or prompt to send to AI
- `ai` (optional): Which AI to use (`gpt`, `grok`, `claude`, or `all`)
- `format` (optional): Response format (currently only `json`)

**Example:**
```bash
curl "http://localhost:3000/ai-bridge?query=Hello&ai=all"
```

### GET /health
Health check endpoint

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2025-06-22T...",
  "uptime": 123.45,
  "version": "1.0.0"
}
```