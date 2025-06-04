exports.calcularTodosCustos = ({
  custoProdutosLimpeza = 0,
  custoMaoDeObra = 0,
  custoTrocaFiltro = 0
}) => {
  const custoTotalPiscina = custoProdutosLimpeza + custoMaoDeObra + custoTrocaFiltro;

  return {
    custoProdutosLimpeza: custoProdutosLimpeza.toFixed(2),
    custoMaoDeObra: custoMaoDeObra.toFixed(2),
    custoTrocaFiltro: custoTrocaFiltro.toFixed(2),
    custoTotalPiscina: custoTotalPiscina.toFixed(2)
  };
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

  return {
    custoTotalEletrico: custoTotalEletrica.toFixed(2)}
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

exports.calcularCustoTotalGeral = ({
  custoManutencao = 0,
  custoEletrica = 0,
  custoHidraulica = 0
}) => {
  const custoTotal = custoManutencao + custoEletrica + custoHidraulica;

  return {
    custoManutencao: custoManutencao.toFixed(2),
    custoEletrica: custoEletrica.toFixed(2),
    custoHidraulica: custoHidraulica.toFixed(2),
    custoTotalGeral: custoTotal.toFixed(2)
  };
};
