const { calcularIPI, calcularICMS} = require('../services/impostoService5');

function calcularIPIHandler(req, res) {
  try {
    const resultado = calcularIPI(req.body);
    res.json(resultado);
  } catch (error) {
    res.status(400).json({ erro: error.message });
  }
}

function calcularICMSHandler(req, res) {
  try {
    const resultado = calcularICMS(req.body);
    res.json(resultado);
  } catch (error) {
    res.status(400).json({ erro: error.message });
  }
}

 const { calcularIRPJ } = require('../services/impostoService5');

function calcularIRPJHandler(req, res) {
  try {
    const resultado = calcularIRPJ(req.body);
    res.json(resultado);
  } catch (error) {
    res.status(400).json({ erro: error.message });
  }
}

const { calcularISS } = require('../services/impostoService5');

function calcularISSHandler(req, res) {
  try {
    const resultado = calcularISS(req.body);
    res.json(resultado);
  } catch (error) {
    res.status(400).json({ erro: error.message });
  }
}


module.exports = { 
  calcularIPI: calcularIPIHandler,
  calcularICMS: calcularICMSHandler,
  calcularIRPJ: calcularIRPJHandler,
  calcularISS: calcularISSHandler
 };



