const express = require('express');
const cors = require('cors');
const ipiRoutes = require('./routes/ipiRoutes');

const app = express();

// Middlewares globais
app.use(cors());
app.use(express.json());

// Rotas
app.use('/api', ipiRoutes);

// Rota raiz (opcional)
app.get('/', (req, res) => {
  res.send('API de Impostos rodando!');
});

// Exporta o app para ser usado em outro arquivo (ex: server.js ou testes)
module.exports = app;
