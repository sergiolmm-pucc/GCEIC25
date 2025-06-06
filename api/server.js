const express = require('express');
const swaggerUi = require('swagger-ui-express');
const swaggerDocument = require('./swagger.json');
const cors = require('cors');


const app = express();
app.use(express.json());
const port = 5000;

// importa as rotas
const userRoutes = require('./routes/userRoutes')
const baseRoutes = require('./routes/baseRoutes')
const calculationRoutes = require('./routes/calculationRoutes')

app.use(cors()); // Enable CORS for all routes
app.use(express.json());
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));
app.use('/', baseRoutes);
app.use('/users', userRoutes);
app.use('/calculation', calculationRoutes);


app.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
  console.log(`Swagger em http://localhost:${port}/api-docs`);
});
