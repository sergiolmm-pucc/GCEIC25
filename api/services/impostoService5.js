exports.calcularIPI = ({ valorProduto, aliquotaIPI, frete = 0, despesasAcessorias = 0 }) => {
  if (valorProduto == null || aliquotaIPI == null) {
    throw new Error('valorProduto e aliquotaIPI são obrigatórios');
  }

  // Converte para números (caso venham como string)
  const valor = Number(valorProduto);
  const aliquota = Number(aliquotaIPI);
  const valorFrete = Number(frete);
  const valorDespesas = Number(despesasAcessorias);

  // Verifica se são números válidos
  if ([valor, aliquota, valorFrete, valorDespesas].some(isNaN)) {
    throw new Error('Todos os valores devem ser números válidos');
  }

  // Calcula a base de cálculo
  const baseCalculo = valor + valorFrete + valorDespesas;

  // Calcula o IPI
  const ipi = (baseCalculo * aliquota) / 100;

  return {
    valorProduto: valor.toFixed(2),
    frete: valorFrete.toFixed(2),
    despesasAcessorias: valorDespesas.toFixed(2),
    baseCalculo: baseCalculo.toFixed(2),
    aliquotaIPI: aliquota.toFixed(2),
    imposto: ipi.toFixed(2),
  };
};

exports.calcularICMS = ({ valorProduto, aliquotaICMS }) => {
  if (valorProduto == null || aliquotaICMS == null) {
    throw new Error('valorProduto e aliquotaICMS são obrigatórios');
  }

  // Converte para números (caso venham como string)
  const valor = Number(valorProduto);
  const aliquota = Number(aliquotaICMS);

  // Verifica se são números válidos
  if (isNaN(valor) || isNaN(aliquota)) {
    throw new Error('Os valores devem ser números válidos');
  }

  // Fórmula do ICMS
  const icms = (valor * aliquota) / (100 + aliquota);

  return {
    valorProduto: valor.toFixed(2),
    aliquotaICMS: aliquota.toFixed(2),
    imposto: icms.toFixed(2) 
  };
};

exports.calcularIRPJ = ({ lucroTributavel, isLucroReal = true }) => {
  if (lucroTributavel == null) {
    throw new Error('lucroTributavel é obrigatório');
  }

  const lucro = Number(lucroTributavel);
  if (isNaN(lucro)) {
    throw new Error('O valor deve ser um número válido'); // Mensagem igual ao teste
  }

  let valorIRPJ, aliquotaIRPJ;

  if (isLucroReal) {
    const baseNormal = Math.min(lucro, 60000);
    const baseAdicional = Math.max(0, lucro - 60000);
    valorIRPJ = (baseNormal * 0.15) + (baseAdicional * 0.10); // 10% adicional
    aliquotaIRPJ = (valorIRPJ / lucro) * 100;
  } else {
  const baseNormal = Math.min(lucro, 60000);
  const baseAdicional = Math.max(0, lucro - 60000);
  valorIRPJ = (baseNormal * 0.15) + (baseAdicional * 0.10);
  aliquotaIRPJ = (valorIRPJ / lucro) * 100;
}

  return {
    lucroTributavel: lucro.toFixed(2),
    aliquotaIRPJ: aliquotaIRPJ.toFixed(2),
    imposto: valorIRPJ.toFixed(2),
    regime: isLucroReal ? 'Lucro Real' : 'Lucro Presumido',
    observacao: isLucroReal
      ? '15% sobre o lucro tributável. Adicional de 10% sobre o valor que exceder R$ 60.000/trimestre (se aplicável)'
      : '15% sobre base presumida'
  };
};

exports.calcularISS = ({ valorServico, aliquotaISS }) => {
  if (valorServico == null || aliquotaISS == null) {
    throw new Error('valorServico e aliquotaISS são obrigatórios');
  }

  // Converte para números (caso venham como string)
  const valor = Number(valorServico);
  const aliquota = Number(aliquotaISS);

  // Verifica se são números válidos
  if (isNaN(valor) || isNaN(aliquota)) {
    throw new Error('Os valores devem ser números válidos');
  }

  // Fórmula do ISS (diferente do ICMS, o ISS é calculado diretamente sobre o valor do serviço)
  const iss = valor * (aliquota / 100);

  return {
    valorServico: valor.toFixed(2),
    aliquotaISS: aliquota.toFixed(2),
    imposto: iss.toFixed(2)
  };
};