const express = require('express');
const request = require('supertest');
const ipiRoutes = require('../routes/ipi');

const app = express();
app.use(express.json());
app.use('/CI_CD_7/ipi', ipiRoutes);

describe('POST /CI_CD_7/ipi', () => {
  test('Retorna valor do IPI corretamente', async () => {
    const res = await request(app)
      .post('/CI_CD_7/ipi')
      .send({ valorProduto: 200, percentualIPI: 5 })
      .expect(200);

    expect(res.body).toHaveProperty('ipi');
  });

  test('Retorna erro se campos estiverem inválidos', async () => {
    const res = await request(app)
      .post('/CI_CD_7/ipi')
      .send({})
      .expect(400);
  });
});
