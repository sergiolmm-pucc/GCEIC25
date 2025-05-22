
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

// POST /salario-liquido
exports.salarioLiquido = (req, res) => {
  const { salarioBruto } = req.body;
  const inssEmpregado = salarioBruto * 0.08;
  const liquido = salarioBruto - inssEmpregado;
  res.json({ salarioLiquido: liquido.toFixed(2) });
};

// POST /inss
exports.inss = (req, res) => {
  const { salarioBruto } = req.body;
  const inssEmpregado = salarioBruto * 0.08;
  const inssEmpregador = salarioBruto * 0.08;
  res.json({
    inssEmpregado: inssEmpregado.toFixed(2),
    inssEmpregador: inssEmpregador.toFixed(2)
  });
};


