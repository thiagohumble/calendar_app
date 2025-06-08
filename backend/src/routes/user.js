const express = require('express');
const router = express.Router();
const auth = require('../middlewares/auth');

router.get('/profile', auth, (req, res) => {
  res.json({ message: 'Usuário autenticado com sucesso', uid: req.user.uid });
});

module.exports = router;
