const express = require('express');
const request = require('supertest');
const icmsRoutes = require('../routes/icmsRoutes5');
const icmsService = require('../services/impostoService5');

const app = express();
app.use(express.json());
app.use('/api', icmsRoutes);

// Teste da função de cálculo diretamente pelo service
describe('Cálculo de ICMS - Service', () => {
  test('Calcula corretamente o valor do ICMS', () => {
    const resultado = icmsService.calcularICMS({
      valorProduto: 200,
      aliquotaICMS: 18
    });

    expect(resultado.imposto).toBe('30.51');
  });
});


// Testes da rota POST /api/icms
describe('Rota POST /api/icms', () => {
  test('Retorna o valor do ICMS corretamente', async () => {
    const dados = {
      valorProduto: 200,
      aliquotaICMS: 18
    };

    const response = await request(app)
      .post('/api/icms')
      .send(dados)
      .expect(200);

    expect(response.body).toHaveProperty('imposto', '30.51');
  });

  test('Retorna erro se os campos não forem enviados', async () => {
    const response = await request(app)
      .post('/api/icms')
      .send({})
      .expect(400);

    expect(response.body).toHaveProperty('erro', 'valorProduto e aliquotaICMS são obrigatórios');
  });
});
