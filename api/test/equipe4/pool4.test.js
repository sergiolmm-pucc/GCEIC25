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

describe('Testes da rota /eletrico', () => {
  
  it('Deve calcular corretamente com dados válidos', async () => {
    const response = await request(app)
      .post('/pool4/eletrico')
      .send({
        luminaria_qtd: 10,
        luminaria_preco: '50,5',
        fio_metros: 100,
        fio_preco: '2,25',
        comando_qtd: 5,
        comando_preco: '30',
        disjuntor_qtd: 3,
        disjuntor_preco: '40.75',
        programador_qtd: 2,
        programador_preco: '150,5'
      });

    const total = 
      (10 * 50.5) + 
      (100 * 2.25) + 
      (5 * 30) + 
      (3 * 40.75) + 
      (2 * 150.5);

    expect(response.statusCode).toBe(200);
    expect(response.body).toHaveProperty('custo_mensal', total.toFixed(2).replace('.', ','));
  });

  it('Deve retornar erro se uma quantidade tiver vírgula', async () => {
    const response = await request(app)
      .post('/pool4/eletrico')
      .send({
        luminaria_qtd: '10,5', // inválido
        luminaria_preco: '50',
        fio_metros: 100,
        fio_preco: 2,
        comando_qtd: 5,
        comando_preco: 30,
        disjuntor_qtd: 3,
        disjuntor_preco: 40,
        programador_qtd: 2,
        programador_preco: 150
      });

    expect(response.statusCode).toBe(400);
    expect(response.body).toHaveProperty('error');
    expect(response.body.error).toMatch(/luminaria_qtd/);
  });

  it('Deve retornar erro se uma quantidade tiver ponto', async () => {
    const response = await request(app)
      .post('/pool4/eletrico')
      .send({
        luminaria_qtd: '10.5', // inválido
        luminaria_preco: '50',
        fio_metros: 100,
        fio_preco: 2,
        comando_qtd: 5,
        comando_preco: 30,
        disjuntor_qtd: 3,
        disjuntor_preco: 40,
        programador_qtd: 2,
        programador_preco: 150
      });

    expect(response.statusCode).toBe(400);
    expect(response.body).toHaveProperty('error');
    expect(response.body.error).toMatch(/luminaria_qtd/);
  });

  it('Deve aceitar preços no formato brasileiro com milhar e vírgula', async () => {
    const response = await request(app)
      .post('/pool4/eletrico')
      .send({
        luminaria_qtd: 1,
        luminaria_preco: '1.500,75', // formato brasileiro
        fio_metros: 10,
        fio_preco: '2,50',
        comando_qtd: 2,
        comando_preco: '30',
        disjuntor_qtd: 1,
        disjuntor_preco: '40',
        programador_qtd: 1,
        programador_preco: '100'
      });

    const total = 
      (1 * 1500.75) +
      (10 * 2.5) +
      (2 * 30) +
      (1 * 40) +
      (1 * 100);

    expect(response.statusCode).toBe(200);
    expect(response.body).toHaveProperty('custo_mensal', total.toFixed(2).replace('.', ','));
  });

  it('Deve retornar erro se faltar algum campo', async () => {
    const response = await request(app)
      .post('/pool4/eletrico')
      .send({
        luminaria_qtd: 10,
        luminaria_preco: 50,
        fio_metros: 100,
        fio_preco: 2,
        comando_qtd: 5,
        comando_preco: 30,
        // falta disjuntor_qtd e disjuntor_preco
        programador_qtd: 2,
        programador_preco: 150
      });

    expect(response.statusCode).toBe(400);
    expect(response.body).toHaveProperty('error');
  });

  it('Deve retornar erro se algum campo tiver texto inválido', async () => {
    const response = await request(app)
      .post('/pool4/eletrico')
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

    expect(response.statusCode).toBe(400);
    expect(response.body).toHaveProperty('error');
  });

});

describe('Testes da rota /hidraulico', () => {
    
    test('Deve calcular corretamente com dados válidos', async () => {
        const response = await request(app)
            .post('/pool4/hidraulico')
            .query({
                comprimentoTubos: '50',
                custoPorMetro: '10',
                qtdValvulas: '4',
                custoValvula: '15',
                custoBomba: '500',
                custoFiltro: '300',
                tipoTubulacao: 'PVC'
            });

        expect(response.statusCode).toBe(200);
        expect(response.body).toHaveProperty('total');
        expect(response.body.total).toBe(50 * 10 + 4 * 15 + 500 + 300);
        expect(response.body.tipo_tubulacao).toBe('pvc');
    });

    test('Deve retornar erro se faltar algum campo', async () => {
        const response = await request(app)
            .post('/pool4/hidraulico')
            .query({
                comprimentoTubos: '50',
                custoPorMetro: '10',
                // faltando qtdValvulas
                custoValvula: '15',
                custoBomba: '500',
                custoFiltro: '300',
                tipoTubulacao: 'PVC'
            });

        expect(response.statusCode).toBe(400);
        expect(response.body).toHaveProperty('error');
        expect(response.body.error).toMatch(/Preencha todos os campos/);
    });

    test('Deve retornar erro se algum campo for texto inválido', async () => {
        const response = await request(app)
            .post('/pool4/hidraulico')
            .query({
                comprimentoTubos: 'abc', // inválido
                custoPorMetro: '10',
                qtdValvulas: '4',
                custoValvula: '15',
                custoBomba: '500',
                custoFiltro: '300',
                tipoTubulacao: 'PVC'
            });

        expect(response.statusCode).toBe(400);
        expect(response.body).toHaveProperty('error');
        expect(response.body.error).toMatch(/números válidos/);
    });

    test('Deve retornar erro se valores forem negativos', async () => {
        const response = await request(app)
            .post('/pool4/hidraulico')
            .query({
                comprimentoTubos: '-10',
                custoPorMetro: '10',
                qtdValvulas: '4',
                custoValvula: '15',
                custoBomba: '500',
                custoFiltro: '300',
                tipoTubulacao: 'PVC'
            });

        expect(response.statusCode).toBe(400);
        expect(response.body).toHaveProperty('error');
        expect(response.body.error).toMatch(/não negativos/);
    });

    test('Deve retornar tipo de tubulação sempre em minúsculo', async () => {
        const response = await request(app)
            .post('/pool4/hidraulico')
            .query({
                comprimentoTubos: '10',
                custoPorMetro: '20',
                qtdValvulas: '2',
                custoValvula: '30',
                custoBomba: '100',
                custoFiltro: '50',
                tipoTubulacao: 'PEAD'
            });

        expect(response.statusCode).toBe(200);
        expect(response.body.tipo_tubulacao).toBe('pead');
    });

});