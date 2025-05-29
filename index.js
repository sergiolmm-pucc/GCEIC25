const express = require('express');
const swaggerUi = require('swagger-ui-express');

const app = express();
app.use(express.json());

// Simula o Swagger com um objeto mínimo só pra exemplo
const swaggerDocument = {
  openapi: "3.0.0",
  info: {
    title: "API Exemplo",
    version: "1.0.0",
  },
  paths: {},
};

app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));

// Rota GET /datetime
app.get('/datetime', (req, res) => {
  res.json({ datetime: new Date().toISOString() });
});

// Rota POST /concat
app.post('/concat', (req, res) => {
  const { value } = req.body;
  res.json({ result: `Você enviou: ${value}` });
});

// Start
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Servidor rodando em http://localhost:${PORT}`);
});
