// Lista todos os usuários
exports.listUsers = (req, res) => {
  const now = new Date();
  res.json({
    datetime: now.toISOString(),
    usuario: "sergio", 
    turma: "101",
    aula: "presencial",
  });
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
  
