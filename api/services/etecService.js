exports.calcularCustoMensal = ({ salario }) => {
    const FGTS = salario * 0.08;
    const indenizacaoCompensatoria = salario * 0.032;
    const seguroAcidentes = salario * 0.008;
    const INSSEmpregador = salario * 0.08;
    var INSS = 0;

    if (salario <= 1518) {
        INSS = salario * 0.075;
    } else if (salario >= 1518.01 && salario <= 2793.88) {
        INSS = salario * 0.09;
    } else if (salario >= 2793.89 && salario <= 4190.83) {
        INSS = salario * 0.12;
    } else {
        INSS = salario * 0.14;
    }

    return salario + FGTS + indenizacaoCompensatoria + seguroAcidentes + INSSEmpregador + INSS;
}

exports.calcularFerias = ({ salario }) => {
    const ferias = salario / 12;
    const abonoFerias = ferias / 3;
    const INSSEmpregador = (ferias + abonoFerias) * 0.08;
    const seguroAcidentes = (ferias + abonoFerias) * 0.008;
    const FGTS = (ferias + abonoFerias) * 0.08;
    const indenizacaoCompensatoria = (ferias + abonoFerias) * 0.032;

    const totalMensal = ferias + abonoFerias + INSSEmpregador + seguroAcidentes + FGTS + indenizacaoCompensatoria;

    return totalMensal
}

exports.calcularRecisao = () => {}

exports.calcularDecimoTerceiro = ({ salario, mesesTrabalhados }) => {
  if (!salario || typeof salario !== 'number' || salario <= 0) {
    throw new Error("Salário inválido.");
  }

  if (mesesTrabalhados < 0 || mesesTrabalhados > 12) {
    throw new Error("Meses trabalhados deve estar entre 0 e 12.");
  }

  const decimoTerceiroBruto = (salario / 12) * mesesTrabalhados;

  const calcularINSS = (valor) => {
    let inss = 0;
    const faixas = [
      { limite: 1412.00, aliquota: 0.075 },
      { limite: 2666.68, aliquota: 0.09 },
      { limite: 4000.03, aliquota: 0.12 },
      { limite: 7786.02, aliquota: 0.14 }
    ];

    let restante = valor;
    let anterior = 0;

    for (let i = 0; i < faixas.length; i++) {
      const { limite, aliquota } = faixas[i];
      if (valor > limite) {
        inss += (limite - anterior) * aliquota;
        anterior = limite;
      } else {
        inss += (restante) * aliquota;
        break;
      }
    }

    return inss;
  };

  const inss = calcularINSS(decimoTerceiroBruto);
  const decimoTerceiroLiquido = decimoTerceiroBruto - inss;

  return {
    bruto: decimoTerceiroBruto.toFixed(2),
    inss: inss.toFixed(2),
    liquido: decimoTerceiroLiquido.toFixed(2)
  };
};

exports.calcularESocial = () => {}