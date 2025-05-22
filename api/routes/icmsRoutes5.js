const express = require('express');
const router = express.Router();
const { calcularICMS } = require('../services/impostoService5');

router.post('/icms', (req, res) => {
  try {
    const { valorProduto, aliquotaICMS } = req.body;
    
    if (valorProduto === undefined || aliquotaICMS === undefined) {
      return res.status(400).json({ 
        erro: 'valorProduto e aliquotaICMS são obrigatórios' 
      });
    }

    const resultado = calcularICMS({ valorProduto, aliquotaICMS });
    res.status(200).json(resultado);
    
  } catch (error) {
    const statusCode = error.message.includes('obrigatórios') ? 400 : 500;
    res.status(statusCode).json({ erro: error.message });
  }
});

module.exports = router;