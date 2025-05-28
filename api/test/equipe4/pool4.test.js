const request = require('supertest');
const express = require('express');
const pool4Router = require('../../routes/pool4Routes');

const app = express();
app.use(express.json());
app.use('/pool4', pool4Router);

describe('Testes da rota /calcular-volume', () => {
  it('Deve calcular volume de piscina retangular corretamente', async () => {
    const response = await request(app)
      .post('/pool4/calcular-volume')
      .send({
        tipo_piscina: 'retangular',
        'Comprimento (m)': 10,
        'Largura (m)': 5,
        'Profundidade (m)': 2
      });

    expect(response.statusCode).toBe(200);
    expect(response.body).toHaveProperty('volume', 100);
    expect(response.body.sucesso).toBe(true);
  });

  it('Deve retornar erro se faltar tipo de piscina', async () => {
    const response = await request(app)
      .post('/pool4/calcular-volume')
      .send({
        'Comprimento (m)': 10,
        'Largura (m)': 5,
        'Profundidade (m)': 2
      });

    expect(response.statusCode).toBe(400);
    expect(response.body).toHaveProperty('error', 'Tipo de piscina é obrigatório.');
  });
});
