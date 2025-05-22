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

// POST /auth
function auth (req, res) {
  const { email, senha } = req.body;

  // Credenciais fixas para autenticação

  const isAuth = autentication(email, senha)

  if (isAuth) {
    return res.json({ acesso: 'liberado' });
  } else {
    return res.status(401).json({ acesso: 'negado' });
  }
};

function autentication(email, password) {
    const EMAIL_CORRETO = "admin@email.com";
    const SENHA_CORRETA = "123456";

    if (email === EMAIL_CORRETO && password === SENHA_CORRETA) {
      return true
    } else {
      return false
    }
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

function retornarHome(req, res) {
    res.json({
        "titulo": "Bem vindo! - CI DC - Grupo 8",
        "sobreMarkup" : "O sistema de markup ajuda a calcular o preço de venda com base no custo e na margem desejada, facilitando a precificação de produtos e serviços.",
    });
    return;
}

module.exports = {
    calcMultiplierMarkup,
    calcularMarkup,
    auth,
    autentication,
    calcularMarkupDivisor,
    calcDivisorMarkup,
    retornarSobre,
    retornarHome
};