// Dados fixos
const EMAIL_FIXO = "email@teste.com";
const SENHA_FIXA = "senha";

// Rota de login
exports.login = (req, res) => {
  const { email, senha } = req.body;

  if (email === EMAIL_FIXO && senha === SENHA_FIXA) {
    res.json({ mensagem: "Login realizado com sucesso!" });
  } else {
    res.status(401).json({ mensagem: "Email ou senha incorretos." });
  }
};