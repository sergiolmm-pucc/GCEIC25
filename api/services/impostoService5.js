const jwt = require('jsonwebtoken');

const SECRET_KEY = 'chavesupersecreta';

exports.calcularIPI = ({ valorProduto, aliquotaIPI }) => {
  if (valorProduto == null || aliquotaIPI == null) {
    throw new Error('valorProduto e aliquotaIPI são obrigatórios');
  }

  const ipi = (valorProduto * aliquotaIPI) / 100;

  return {
    valorProduto: valorProduto.toFixed(2),
    aliquotaIPI: aliquotaIPI.toFixed(2),
    imposto: ipi.toFixed(2),
  };
};

exports.loginUser = ({ email, senha }) => {
  const usuarios = [
    { email: 'guilherme@email.com', senha: 'qwerty' }
  ];

  const usuarioEncontrado = usuarios.find(
    user => user.email === email && user.senha === senha
  );

  if (!usuarioEncontrado) {
    return {
      sucesso: false,
      mensagem: 'Email ou senha inválidos!'
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
