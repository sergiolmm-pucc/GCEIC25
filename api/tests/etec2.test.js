const request = require('supertest');
const express = require('express');

// Cria uma instância da app com as rotas
const app = express();
app.use(express.json());
app.use('/', require('../routes/etec2Routes'));

describe('Testes ETEC2', () => {
  test('POST /salario-liquido', async () => {
    const res = await request(app)
      .post('/salario-liquido')
      .send({ salarioBruto: 3000 });

    expect(res.statusCode).toBe(200);
    expect(res.body.salarioLiquido).toBe("2760.00");
  });

  test('POST /inss', async () => {
    const res = await request(app)
      .post('/inss')
      .send({ salarioBruto: 3000 });

    expect(res.statusCode).toBe(200);
    expect(res.body).toEqual({
      inssEmpregado: "240.00",
      inssEmpregador: "240.00"
    });
  });

  test('POST /fgts', async () => {
    const res = await request(app)
      .post('/fgts')
      .send({ salarioBruto: 3000 });

    expect(res.statusCode).toBe(200);
    expect(res.body).toEqual({
      fgtsMensal: "240.00",
      fgtsRescisorio: "96.00"
    });
  });

  test('POST /decimo', async () => {
    const res = await request(app)
      .post('/decimo')
      .send({ salarioBruto: 3000, mesesTrabalhados: 10 });

    expect(res.statusCode).toBe(200);
    expect(res.body.decimoTerceiro).toBe("2500.00");
  });

  test('POST /ferias', async () => {
    const res = await request(app)
      .post('/ferias')
      .send({ salarioBruto: 3000, mesesTrabalhados: 12 });

    expect(res.statusCode).toBe(200);
    expect(res.body.ferias).toBe("4000.00");
  });

  test('POST /total-mensal', async () => {
    const res = await request(app)
      .post('/total-mensal')
      .send({ salarioBruto: 3000 });

    expect(res.statusCode).toBe(200);
    expect(res.body.totalMensal).toBe("3576.00");
  });
});
