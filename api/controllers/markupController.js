exports.markupMultiplicador = (req, res) => {

    // https://sebrae.com.br/sites/PortalSebrae/artigos/markup-saiba-calcular-para-definir-precos-com-seguranca,94b3013555956810VgnVCM1000001b00320aRCRD
    
    // formula Markup: M = 100/[100-(DV+DF+ML)]
    // despesasVariaveis (DV)
    // despesasFixas (DF)
    // margemLucro (ML)

    // custo para calcular preco de venda depois

    const { custo, despesasVariaveis, despesasFixas, margemLucro } = req.body;

    // todos os campos sao obrigatorios
    if (custo === undefined || despesasVariaveis === undefined || despesasFixas === undefined || margemLucro === undefined) {
        return res.status(400).json({ error: 'Campos obrigatórios: custo, despesasVariaveis, despesasFixas, margemLucro' });
    }

    // %
    const totalPercentual = despesasVariaveis + despesasFixas + margemLucro;

    // divisao por zero ou resultado invalido
    if (totalPercentual >= 100) {
        return res.status(400).json({ error: 'A soma de despesas e margem de lucro não pode ser igual ou maior que 100%' });
    }

    // markup
    const markup = 100 / (100 - totalPercentual);

    // preco de venda do produto (custo * markup)
    const precoVenda = custo * markup;

    res.json({ 
        markup: markup.toFixed(4), 
        precoVenda: precoVenda.toFixed(2) 
    });
};

/*

exemplo de body json p teste -> ok

{
  "custo": 100,
  "despesasVariaveis": 10,
  "despesasFixas": 15,
  "margemLucro": 20
}

*/