const express = require('express');
const request = require('supertest');
const icmsRoutes = require('../routes/icms');

const app = express();
app.use(express.json());
app.use('/CI_CD_7/icms', icmsRoutes);

describe('POST /CI_CD_7/icms', () => {
  test('Calcula ICMS corretamente', async () => {
    const res = await request(app)
      .post('/CI_CD_7/icms')
      .send({ valorProduto: 100, percentualICMS: 18 })
      .expect(200);

    expect(res.body).toHaveProperty('icms');
  });

  test('Falha com dados inválidos', async () => {
    const res = await request(app)
      .post('/CI_CD_7/icms')
      .send({})
      .expect(400);
  });
});
