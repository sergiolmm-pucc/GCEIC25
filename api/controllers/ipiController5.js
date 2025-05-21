const { calcularIPI } = require('../services/impostoService5');

function calcularIPIHandler(req, res) {
  try {
    const resultado = calcularIPI(req.body);
    res.json(resultado);
  } catch (error) {
    res.status(400).json({ erro: error.message });
  }
}

module.exports = { calcularIPI: calcularIPIHandler };
