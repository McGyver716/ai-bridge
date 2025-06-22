# Usage Examples

## Basic Usage

### Single AI Query
```bash
curl "http://localhost:3000/ai-bridge?query=What is the capital of France?&ai=gpt"
```

### Multi-AI Comparison
```bash
curl "http://localhost:3000/ai-bridge?query=Explain quantum computing&ai=all"
```

## JavaScript Usage

```javascript
const response = await fetch('http://localhost:3000/ai-bridge?query=Hello&ai=all');
const data = await response.json();
console.log(data.responses);
```

## Python Usage

```python
import requests

response = requests.get('http://localhost:3000/ai-bridge', {
    'query': 'Hello world',
    'ai': 'claude'
})
print(response.json())
```