
// GET /datetime
exports.datetime = (req, res) => {
  const now = new Date();
  res.json({
    datetime: now.toISOString()
  });
};


// GET /datetime
exports.data = (req, res) => {
  const now = new Date();
  res.json({
    datetime: now.toISOString()
  });
};

// POST /concat
exports.concat = (req, res) => {
  const { value } = req.body;
  if (!value) {
    return res.status(400).json({ success: false, message: 'Valor não fornecido' });
  }
  const result = `${value} - Esta é uma frase fixa.`;
  res.json({
    success: true,
    result: result
  });
};

