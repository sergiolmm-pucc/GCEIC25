exports.calcularIPI = ({ valorProduto, aliquotaIPI }) => {
  if (valorProduto == null || aliquotaIPI == null) {
    throw new Error('valorProduto e aliquotaIPI são obrigatórios');
  }

  // Converte para números (caso venham como string)
  const valor = Number(valorProduto);
  const aliquota = Number(aliquotaIPI);

  // Verifica se são números válidos
  if (isNaN(valor) || isNaN(aliquota)) {
    throw new Error('Os valores devem ser números válidos');
  }

  const ipi = (valor * aliquota) / 100;

  return {
    valorProduto: valor.toFixed(2),
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

