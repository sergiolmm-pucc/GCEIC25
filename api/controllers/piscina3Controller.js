const piscinaService = require('../services/piscina3Service');

// Controller para cálculo da manutenção
exports.calcularCustos = (req, res) => {
  try {
    const dados = req.body;
    const resultado = piscinaService.calcularTodosCustos(dados);
    res.status(200).json(resultado);
  } catch (error) {
    res.status(500).json({ erro: 'Erro ao calcular custos', detalhes: error.message });
  }
};

// Controller para o texto de ajuda
exports.ajuda = (req, res) => {
  res.status(200).json({
    titulo: 'Ajuda',
    texto:
      'Preencha os dados da piscina e toque em "Calcular" para ver o custo estimado.\n\n' +
      'Caso tenha dúvidas, entre em contato com a equipe MOB3..\n\n' +
      'Nenhuma informação pessoal é coletada ou compartilhada. Todos os dados permanecem apenas no seu dispositivo.\n\n' +
      'Estamos sempre aprimorando o app. Fique atento às atualizações para novas funcionalidades e correções.',

  });
};

// Controller para cálculo da parte elétrica
exports.calcularEletrica = (req, res) => {
  try {
    const dados = req.body;
    const resultado = piscinaService.calcularEletrica(dados);
    res.status(200).json(resultado);
  } catch (error) {
    res.status(500).json({ erro: 'Erro ao calcular custos elétricos', detalhes: error.message });
  }
};

// Controller para cálculo da parte hidráulica
exports.calcularHidraulica = (req, res) => {
  try {
    const dados = req.body;
    const resultado = piscinaService.calcularHidraulica(dados);
    res.status(200).json(resultado);
  } catch (error) {
    res.status(500).json({ erro: 'Erro ao calcular custos hidráulicos', detalhes: error.message });
  }
};

// Controller para cálculo do custo total geral (manutenção + elétrica + hidráulica)
exports.calcularCustoTotalGeral = (req, res) => {
  try {
    const dados = req.body;
    const resultado = piscinaService.calcularCustoTotalGeral(dados);
    res.status(200).json(resultado);
  } catch (error) {
    res.status(500).json({ erro: 'Erro ao calcular custo total geral', detalhes: error.message });
  }
};
