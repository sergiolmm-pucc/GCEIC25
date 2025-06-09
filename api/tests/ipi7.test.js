const express = require('express');
const request = require('supertest');

// Ajuste o caminho para refletir o nome correto da rota
const ipiRoutes7 = require('../CI_CD_7/routes/ipiRoutes7');  // Caminho ajustado para a rota correta

const app = express();
app.use(express.json());
app.use('/CI_CD_7/ipi', ipiRoutes7);  // Usando a base de rota /CI_CD_7 corretamente

describe('POST /CI_CD_7/ipi', () => {
  test('Retorna valor do IPI corretamente', async () => {
    const res = await request(app)
      .post('/CI_CD_7/ipi')
      .send({ valorProduto: 200, percentualIPI: 5 })
      .expect(200);

    expect(res.body).toHaveProperty('ipi', '10.00');
  });

  test('Retorna erro se campos estiverem inválidos', async () => {
    const res = await request(app)
      .post('/CI_CD_7/ipi')
      .send({ valorProduto: 'abc', percentualIPI: 5 })
      .expect(400);

    expect(res.body).toHaveProperty('erro', 'Dados inválidos');
  });
});
