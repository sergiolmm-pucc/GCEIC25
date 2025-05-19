const express = require('express');
const swaggerUi = require('swagger-ui-express');
const swaggerDocument = require('./swagger.json');
const cors = require('cors');
const ipiRoutes = require('./routes/ipiRoutes');
const userRoutes = require('./routes/userRoutes');
const baseRoutes = require('./routes/baseRoutes');

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));
app.use('/', baseRoutes);
app.use('/users', userRoutes);
app.use('/impostos', ipiRoutes);

// Só escuta a porta se não estiver em ambiente de testes
if (process.env.NODE_ENV !== 'test') {
  app.listen(port, () => {
    console.log(`Servidor rodando em http://localhost:${port}`);
    console.log(`Swagger em http://localhost:${port}/api-docs`);
  });
}

module.exports = app;
