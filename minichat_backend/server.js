// MiniChat AI Privacy Proxy Server
const express = require('express');
const axios = require('axios');
const app = express();

app.use(express.json());

// Endpoint xử lý yêu cầu AI ẩn danh
app.post('/api/ai/chat', async (req, res) => {
    const { prompt, zkProof } = req.body;

    // 1. Xác thực ZK Proof từ Midnight (Giả lập)
    if (!zkProof) return res.status(401).send("Unauthorized: Invalid ZK Proof");

    try {
        // 2. Xóa bỏ Metadata/IP của người dùng trước khi gửi tới LLM
        const aiResponse = await axios.post('https://api.openai.com/v1/chat/completions', {
            model: "gpt-4",
            messages: [{ role: "user", content: prompt }]
        }, {
            headers: { 'Authorization': `Bearer ${process.env.AI_KEY}` }
        });

        res.json({ response: aiResponse.data.choices[0].message.content });
    } catch (error) {
        res.status(500).send("AI Proxy Error");
    }
});

app.listen(3000, () => console.log('MiniChat AI Proxy running on port 3000'));
