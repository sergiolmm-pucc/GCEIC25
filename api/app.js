const express = require('express');
const cors = require('cors');
const ipiRoutes = require('./routes/ipiRoutes5');
const icmsRoutes = require('./routes/icmsRoutes5'); 
const irpjRoutes = require('./routes/irpjRoutes5');
const issRoutes = require('./routes/issRoutes5'); 

const app = express();

// Middlewares globais
app.use(cors());
app.use(express.json());

// Rotas
app.use('/api', ipiRoutes);
app.use('/api', icmsRoutes); 
app.use('/api', irpjRoutes);
app.use('/api', issRoutes); 

// Exporta o app para ser usado em outro arquivo (ex: server.js ou testes)
module.exports = app;