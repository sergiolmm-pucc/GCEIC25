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

describe('Testes da função calcularManutencaoMensal', () => {
  it('Deve calcular corretamente o custo de manutenção mensal com números padrão', async () => {
    const response = await request(app)
      .post('/pool4/manutencao')
      .send({
        produtos_quimicos: '100',
        energia_bomba: '150',
        mao_obra: '200'
      });

    expect(response.statusCode).toBe(200);
    expect(response.body).toHaveProperty('custo_mensal', '450.00');
  });

  it('Deve aceitar números no formato brasileiro (vírgula como decimal)', async () => {
    const response = await request(app)
      .post('/pool4/manutencao')
      .send({
        produtos_quimicos: '100,5',
        energia_bomba: '150,75',
        mao_obra: '200,25'
      });

    const custoEsperado = (100.5 + 150.75 + 200.25).toFixed(2); // 451.50

    expect(response.statusCode).toBe(200);
    expect(response.body).toHaveProperty('custo_mensal', custoEsperado);
  });

  it('Deve aceitar números com ponto como milhar e vírgula como decimal (ex.: "1.000,50")', async () => {
    const response = await request(app)
      .post('/pool4/manutencao')
      .send({
        produtos_quimicos: '1.000,50',
        energia_bomba: '2.500,75',
        mao_obra: '3.000,25'
      });

    const custoEsperado = (1000.5 + 2500.75 + 3000.25).toFixed(2); // 6501.50

    expect(response.statusCode).toBe(200);
    expect(response.body).toHaveProperty('custo_mensal', custoEsperado);
  });

  it('Deve retornar erro se faltar qualquer campo obrigatório', async () => {
    const response = await request(app)
      .post('/pool4/manutencao')
      .send({
        produtos_quimicos: '100',
        energia_bomba: '150'
        // falta mao_obra, poderia ser qualquer outro
      });

    expect(response.statusCode).toBe(400);
    expect(response.body).toHaveProperty(
      'error',
      'Todos os campos (volume, produtos_quimicos, energia_bomba, mao_obra) são obrigatórios.'
    );
  });
});

describe('Testes da função calcularMob', () => {
  it('Deve calcular corretamente o custo total de MOB com valores válidos', async () => {
    const response = await request(app)
      .post('/pool4/mob')
      .send({
        transporte: '100',
        instalacao: '150',
        maoDeObra: '200',
        equipamentos: '50'
      });

    expect(response.statusCode).toBe(200);
    expect(response.body).toMatchObject({
      transporte: 100,
      instalacao: 150,
      maoDeObra: 200,
      equipamentos: 50,
      total: 500
    });
    expect(response.body.mensagem).toBe('O custo total de MOB é R$ 500,00');
  });

  it('Deve retornar erro se faltar algum campo obrigatório', async () => {
    const response = await request(app)
      .post('/pool4/mob')
      .send({
        transporte: '100',
        instalacao: '150',
        maoDeObra: '200'
        // falta equipamentos
      });

    expect(response.statusCode).toBe(400);
    expect(response.body).toHaveProperty('error', 'Todos os campos são obrigatórios.');
  });

  it('Deve retornar erro se algum valor for inválido (não numérico)', async () => {
    const response = await request(app)
      .post('/pool4/mob')
      .send({
        transporte: '100',
        instalacao: 'abc',
        maoDeObra: '200',
        equipamentos: '50'
      });

    expect(response.statusCode).toBe(400);
    expect(response.body).toHaveProperty('error', 'Todos os valores devem ser números válidos e positivos.');
  });

  it('Deve retornar erro se algum valor for negativo', async () => {
    const response = await request(app)
      .post('/pool4/mob')
      .send({
        transporte: '-10',
        instalacao: '150',
        maoDeObra: '200',
        equipamentos: '50'
      });

    expect(response.statusCode).toBe(400);
    expect(response.body).toHaveProperty('error', 'Todos os valores devem ser números válidos e positivos.');
  });
});

describe('Testes da rota /material-eletrico', () => {
  it('Deve calcular corretamente o custo de material elétrico com valores válidos', async () => {
    const response = await request(app)
      .post('/pool4/material-eletrico')
      .send({
        luminaria_qtd: 10,
        luminaria_preco: 50,
        fio_metros: 100,
        fio_preco: 2,
        comando_qtd: 5,
        comando_preco: 30,
        disjuntor_qtd: 3,
        disjuntor_preco: 40,
        programador_qtd: 2,
        programador_preco: 150
      });

    const custoEsperado = (
      (10 * 50) + 
      (100 * 2) + 
      (5 * 30) + 
      (3 * 40) + 
      (2 * 150)
    ).toFixed(2); // 500 + 200 + 150 + 120 + 300 = 1270.00

    expect(response.statusCode).toBe(200);
    expect(response.body).toHaveProperty('custo_mensal', custoEsperado);
  });

  it('Deve retornar erro se faltar algum campo obrigatório', async () => {
    const response = await request(app)
      .post('/pool4/material-eletrico')
      .send({
        luminaria_qtd: 10,
        luminaria_preco: 50,
        // faltando fio_metros e fio_preco
        comando_qtd: 5,
        comando_preco: 30,
        disjuntor_qtd: 3,
        disjuntor_preco: 40,
        programador_qtd: 2,
        programador_preco: 150
      });

    expect(response.statusCode).toBe(400);
    expect(response.body).toHaveProperty('error', 'Todos os campos são obrigatórios.');
  });

  it('Deve retornar erro se algum valor for inválido (não numérico)', async () => {
    const response = await request(app)
      .post('/pool4/material-eletrico')
      .send({
        luminaria_qtd: 'dez', // inválido
        luminaria_preco: 50,
        fio_metros: 100,
        fio_preco: 2,
        comando_qtd: 5,
        comando_preco: 30,
        disjuntor_qtd: 3,
        disjuntor_preco: 40,
        programador_qtd: 2,
        programador_preco: 150
      });

    expect(response.statusCode).toBe(500);
    expect(response.body).toHaveProperty('error', 'Erro ao processar os dados.');
  });

  it('Deve calcular corretamente usando números no formato string que representam números válidos', async () => {
    const response = await request(app)
      .post('/pool4/material-eletrico')
      .send({
        luminaria_qtd: '10',
        luminaria_preco: '50',
        fio_metros: '100',
        fio_preco: '2',
        comando_qtd: '5',
        comando_preco: '30',
        disjuntor_qtd: '3',
        disjuntor_preco: '40',
        programador_qtd: '2',
        programador_preco: '150'
      });

    const custoEsperado = (
      (10 * 50) + 
      (100 * 2) + 
      (5 * 30) + 
      (3 * 40) + 
      (2 * 150)
    ).toFixed(2); // 1270.00

    expect(response.statusCode).toBe(200);
    expect(response.body).toHaveProperty('custo_mensal', custoEsperado);
  });
});

