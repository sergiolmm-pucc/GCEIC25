const express = require('express');
const request = require('supertest');
const ipiRoutes = require('../routes/ipiRoutes7'); // ajuste para o nome correto

const app = express();
app.use(express.json());
app.use('/impostos/ipi', ipiRoutes);

describe('POST /impostos/ipi', () => {
  test('Retorna valor do IPI corretamente', async () => {
    const res = await request(app)
      .post('/impostos/ipi')
      .send({ valorProduto: 200, percentualIPI: 5 })
      .expect(200);

    expect(res.body).toHaveProperty('ipi', '10.00');
  });

  test('Retorna erro se campos estiverem inválidos', async () => {
    const res = await request(app)
      .post('/impostos/ipi')
      .send({ valorProduto: 'abc', percentualIPI: 5 })
      .expect(400);

    expect(res.body).toHaveProperty('erro', 'Dados inválidos');
  });
});
