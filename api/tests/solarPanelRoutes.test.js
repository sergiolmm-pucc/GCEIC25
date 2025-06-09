const request = require('supertest');
const express = require('express');
const solarPanelRoutes = require('../routes/solarPanelRoutes');

const app = express();
app.use(express.json());
app.use('/solar-panel', solarPanelRoutes);

describe('SolarPanelController Routes', () => {
  describe('POST /solar-panel/calcular', () => {
    it('deve retornar os cálculos corretos com dados válidos', async () => {
      const res = await request(app)
        .post('/solar-panel/calcular')
        .send({
          consumo_mensal_kwh: 300,
          horas_sol_dia: 5,
          tarifa_energia: 0.8,
          preco_medio_conta: 200,
          espaco_disponivel_m2: 20
        });
      expect(res.statusCode).toBe(200);
      expect(res.body).toHaveProperty('potencia_necessaria_kwp');
      expect(res.body).toHaveProperty('quantidade_paineis');
      expect(res.body).toHaveProperty('area_necessaria_m2');
      expect(res.body).toHaveProperty('espaco_disponivel_m2');
      expect(res.body).toHaveProperty('espaco_suficiente');
      expect(res.body).toHaveProperty('custo_total_r$');
      expect(res.body).toHaveProperty('payback_anos');
    });
    it('deve retornar erro se faltar consumo_mensal_kwh', async () => {
      const res = await request(app)
        .post('/solar-panel/calcular')
        .send({ horas_sol_dia: 5, tarifa_energia: 0.8, preco_medio_conta: 200, espaco_disponivel_m2: 20 });
      expect(res.statusCode).toBe(400);
      expect(res.body).toHaveProperty('erro');
    });
    it('deve retornar erro se faltar horas_sol_dia', async () => {
      const res = await request(app)
        .post('/solar-panel/calcular')
        .send({ consumo_mensal_kwh: 300, tarifa_energia: 0.8, preco_medio_conta: 200, espaco_disponivel_m2: 20 });
      expect(res.statusCode).toBe(400);
      expect(res.body).toHaveProperty('erro');
    });
    it('deve retornar erro se faltar tarifa_energia', async () => {
      const res = await request(app)
        .post('/solar-panel/calcular')
        .send({ consumo_mensal_kwh: 300, horas_sol_dia: 5, preco_medio_conta: 200, espaco_disponivel_m2: 20 });
      expect(res.statusCode).toBe(400);
      expect(res.body).toHaveProperty('erro');
    });
    it('deve retornar erro se faltar preco_medio_conta', async () => {
      const res = await request(app)
        .post('/solar-panel/calcular')
        .send({ consumo_mensal_kwh: 300, horas_sol_dia: 5, tarifa_energia: 0.8, espaco_disponivel_m2: 20 });
      expect(res.statusCode).toBe(400);
      expect(res.body).toHaveProperty('erro');
    });
  });

  describe('POST /solar-panel/impacto-ambiental', () => {
    it('deve retornar o impacto ambiental com dados válidos', async () => {
      const res = await request(app)
        .post('/solar-panel/impacto-ambiental')
        .send({ potencia_kwp: 5, cidade_estado: 'São Paulo - SP' });
      expect(res.statusCode).toBe(200);
      expect(res.body).toHaveProperty('co2_evitado_anual_kg');
      expect(res.body).toHaveProperty('arvores_equivalentes');
      expect(res.body).toHaveProperty('distancia_carro_evitada_km');
    });
    it('deve retornar erro se faltar potencia_kwp', async () => {
      const res = await request(app)
        .post('/solar-panel/impacto-ambiental')
        .send({ cidade_estado: 'São Paulo - SP' });
      expect(res.statusCode).toBe(400);
      expect(res.body).toHaveProperty('erro');
    });
    it('deve retornar erro se faltar cidade_estado', async () => {
      const res = await request(app)
        .post('/solar-panel/impacto-ambiental')
        .send({ potencia_kwp: 5 });
      expect(res.statusCode).toBe(400);
      expect(res.body).toHaveProperty('erro');
    });
  });

  describe('POST /solar-panel/orientacao', () => {
    it('deve retornar a orientação ideal com dados válidos', async () => {
      const res = await request(app)
        .post('/solar-panel/orientacao')
        .send({ cep: '69005-070', potencia_kwp: 6, sombra: true });
      expect(res.statusCode).toBe(200);
      expect(res.body.inclinacao_ideal_graus).toBe(3);
      expect(res.body.orientacao_ideal).toBe('Norte geográfico (ideal para o hemisfério sul)');
      expect(res.body.tipo_inversor_recomendado).toBe('Microinversor (ótimo para locais com sombreamento parcial)');
      expect(res.body.tecnologias_paineis_sugeridas).toEqual([
        "Painéis Policristalinos (custo-benefício)",
        "Thin-film (para áreas muito grandes e baixa eficiência exigida)"
      ]);
    });
    it('deve retornar erro se faltar cep', async () => {
      const res = await request(app)
        .post('/solar-panel/orientacao')
        .send({ potencia_kwp: 2.5, sombra: false });
      expect(res.statusCode).toBe(400);
      expect(res.body).toHaveProperty('erro');
    });
    it('deve retornar erro se faltar potencia_kwp', async () => {
      const res = await request(app)
        .post('/solar-panel/orientacao')
        .send({ cep: '13087-571', sombra: false });
      expect(res.statusCode).toBe(400);
      expect(res.body).toHaveProperty('erro');
    });
  });

  describe('POST /solar-panel/login', () => {
    it('deve autenticar com sucesso com credenciais corretas', async () => {
      const res = await request(app)
        .post('/solar-panel/login')
        .send({ username: 'admin', password: '1234' });
      expect(res.statusCode).toBe(200);
      expect(res.body).toHaveProperty('success', true);
      expect(res.body).toHaveProperty('usuario', 'admin');
    });
    it('deve falhar com credenciais incorretas', async () => {
      const res = await request(app)
        .post('/solar-panel/login')
        .send({ username: 'admin', password: 'errado' });
      expect(res.statusCode).toBe(401);
      expect(res.body).toHaveProperty('success', false);
    });
    it('deve falhar se faltar username ou password', async () => {
      const res = await request(app)
        .post('/solar-panel/login')
        .send({ username: 'admin' });
      expect(res.statusCode).toBe(401);
      expect(res.body).toHaveProperty('success', false);
    });
  });
}); 