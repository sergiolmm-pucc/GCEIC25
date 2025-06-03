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

  return (
    salario +
    FGTS +
    indenizacaoCompensatoria +
    seguroAcidentes +
    INSSEmpregador +
    INSS
  );
};

exports.calcularFerias = ({ salario }) => {
  const ferias = salario / 12;
  const abonoFerias = ferias / 3;
  const INSSEmpregador = (ferias + abonoFerias) * 0.08;
  const seguroAcidentes = (ferias + abonoFerias) * 0.008;
  const FGTS = (ferias + abonoFerias) * 0.08;
  const indenizacaoCompensatoria = (ferias + abonoFerias) * 0.032;

  const totalMensal =
    ferias +
    abonoFerias +
    INSSEmpregador +
    seguroAcidentes +
    FGTS +
    indenizacaoCompensatoria;

  return totalMensal;
};

exports.calcularDecimoTerceiro = ({ salario, mesesTrabalhados }) => {
  if (!salario || typeof salario !== "number" || salario <= 0) {
    throw new Error("Salário inválido.");
  }

  if (mesesTrabalhados < 0 || mesesTrabalhados > 12) {
    throw new Error("Meses trabalhados deve estar entre 0 e 12.");
  }

  const decimoTerceiroBruto = (salario / 12) * mesesTrabalhados;

  const calcularINSS = (valor) => {
    let inss = 0;
    const faixas = [
      { limite: 1412.0, aliquota: 0.075 },
      { limite: 2666.68, aliquota: 0.09 },
      { limite: 4000.03, aliquota: 0.12 },
      { limite: 7786.02, aliquota: 0.14 },
    ];

    let restante = valor;
    let anterior = 0;

    for (let i = 0; i < faixas.length; i++) {
      const { limite, aliquota } = faixas[i];
      if (valor > limite) {
        inss += (limite - anterior) * aliquota;
        anterior = limite;
      } else {
        inss += restante * aliquota;
        break;
      }
    }

    return inss;
  };

  const inss = calcularINSS(decimoTerceiroBruto);
  const decimoTerceiroLiquido = decimoTerceiroBruto - inss;

  return {
    bruto: parseFloat(decimoTerceiroBruto.toFixed(2)),
    inss: parseFloat(inss.toFixed(2)),
    liquido: parseFloat(decimoTerceiroLiquido.toFixed(2)),
  };
};

exports.calcularRecisao = ({
  salarioBase,
  mesesTrabalhados,
  diasTrabalhados,
  motivo = "semJustaCausa",
  feriasVencidas = false,
}) => {
  if (!salarioBase || typeof salarioBase !== "number" || salarioBase <= 0) {
    throw new Error("Salário base inválido.");
  }
  if (
    !mesesTrabalhados ||
    typeof mesesTrabalhados !== "number" ||
    mesesTrabalhados < 0
  ) {
    throw new Error("Meses trabalhados inválidos.");
  }
  if (
    !diasTrabalhados ||
    typeof diasTrabalhados !== "number" ||
    diasTrabalhados < 0 ||
    diasTrabalhados > 31
  ) {
    throw new Error("Dias trabalhados inválidos.");
  }

  let recisao = 0;
  const saldoSalario = (salarioBase / 30) * diasTrabalhados;
  const feriasProporcionais = (salarioBase / 12) * (mesesTrabalhados % 12);
  const valorFeriasProporcionais =
    feriasProporcionais + feriasProporcionais / 3;

  const decimoTerceiroProporcional =
    (salarioBase / 12) * (mesesTrabalhados % 12);
  const fgts = salarioBase * 0.08 * mesesTrabalhados;
  const multaFgts = fgts * 0.4;

  switch (motivo) {
    case "semJustaCausa":
      recisao =
        saldoSalario +
        salarioBase +
        (feriasVencidas
          ? valorFeriasProporcionais + salarioBase + salarioBase / 3
          : valorFeriasProporcionais) +
        decimoTerceiroProporcional +
        fgts +
        multaFgts;
      return {
        recisao: parseFloat(recisao.toFixed(2)),
        avisoPrevio: salarioBase,
        saldoSalario: parseFloat(saldoSalario.toFixed(2)),
        ferias: parseFloat(
          (feriasVencidas
            ? valorFeriasProporcionais + salarioBase + salarioBase / 3
            : valorFeriasProporcionais
          ).toFixed(2)
        ),
        decimoTerceiro: parseFloat(decimoTerceiroProporcional.toFixed(2)),
        fgts: parseFloat(fgts.toFixed(2)),
        multaFgts: parseFloat(multaFgts.toFixed(2)),
      };
    case "JustaCausa":
      recisao =
        saldoSalario + (feriasVencidas ? salarioBase + salarioBase / 3 : 0);
      return {
        recisao: parseFloat(recisao.toFixed(2)),
        saldoSalario: parseFloat(saldoSalario.toFixed(2)),
        ferias: parseFloat(
          (feriasVencidas ? salarioBase + salarioBase / 3 : 0).toFixed(2)
        ),
      };
    case "PedidoDemissao":
      recisao =
        saldoSalario +
        (feriasVencidas
          ? salarioBase + salarioBase / 3 + valorFeriasProporcionais
          : valorFeriasProporcionais) +
        decimoTerceiroProporcional -
        salarioBase;
      return {
        recisao: parseFloat(recisao.toFixed(2)),
        saldoSalario: parseFloat(saldoSalario.toFixed(2)),
        ferias: parseFloat(
          (feriasVencidas
            ? salarioBase + salarioBase / 3 + valorFeriasProporcionais
            : valorFeriasProporcionais
          ).toFixed(2)
        ),
        decimoTerceiro: parseFloat(decimoTerceiroProporcional.toFixed(2)),
        descontoAvisoPrevio: salarioBase,
      };
    default:
      throw new Error(
        "Opção de rescisão inválida. Escolha entre 'semJustaCausa', 'JustaCausa' ou 'PedidoDemissao'."
      );
  }
};

exports.calcularESocial = ({ salario, dependentes = 0 }) => {
  if (!salario || salario <= 0 || typeof salario !== "number")
    throw new Error("Salário inválido.");
  if (!dependentes || dependentes > 9 || typeof dependentes !== "number")
    throw new Error("Número de dependentes inválido.");

  let totalTributosDoPatrao = 0;
  const INSSTributosDoPatrao = salario * 0.08;
  const gilratTributosDoPatrao = salario * 0.008;
  const FGTSTributosDoPatrao = salario * 0.08;
  const antecipacaoDaMultaDe40PorCentoTributosDoPatrao = salario * 0.032;

  totalTributosDoPatrao =
    INSSTributosDoPatrao +
    gilratTributosDoPatrao +
    FGTSTributosDoPatrao +
    antecipacaoDaMultaDe40PorCentoTributosDoPatrao;

  function calcularINSS2025(salario) {
    let inss = 0;

    if (salario <= 1518.0) {
      inss = salario * 0.075;
    } else if (salario <= 2793.88) {
      inss = 1518.0 * 0.075 + (salario - 1518.0) * 0.09;
    } else if (salario <= 4190.83) {
      inss =
        1518.0 * 0.075 + (2793.88 - 1518.0) * 0.09 + (salario - 2793.88) * 0.12;
    } else {
      const teto = 8157.41;
      const base = Math.min(salario, teto);
      inss =
        1518.0 * 0.075 +
        (2793.88 - 1518.0) * 0.09 +
        (4190.83 - 2793.88) * 0.12 +
        (base - 4190.83) * 0.14;
    }

    return Number(inss.toFixed(2));
  }

  const inssEmpregado = calcularINSS2025(salario);

  const deducaoPorDependentes = dependentes * 189.59;
  const descontoSimplificado = 607.2;

  const baseComDeducoes = salario - inssEmpregado - deducaoPorDependentes;
  const baseComDescontoSimplificado = salario - descontoSimplificado;
  const baseIRRF = Math.max(baseComDeducoes, baseComDescontoSimplificado);

  function calcularIRRF(base) {
    if (base <= 3036.0) return 0;
    if (base <= 3751.05) return base * 0.075 - 169.44;
    if (base <= 4664.68) return base * 0.15 - 381.44;
    return base * 0.225 - 662.77;
  }

  const impostoDeRendaDoEmpregado = calcularIRRF(baseIRRF);

  const totalTributosDoEmpregado = inssEmpregado + impostoDeRendaDoEmpregado;

  function calcularValorRessarcidoFamilia(salario, dependentes) {
    let valorRessarcidoFamilia = 0;

    if (salario <= 1819.26 && dependentes > 0) {
      const valorPorDependente = 62.04;
      valorRessarcidoFamilia = dependentes * valorPorDependente;
    }

    return Number(valorRessarcidoFamilia.toFixed(2));
  }

  const valorRessarcidoFamilia = calcularValorRessarcidoFamilia(
    salario,
    dependentes
  );

  // Total a ser pago no eSocial: patrão + empregado - salário-família
  const totaleSocial =
    totalTributosDoPatrao + totalTributosDoEmpregado - valorRessarcidoFamilia;

  return Number(totaleSocial.toFixed(2));
};
