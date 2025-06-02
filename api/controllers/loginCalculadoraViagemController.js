exports.login = (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
      res.status(401).json({ success: false, message: 'Forneça o usuário e a senha.' });
  }

  if (username === 'tester' && password === 'teste123') {
    res.status(200).json({ success: true, message: 'Login efetuado com sucesso!' });
  } else {
    res.status(401).json({ success: false, message: 'Usuário ou senha incorretos.' });
  }
};