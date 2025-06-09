const express = require('express');
const request = require('supertest');
const cofinsRoutes7 = require('../routes/cofinsRoutes7');

const app = express();
app.use(express.json());
app.use('/impostos/cofins', cofinsRoutes7);

describe('POST /impostos/cofins', () => {
  test('Retorna valor do COFINS corretamente', async () => {
    const res = await request(app)
      .post('/impostos/cofins')
      .send({ valorProduto: 150, percentualCOFINS: 7.6 })
      .expect(200);

    expect(res.body).toHaveProperty('cofins', '11.40');
  });

  test('Retorna erro se percentual for string', async () => {
    const res = await request(app)
      .post('/impostos/cofins')
      .send({ valorProduto: 100, percentualCOFINS: 'xyz' })
      .expect(400);

    expect(res.body).toHaveProperty('erro', 'Dados inválidos');
  });
});
