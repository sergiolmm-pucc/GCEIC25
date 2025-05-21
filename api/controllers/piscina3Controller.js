const piscinaService = require('../services/piscina3Service');

exports.calcularCustos = (req, res) => {
  try {
    const dados = req.body;
    const resultado = piscinaService.calcularTodosCustos(dados);
    res.status(200).json(resultado);
  } catch (error) {
    res.status(500).json({ erro: 'Erro ao calcular custos', detalhes: error.message });
  }
};
