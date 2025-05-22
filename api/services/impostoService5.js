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

exports.calcularICMS = ({ valorProduto, aliquotaICMS }) => {
  if (valorProduto == null || aliquotaICMS == null) {
    throw new Error('valorProduto e aliquotaICMS são obrigatórios');
  }

  // Converte para números (caso venham como string)
  const valor = Number(valorProduto);
  const aliquota = Number(aliquotaICMS);

  // Verifica se são números válidos
  if (isNaN(valor) || isNaN(aliquota)) {
    throw new Error('Os valores devem ser números válidos');
  }

  // Fórmula do ICMS
  const icms = (valor * aliquota) / (100 + aliquota);

  return {
    valorProduto: valor.toFixed(2),
    aliquotaICMS: aliquota.toFixed(2),
    imposto: icms.toFixed(2),
    valorTotal: (valor + icms).toFixed(2) // Opcional: caso queira retornar o valor total
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
