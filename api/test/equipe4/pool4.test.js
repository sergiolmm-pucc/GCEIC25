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

describe('Testes da rota /login', () => {
  it('Deve realizar login com sucesso usando credenciais válidas', async () => {
    const response = await request(app)
      .post('/pool4/login')
      .send({
        email: 'adm@adm.com',
        senha: 'adm'
      });

    expect(response.statusCode).toBe(200);
    expect(response.body).toHaveProperty('sucesso', true);
    expect(response.body).toHaveProperty('mensagem', 'Login realizado com sucesso!');
  });

  it('Deve falhar no login com credenciais inválidas', async () => {
    const response = await request(app)
      .post('/pool4/login')
      .send({
        email: 'user@teste.com',
        senha: '123456'
      });

    expect(response.statusCode).toBe(401);
    expect(response.body).toHaveProperty('sucesso', false);
    expect(response.body).toHaveProperty('mensagem', 'E-mail ou senha inválidos.');
  });
});

describe('Testes da rota /agua', () => {
  it('Deve calcular corretamente o custo da água', async () => {
    const response = await request(app)
      .post('/pool4/agua')
      .send({
        volume: '100',
        tarifa: '5.50'
      });

    expect(response.statusCode).toBe(200);
    expect(response.body).toHaveProperty('custo_agua', '550.00');
  });

  it('Deve aceitar números com vírgula no formato brasileiro', async () => {
    const response = await request(app)
      .post('/pool4/agua')
      .send({
        volume: '200,5',
        tarifa: '3,75'
      });

    expect(response.statusCode).toBe(200);
    expect(response.body).toHaveProperty('custo_agua', '751.88');
  });

  it('Deve retornar erro se faltar parâmetros', async () => {
    const response = await request(app)
      .post('/pool4/agua')
      .send({
        volume: '100'
      });

    expect(response.statusCode).toBe(400);
    expect(response.body).toHaveProperty('error', 'Volume e tarifa são obrigatórios.');
  });
});

describe('Testes da rota /manutencao', () => {
  it('Deve calcular corretamente o custo de manutenção mensal', async () => {
    const response = await request(app)
      .post('/pool4/manutencao')
      .send({
        volume: '100',
        produtos_quimicos: '2.5',
        energia_bomba: '150',
        mao_obra: '300'
      });

    expect(response.statusCode).toBe(200);
    expect(response.body).toHaveProperty('custo_mensal', '700.00');
  });

  it('Deve aceitar números no formato brasileiro (vírgula)', async () => {
    const response = await request(app)
      .post('/pool4/manutencao')
      .send({
        volume: '200,5',
        produtos_quimicos: '3,75',
        energia_bomba: '200,50',
        mao_obra: '400,75'
      });

    expect(response.statusCode).toBe(200);
    expect(response.body).toHaveProperty('custo_mensal', '1351.19');
  });

  it('Deve retornar erro se faltar parâmetros', async () => {
    const response = await request(app)
      .post('/pool4/manutencao')
      .send({
        volume: '100',
        produtos_quimicos: '2.5',
        energia_bomba: '150'
        // faltando mao_obra
      });

    expect(response.statusCode).toBe(400);
    expect(response.body).toHaveProperty(
      'error',
      'Todos os campos (volume, produtos_quimicos, energia_bomba, mao_obra) são obrigatórios.'
    );
  });
});
