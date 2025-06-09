const express = require('express');
const request = require('supertest');
const cofinsRoutes = require('../routes/cofins');

const app = express();
app.use(express.json());
app.use('/CI_CD_7/cofins', cofinsRoutes);

describe('POST /CI_CD_7/cofins', () => {
  test('Calcula COFINS corretamente', async () => {
    const res = await request(app)
      .post('/CI_CD_7/cofins')
      .send({ valorProduto: 150, percentualCOFINS: 7.6 })
      .expect(200);

    expect(res.body).toHaveProperty('cofins');
  });

  test('Erro ao faltar dados', async () => {
    const res = await request(app)
      .post('/CI_CD_7/cofins')
      .send({})
      .expect(400);
  });
});
