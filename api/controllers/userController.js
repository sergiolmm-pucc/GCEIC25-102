// Lista todos os usuários
exports.listUsers = (req, res) => {
    res.send('Listando todos os usuários');
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
  