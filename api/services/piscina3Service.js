exports.calcularTodosCustos = ({ largura, comprimento, profundidade, precoAgua, custoEletrico, custoHidraulico, custoManutencaoMensal, mesesManutencao = 12 }) => {
  const volume = largura * comprimento * profundidade;
  const custoAgua = volume * precoAgua;
  const custoConstrucao = custoAgua + custoEletrico + custoHidraulico;
  const custoManutencaoTotal = custoManutencaoMensal * mesesManutencao;
  const custoTotalPiscina = custoConstrucao + custoManutencaoTotal;

  return {
    volume: volume.toFixed(2) + ' m³',
    custoAgua: custoAgua.toFixed(2),
    custoConstrucao: custoConstrucao.toFixed(2),
    manutencaoMensal: custoManutencaoMensal.toFixed(2),
    custoTotalPiscina: custoTotalPiscina.toFixed(2)
  };
};

exports.sobre = (req, res) => {
  const urlFoto = 'https://sep-bucket-prod.s3.amazonaws.com/wp-content/uploads/2022/11/51981800313_fb744fd72d_o.jpg';

  res.json({
    sucesso: true,
    mensagem: 'Foto do time',
    url: urlFoto
  });
};

exports.getSplashData = () => {
  return {
    mensagem: "Bem-vindo à PiscinaApp!",
    versao: "1.0.0",
    atualizacaoDisponivel: false,
    timestamp: new Date().toISOString() // Formata a data em string ISO 8601
  };
};

exports.calcularEletrica = ({
  comprimentoFios = 0,
  precoPorMetroFio = 0,
  quantidadeDisjuntores = 0,
  precoPorDisjuntor = 0,
  custoMaoDeObra = 0
}) => {
  const custoFios = comprimentoFios * precoPorMetroFio;
  const custoDisjuntores = quantidadeDisjuntores * precoPorDisjuntor;
  const custoTotalEletrica = custoFios + custoDisjuntores + custoMaoDeObra;

  return custoTotalEletrica.toFixed(2);
};

exports.calcularHidraulica = ({
  quantidadeTubulacao = 0,
  precoPorMetroTubulacao = 0,
  quantidadeConexoes = 0,
  precoPorConexao = 0,
  custoMaoDeObra = 0
}) => {
  const custoTubulacao = quantidadeTubulacao * precoPorMetroTubulacao;
  const custoConexoes = quantidadeConexoes * precoPorConexao;
  const custoTotalHidraulica = custoTubulacao + custoConexoes + custoMaoDeObra;

  return {
    custoTotalHidraulico: custoTotalHidraulica.toFixed(2)
  };
};

