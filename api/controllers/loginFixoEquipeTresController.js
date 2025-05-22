exports.loginFixoEquipeTres = (req, res) => {
    const { username, password } = req.body;
  
    if (username === 'admin' && password === 'admin123') {
      res.status(200).json({ success: true, message: 'Login efetuado com sucesso' });
    } else {
      res.status(401).json({ success: false, message: 'Usuário ou senha incorretos' });
    }
  };