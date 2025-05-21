exports.calcularTodosCustos = ({ largura, comprimento, profundidade, precoAgua, custoEletrico, custoHidraulico, custoManutencaoMensal }) => {
  const volume = largura * comprimento * profundidade;
  const custoAgua = volume * precoAgua;

  const custoTotal = custoAgua + custoEletrico + custoHidraulico;
  const custoMensal = custoManutencaoMensal;

  return {
    volume: volume.toFixed(2) + ' m³',
    custoAgua: custoAgua.toFixed(2),
    custoEletrico: custoEletrico.toFixed(2),
    custoHidraulico: custoHidraulico.toFixed(2),
    custoConstrucao: custoTotal.toFixed(2),
    manutencaoMensal: custoMensal.toFixed(2)
  };
};
