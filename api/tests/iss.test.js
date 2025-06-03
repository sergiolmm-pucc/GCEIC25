const express = require('express');
const request = require('supertest');
const issRoutes = require('../routes/issRoutes5'); 
const issService = require('../services/impostoService5'); 

const app = express();
app.use(express.json());
app.use('/api', issRoutes);

// Testes da função de serviço (cálculo do ISS)
describe('Cálculo de ISS - Service', () => {
  test('Calcula corretamente o ISS', () => {
    const resultado = issService.calcularISS({
      valorServico: 500,
      aliquotaISS: 5
    });

    expect(resultado.imposto).toBe('25.00'); // 500 * 5%
  });

  test('Lança erro se valorServico ou aliquotaISS não forem fornecidos', () => {
    expect(() => {
      issService.calcularISS({});
    }).toThrow('valorServico e aliquotaISS são obrigatórios');
  });

  test('Lança erro se os valores não forem numéricos', () => {
    expect(() => {
      issService.calcularISS({ valorServico: "abc", aliquotaISS: "xyz" });
    }).toThrow('Os valores devem ser números válidos');
  });
});

// Testes da rota POST /api/iss
describe('Rota POST /api/iss', () => {
  test('Retorna corretamente o valor do ISS', async () => {
    const response = await request(app)
      .post('/api/iss')
      .send({ valorServico: 500, aliquotaISS: 5 })
      .expect(200);

    expect(response.body).toHaveProperty('imposto', '25.00');
  });

  test('Retorna erro se faltar campos obrigatórios', async () => {
    const response = await request(app)
      .post('/api/iss')
      .send({})
      .expect(400);

    expect(response.body).toHaveProperty('erro', 'valorServico e aliquotaISS são obrigatórios');
  });

  test('Retorna erro se os valores não forem numéricos', async () => {
    const response = await request(app)
      .post('/api/iss')
      .send({ valorServico: "abc", aliquotaISS: "xyz" })
      .expect(400);

    expect(response.body).toHaveProperty('erro', 'Os valores devem ser números válidos');
  });
});
