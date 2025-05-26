const express = require('express');
const swaggerUi = require('swagger-ui-express');
const swaggerDocument = require('./swagger.json');
const cors = require('cors');
const ipiRoutes = require('./routes/ipiRoutes5');
const userRoutes = require('./routes/userRoutes');
const baseRoutes = require('./routes/baseRoutes');
const icmsRoutes = require('./routes/icmsRoutes5');
const irpjRoutes = require('./routes/irpjRoutes5');
const issRoutes = require('./routes/issRoutes5');



const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));
app.use('/', baseRoutes);
app.use('/users', userRoutes);
app.use('/impostos', ipiRoutes);
app.use('/impostos', icmsRoutes); 
app.use('/impostos', irpjRoutes);
app.use('/impostos', issRoutes);

// Só escuta a porta se não estiver em ambiente de testes
if (process.env.NODE_ENV !== 'test') {
  app.listen(port, () => {
    console.log(`Servidor rodando em http://localhost:${port}`);
    console.log(`Swagger em http://localhost:${port}/api-docs`);
  });
}

module.exports = app;
