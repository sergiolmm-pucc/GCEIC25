function calcularPotenciaNecessaria(consumoMensalKwh, horasSolDia) {
    return consumoMensalKwh / (30 * horasSolDia);
}

function calcularAreaNecessaria(qtdPaineis, areaPainelM2 = 1.6) {
    return qtdPaineis * areaPainelM2;
}

module.exports = {
    calcularPotenciaNecessaria,
    calcularAreaNecessaria
};