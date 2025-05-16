function calcMultiplierMarkup(req, res) {
    const despesasVariaveis = req.body.despesasVariaveis;
    const despesasFixas = req.body.despesasFixas;
    const margemLucro = req.body.margemLucro;
    
    const markup = calcularMarkup(despesasVariaveis, despesasFixas, margemLucro);
    res.send(markup.toString());
}

function calcularMarkup(despesasVariaveis, despesasFixas, margemLucro) {
    return Number((100 / (100 - (despesasVariaveis + despesasFixas + margemLucro))).toFixed(2));
}

module.exports = {
    calcMultiplierMarkup,
    calcularMarkup
};