const express = require('express');
const router = express.Router();

// GET /datetime
router.get('/datetime', (req, res) => {
  const now = new Date();
  res.json({
    datetime: now.toISOString()
  });
});


// GET /datetime
router.get('/data', (req, res) => {
  const now = new Date();
  res.json({
    datetime: now.toISOString()
  });
});

// POST /concat
router.post('/concat', (req, res) => {
  const { value } = req.body;
  if (!value) {
    return res.status(400).json({ success: false, message: 'Valor não fornecido' });
  }
  const result = `${value} - Esta é uma frase fixa.`;
  res.json({
    success: true,
    result: result
  });
});

module.exports = router;
