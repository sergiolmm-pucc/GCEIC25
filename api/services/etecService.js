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

exports.calcularFerias = () => {}

exports.calcularRecisao = () => {}

exports.calcularDecimoTerceiro = () => {}

exports.calcularESocial = () => {}