function calcMultiplierMarkup(req, res) {
    const despesasVariaveis = req.body.despesasVariaveis;
    const despesasFixas = req.body.despesasFixas;
    const margemLucro = req.body.margemLucro;
    
    const markup = calcularMarkup(despesasVariaveis, despesasFixas, margemLucro);
    res.send(markup.toString());
}

function calcDivisorMarkup(req, res) {
    const precoVenda = req.body.precoVenda;
    const custoTotalVendas = req.body.custoTotalVendas;
    
    const markup = calcularMarkupDivisor(precoVenda, custoTotalVendas);
    res.send(markup.toString());
}

function calcularMarkup(despesasVariaveis, despesasFixas, margemLucro) {
    return Number((100 / (100 - (despesasVariaveis + despesasFixas + margemLucro))).toFixed(2));
}

function calcularMarkupDivisor(precoVenda, custoTotalVendas) {
    return Number(((precoVenda-custoTotalVendas)/100).toFixed(2));
}

module.exports = {
    calcMultiplierMarkup,
    calcularMarkup,
    calcularMarkupDivisor,
    calcDivisorMarkup
};