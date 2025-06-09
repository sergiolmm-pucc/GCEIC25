const request = require('supertest');
const express = require('express');
const mkp1Routes = require('../routes/mkp1Routes');
const { describe, it, expect } = require('@jest/globals');

const app = express();
app.use(express.json());
app.use('/mkp1', mkp1Routes);

describe('MKP1 API Tests', () => {
  // Teste do cálculo simples
  describe('POST /mkp1/markup-simples', () => {
    it('deve calcular markup simples corretamente', async () => {
      const response = await request(app)
        .post('/mkp1/markup-simples')
        .send({
          custo: 100,
          lucro: 50 // 50%
        });

      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('Preço de Venda');
      expect(parseFloat(response.body['Preço de Venda'])).toBe(150.00);
    });

    it('deve retornar erro quando faltar parâmetros', async () => {
      const response = await request(app)
        .post('/mkp1/markup-simples')
        .send({
          custo: 100
        });

      expect(response.status).toBe(400);
      expect(response.body).toHaveProperty('error');
    });
  });

  // Teste do cálculo detalhado
  describe('POST /mkp1/markup-detalhado', () => {
    it('deve calcular markup detalhado corretamente', async () => {
      const response = await request(app)
        .post('/mkp1/markup-detalhado')
        .send({
          custo: 100,
          lucro: 30,      // 30%
          despesas: 20,   // 20%
          impostos: 10    // 10%
        });

      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('Preço de Venda');
      expect(parseFloat(response.body['Preço de Venda'])).toBe(160.00);
    });

    it('deve retornar erro quando faltar parâmetros', async () => {
      const response = await request(app)
        .post('/mkp1/markup-detalhado')
        .send({
          custo: 100,
          lucro: 30
        });

      expect(response.status).toBe(400);
      expect(response.body).toHaveProperty('error');
    });
  });

  // Teste da sugestão de preço
  describe('POST /mkp1/sugestao-preco', () => {
    it('deve calcular sugestão de preço corretamente', async () => {
      const response = await request(app)
        .post('/mkp1/sugestao-preco')
        .send({
          custo: 100,
          concorrentes: [120, 130, 125]
        });

      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('Preço Sugerido');
      expect(parseFloat(response.body['Preço Sugerido'])).toBe(112.5);
    });

    it('deve retornar erro quando faltar parâmetros', async () => {
      const response = await request(app)
        .post('/mkp1/sugestao-preco')
        .send({
          custo: 100
        });

      expect(response.status).toBe(400);
      expect(response.body).toHaveProperty('error');
    });
  });

  // Teste do cálculo de lucro obtido
  describe('POST /mkp1/lucro-obtido', () => {
    it('deve calcular lucro obtido corretamente', async () => {
      const response = await request(app)
        .post('/mkp1/lucro-obtido')
        .send({
          custo: 100,
          precoVenda: 150
        });

      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('Lucro Obtido');
      expect(response.body['Lucro Obtido']).toBe('50.00');
    });

    it('deve retornar erro quando faltar parâmetros', async () => {
      const response = await request(app)
        .post('/mkp1/lucro-obtido')
        .send({
          custo: 100
        });

      expect(response.status).toBe(400);
      expect(response.body).toHaveProperty('error');
    });
  });
}); 
