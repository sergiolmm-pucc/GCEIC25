const express = require('express');
const request = require('supertest');
const pisRoutes = require('../routes/pis');

const app = express();
app.use(express.json());
app.use('/CI_CD_7/pis', pisRoutes);

describe('POST /CI_CD_7/pis', () => {
  test('Calcula PIS corretamente', async () => {
    const res = await request(app)
      .post('/CI_CD_7/pis')
      .send({ valorProduto: 150, percentualPIS: 1.65 })
      .expect(200);

    expect(res.body).toHaveProperty('pis');
  });

  test('Falha com dados incompletos', async () => {
    const res = await request(app)
      .post('/CI_CD_7/pis')
      .send({})
      .expect(400);
  });
});
