const jwt = require('jsonwebtoken');

const SECRET_KEY = 'seusegredoaqui';


exports.calcularTodosCustos = ({ largura, comprimento, profundidade, precoAgua, custoEletrico, custoHidraulico, custoManutencaoMensal, mesesManutencao = 12 }) => {
  const volume = largura * comprimento * profundidade;
  const custoAgua = volume * precoAgua;

  const custoConstrucao = custoAgua + custoEletrico + custoHidraulico;
  const custoManutencaoTotal = custoManutencaoMensal * mesesManutencao;

  const custoTotalPiscina = custoConstrucao + custoManutencaoTotal;

  return {
    custoTotalPiscina: custoTotalPiscina.toFixed(2)
  };
};


exports.loginUser = ({ email, senha }) => {
  const usuariosFake = [
    { email: 'usuario1@email.com', senha: '123456' },
    { email: 'usuario2@email.com', senha: 'abcdef' }
  ];

  const usuarioEncontrado = usuariosFake.find(
    user => user.email === email && user.senha === senha
  );

  if (!usuarioEncontrado) {
    return {
      sucesso: false,
      mensagem: 'Usuário ou senha inválidos'
    };
  }

  const token = jwt.sign(
    { email: usuarioEncontrado.email },
    SECRET_KEY,
    { expiresIn: '1h' }  
  );

  return {
    sucesso: true,
    mensagem: 'Login realizado com sucesso',
    usuario: {
      email: usuarioEncontrado.email
    },
    token 
  };
};

exports.sobre = (req, res) => {
  const urlFoto = 'https://sep-bucket-prod.s3.amazonaws.com/wp-content/uploads/2022/11/51981800313_fb744fd72d_o.jpg';

  res.json({
    sucesso: true,
    mensagem: 'Foto do time',
    url: urlFoto
  });
};

exports.getSplashData = () => {
  return {
    mensagem: "Bem-vindo à PiscinaApp!",
    versao: "1.0.0",
    atualizacaoDisponivel: false,
    timestamp: new Date().toISOString() // Formata a data em string ISO 8601
  };
};