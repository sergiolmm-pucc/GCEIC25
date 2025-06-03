const express = require('express');
const request = require('supertest');
const irpjRoutes = require('../routes/irpjRoutes5'); 
const irpjService = require('../services/impostoService5'); 

const app = express();
app.use(express.json());
app.use('/impostos', irpjRoutes);

// Testes da função de serviço (cálculo do IRPJ)
describe('Cálculo de IRPJ - Service', () => {
  test('Lucro Real abaixo do limite (60 mil)', () => {
    const resultado = irpjService.calcularIRPJ({
      lucroTributavel: 50000,
      isLucroReal: true
    });

    expect(resultado.imposto).toBe('7500.00');
    expect(resultado.aliquotaIRPJ).toBe('15.00');
    expect(resultado.regime).toBe('Lucro Real');
  });

  test('Lucro Real acima do limite', () => {
    const resultado = irpjService.calcularIRPJ({
      lucroTributavel: 80000,
      isLucroReal: true
    });

    expect(resultado.imposto).toBe('11000.00');
    expect(Number(resultado.aliquotaIRPJ)).toBeCloseTo(13.75);
    expect(resultado.regime).toBe('Lucro Real');
  });

  test('Lucro Presumido', () => {
    const resultado = irpjService.calcularIRPJ({
      lucroTributavel: 50000,
      isLucroReal: false
    });

    expect(resultado.imposto).toBe('7500.00');
    expect(resultado.aliquotaIRPJ).toBe('15.00');
    expect(resultado.regime).toBe('Lucro Presumido');
  });
});

// Testes da rota POST /impostos/irpj
describe('Rota POST /impostos/irpj', () => {
  test('Retorna IRPJ corretamente - Lucro Real abaixo do limite', async () => {
    const response = await request(app)
      .post('/impostos/irpj')
      .send({ lucroTributavel: 50000, isLucroReal: true })
      .expect(200);

    expect(response.body).toHaveProperty('imposto', '7500.00');
    expect(response.body).toHaveProperty('aliquotaIRPJ', '15.00');
    expect(response.body).toHaveProperty('regime', 'Lucro Real');
  });

  test('Retorna IRPJ corretamente - Lucro Real acima do limite', async () => {
    const response = await request(app)
      .post('/impostos/irpj')
      .send({ lucroTributavel: 80000, isLucroReal: true })
      .expect(200);

    expect(response.body).toHaveProperty('imposto', '11000.00');
    expect(Number(response.body.aliquotaIRPJ)).toBeCloseTo(13.75);
    expect(response.body).toHaveProperty('regime', 'Lucro Real');
  });

  test('Retorna IRPJ corretamente - Lucro Presumido', async () => {
    const response = await request(app)
      .post('/impostos/irpj')
      .send({ lucroTributavel: 50000, isLucroReal: false })
      .expect(200);

    expect(response.body).toHaveProperty('imposto', '7500.00');
    expect(response.body).toHaveProperty('aliquotaIRPJ', '15.00');
    expect(response.body).toHaveProperty('regime', 'Lucro Presumido');
  });

  test('Retorna erro se campo obrigatório faltar', async () => {
    const response = await request(app)
      .post('/impostos/irpj')
      .send({ isLucroReal: true }) // falta lucroTributavel
      .expect(400);

    expect(response.body).toHaveProperty('erro', 'lucroTributavel é obrigatório');
  });

  test('Retorna erro se valor não for numérico', async () => {
    const response = await request(app)
      .post('/impostos/irpj')
      .send({ lucroTributavel: 'abc', isLucroReal: true })
      .expect(400);

    expect(response.body).toHaveProperty('erro', 'O valor deve ser um número válido');
  });
});
