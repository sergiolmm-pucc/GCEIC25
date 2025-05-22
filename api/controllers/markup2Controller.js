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

module.exports = {
    calcMultiplierMarkup,
    calcularMarkup,
    auth,
    autentication,
    calcularMarkupDivisor,
    calcDivisorMarkup
};