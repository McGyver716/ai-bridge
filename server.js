const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
require('dotenv').config();

const app = express();

// Security middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});
app.use(limiter);

// AI API Integrations
const callOpenAI = async (query) => {
  const response = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      model: 'gpt-4',
      messages: [{ role: 'user', content: query }],
      max_tokens: 500
    })
  });
  const data = await response.json();
  return data.choices[0].message.content;
};

const callGrok = async (query) => {
  const response = await fetch('https://api.x.ai/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${process.env.GROK_API_KEY}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      model: 'grok-beta',
      messages: [{ role: 'user', content: query }]
    })
  });
  const data = await response.json();
  return data.choices[0].message.content;
};

const callClaude = async (query) => {
  const response = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: {
      'x-api-key': process.env.CLAUDE_API_KEY,
      'Content-Type': 'application/json',
      'anthropic-version': '2023-06-01'
    },
    body: JSON.stringify({
      model: 'claude-3-sonnet-20240229',
      max_tokens: 500,
      messages: [{ role: 'user', content: query }]
    })
  });
  const data = await response.json();
  return data.content[0].text;
};

// Main Bridge Endpoint
app.get('/ai-bridge', async (req, res) => {
  try {
    const { query, ai = 'all', format = 'json' } = req.query;
    
    if (!query) {
      return res.status(400).json({ 
        success: false,
        error: 'Query parameter required',
        example: '/ai-bridge?query=hello&ai=gpt' 
      });
    }

    let results = {};

    if (ai === 'all') {
      const aiCalls = await Promise.allSettled([
        callOpenAI(query),
        callGrok(query), 
        callClaude(query)
      ]);
      
      results = {
        gpt: aiCalls[0].status === 'fulfilled' ? aiCalls[0].value : 'API Error',
        grok: aiCalls[1].status === 'fulfilled' ? aiCalls[1].value : 'API Error',
        claude: aiCalls[2].status === 'fulfilled' ? aiCalls[2].value : 'API Error'
      };
    } else {
      try {
        switch(ai) {
          case 'gpt':
            results.gpt = await callOpenAI(query);
            break;
          case 'grok':
            results.grok = await callGrok(query);
            break;
          case 'claude':
            results.claude = await callClaude(query);
            break;
          default:
            return res.status(400).json({ 
              success: false,
              error: 'Invalid AI parameter',
              valid: ['gpt', 'grok', 'claude', 'all']
            });
        }
      } catch (aiError) {
        results[ai] = 'API Error';
      }
    }

    res.json({
      success: true,
      query,
      ai,
      responses: results,
      timestamp: new Date().toISOString(),
      bridge_version: '1.0.0'
    });

  } catch (error) {
    res.status(500).json({ 
      success: false,
      error: 'Server error',
      timestamp: new Date().toISOString()
    });
  }
});

// Health Check
app.get('/health', (req, res) => {
  res.json({ 
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    version: '1.0.0'
  });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🌉 AI Bridge running on port ${PORT}`);
  console.log(`Health: http://localhost:${PORT}/health`);
  console.log(`API: http://localhost:${PORT}/ai-bridge?query=hello&ai=all`);
});