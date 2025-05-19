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
    if (typeof despesasVariaveis !== 'number' || typeof despesasFixas !== 'number' || typeof margemLucro !== 'number') {
        return "Erro";
    }
    return Number((100 / (100 - (despesasVariaveis + despesasFixas + margemLucro))).toFixed(2));
}

function calcularMarkupDivisor(precoVenda, custoTotalVendas) {
    if (precoVenda === 0) return 0;
    const resultado = Math.abs((precoVenda - custoTotalVendas) / precoVenda);
    return Number(resultado.toFixed(2));
}

function retornarSobre(req, res) {
    res.json({
        "CAIO ACOSTA GONÇALVES": "23008203",
        "ENZO CINTO QUATROCHI": "23015904",
        "JOÃO GABRIEL BIAZON FERREIRA": "23004430",
        "VINICIUS MENDES DA CUNHA": "23015801",
        "TIAGO PEREIRA DA SILVA": "23012171",
    });

    return;
}

module.exports = {
    calcMultiplierMarkup,
    calcularMarkup,
    calcularMarkupDivisor,
    calcDivisorMarkup,
    retornarSobre
};