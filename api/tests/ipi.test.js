const express = require('express');
const request = require('supertest');
const ipiRoutes = require('../routes/ipiRoutes5');
const ipiService = require('../services/impostoService5');

const app = express();
app.use(express.json());
app.use('/impostos', ipiRoutes);

// Teste da função de cálculo diretamente pelo service
describe('Cálculo de IPI - Service', () => {
  test('Calcula corretamente o IPI com valorProduto e aliquotaIPI', () => {
    const resultado = ipiService.calcularIPI({
      valorProduto: 100,
      aliquotaIPI: 10
    });

    expect(resultado.imposto).toBe('10.00');
    expect(resultado.baseCalculo).toBe('100.00');
  });

  test('Calcula corretamente o IPI com frete e despesas acessórias', () => {
    const resultado = ipiService.calcularIPI({
      valorProduto: 100,
      aliquotaIPI: 10,
      frete: 50,
      despesasAcessorias: 50
    });

    expect(resultado.baseCalculo).toBe('200.00');
    expect(resultado.imposto).toBe('20.00');
  });
});

// Testes da rota POST /impostos/ipi
describe('Rota POST /impostos/ipi', () => {
  test('Retorna o valor do IPI corretamente', async () => {
    const response = await request(app)
      .post('/impostos/ipi')
      .send({ valorProduto: 100, aliquotaIPI: 10 })
      .expect(200);

    expect(response.body).toHaveProperty('imposto', '10.00');
    expect(response.body).toHaveProperty('baseCalculo', '100.00');
  });

  test('Calcula o IPI com frete e despesas acessórias corretamente', async () => {
    const response = await request(app)
      .post('/impostos/ipi')
      .send({
        valorProduto: 100,
        aliquotaIPI: 10,
        frete: 50,
        despesasAcessorias: 50
      })
      .expect(200);

    expect(response.body).toHaveProperty('baseCalculo', '200.00');
    expect(response.body).toHaveProperty('imposto', '20.00');
  });

  test('Retorna erro se faltar campos obrigatórios', async () => {
    const response = await request(app)
      .post('/impostos/ipi')
      .send({ valorProduto: 100 }) 
      .expect(400);

    expect(response.body).toHaveProperty('erro', 'valorProduto e aliquotaIPI são obrigatórios');
  });
});
