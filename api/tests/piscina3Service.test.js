const express = require('express');
const request = require('supertest');
const piscinaRoutes = require('../routes/piscina3Routes');
const piscinaService = require('../services/piscina3Service');

const app = express();
app.use(express.json());
app.use('/MOB3', piscinaRoutes);

// Teste de cálculo de manutenção
describe('cálculo de manutenção', () => {
  test('Calcula corretamente o custo de manutenção', () => {
    const dados = {
      custoProdutosLimpeza: 300,
      custoMaoDeObra: 1200,
      custoTrocaFiltro: 250
    };

    const resultado = piscinaService.calcularTodosCustos(dados);

    expect(resultado).toEqual({
      custoProdutosLimpeza: '300.00',
      custoMaoDeObra: '1200.00',
      custoTrocaFiltro: '250.00',
      custoTotalPiscina: '1750.00'
    });
  });
});

// Rota GET /ajuda
describe(' rota GET /ajuda', () => {
  test('Retorna o texto de ajuda corretamente', async () => {
    const response = await request(app)
      .get('/MOB3/ajuda')
      .expect(200);

    expect(response.body).toHaveProperty('titulo', 'Ajuda');
    expect(response.body).toHaveProperty('texto');
    expect(response.body.texto).toMatch(/Preencha os dados/);
  });
});

describe('cálculo elétrico', () => {
  test('Calcula corretamente o custo elétrico', () => {
    const dadosEletricos = {
      comprimentoFios: 100,      // metros de fio
      precoPorMetroFio: 5,       // preço por metro
      quantidadeDisjuntores: 2,  // número de disjuntores
      precoPorDisjuntor: 100,    // preço por disjuntor
      custoMaoDeObra: 200        // custo da mão de obra
    };

    // cálculo esperado: (100*5) + (2*100) + 200 = 500 + 200 + 200 = 900.00
    const resultadoEletrico = piscinaService.calcularEletrica(dadosEletricos);
    expect(resultadoEletrico.custoTotalEletrico).toBe('900.00');
  });
});

describe('cálculo hidráulico', () => {
  test('Calcula corretamente o custo hidráulico', () => {
    const dadosHidraulicos = {
      quantidadeTubulacao: 50,        // metros de tubulação
      precoPorMetroTubulacao: 10,     // preço por metro tubulação
      quantidadeConexoes: 5,          // número de conexões
      precoPorConexao: 20,            // preço por conexão
      custoMaoDeObra: 150             // custo da mão de obra
    };

    // cálculo esperado: (50*10) + (5*20) + 150 = 500 + 100 + 150 = 750.00
    const resultadoHidraulico = piscinaService.calcularHidraulica(dadosHidraulicos);
    expect(resultadoHidraulico.custoTotalHidraulico).toBe('750.00');
  });
});

describe('cálculo custo total geral', () => {
  test('Calcula corretamente o custo total geral somando manutenção, elétrica e hidráulica', () => {
    const dados = {
      custoManutencao: 1200,
      custoEletrica: 900,
      custoHidraulica: 750
    };

    const resultado = piscinaService.calcularCustoTotalGeral(dados);

    expect(resultado).toEqual({
      custoManutencao: '1200.00',
      custoEletrica: '900.00',
      custoHidraulica: '750.00',
      custoTotalGeral: '2850.00'  // soma: 1200 + 900 + 750
    });
  });
});

