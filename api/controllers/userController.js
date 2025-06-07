// Lista todos os usuários
exports.listUsers = (req, res) => {
  const now = new Date();
  res.json({
    datetime: now.toISOString(),
    usuario: "sergio", 
    turma: "101",
    aula: "presencial"
  });
  };

exports.login = (req, res) => {
  const { username, password } = req.body;
  
  // Exemplo de usuario e senha fixos
  if (username === "admin" && password === "1234") {
    res.json({
      success: true,
      message: "Login bem-sucedido",
      usuario: username
    });
  }
  else {
    res.status(401).json({
      success: false,
      message: "Usuário ou senha inválidos"
    });
  }	

};

  // Pega um usuário pelo ID
  exports.getUserById = (req, res) => {
    const userId = req.params.id;
    res.send(`Buscando usuário com ID: ${userId}`);
  };
  
  // Cria um novo usuário
  exports.createUser = (req, res) => {
    res.send('Criando um novo usuário');
  };
  
