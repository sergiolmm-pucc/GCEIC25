
// Calcula o multiplicador do markup
exports.calcMultiplierMarkup = (req, res) => {
    const despesasVariaveis = req.body.despesasVariaveis;
    const despesasFixas = req.body.despesasFixas;
    const margemLucro = req.body.margemLucro;
    const markup = (100 / (100 - (despesasVariaveis + despesasFixas + margemLucro))).toFixed(2);

    res.send(markup);
};