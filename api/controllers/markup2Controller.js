function calcMultiplierMarkup(req, res) {
    const despesasVariaveis = req.body.despesasVariaveis;
    const despesasFixas = req.body.despesasFixas;
    const margemLucro = req.body.margemLucro;
    
    const markup = calcularMarkup(despesasVariaveis, despesasFixas, margemLucro);
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
    const EMAIL_CORRETO = "admin@exemplo.com";
    const SENHA_CORRETA = "123456";

    if (email === EMAIL_CORRETO && password === SENHA_CORRETA) {
      return true
    } else {
      return false
    }
}

module.exports = {
    calcMultiplierMarkup,
    calcularMarkup,
    auth,
    autentication
};