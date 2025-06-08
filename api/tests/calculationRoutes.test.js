const request = require('supertest');
const app = require('../server');

describe('Calculation Routes', () => {
  describe('POST /calculation/calcular', () => {
    it('deve retornar resultado com dados válidos', async () => {
      const res = await request(app)
        .post('/calculation/calcular')
        .send({
          consumo_mensal_kwh: 300,
          horas_sol_dia: 5,
          tarifa_energia: 0.7,
          preco_medio_conta: 200,
          espaco_disponivel_m2: 20
        });
      expect(res.statusCode).toBe(200);
      expect(res.body).toHaveProperty('potencia_necessaria_kwp');
      expect(res.body).toHaveProperty('quantidade_paineis');
      expect(res.body).toHaveProperty('area_necessaria_m2');
      expect(res.body).toHaveProperty('custo_total_r$');
    });

    it('deve retornar erro com dados inválidos', async () => {
      const res = await request(app)
        .post('/calculation/calcular')
        .send({});
      expect(res.statusCode).toBe(400);
      expect(res.body).toHaveProperty('erro');
    });
  });

  describe('POST /calculation/impacto-ambiental', () => {
    it('deve retornar resultado com dados válidos', async () => {
      const res = await request(app)
        .post('/calculation/impacto-ambiental')
        .send({
          potencia_kwp: 3,
          cidade_estado: 'São Paulo - SP'
        });
      expect(res.statusCode).toBe(200);
      expect(res.body).toHaveProperty('co2_evitado_anual_kg');
      expect(res.body).toHaveProperty('arvores_equivalentes');
      expect(res.body).toHaveProperty('distancia_carro_evitada_km');
    });

    it('deve retornar erro com dados inválidos', async () => {
      const res = await request(app)
        .post('/calculation/impacto-ambiental')
        .send({});
      expect(res.statusCode).toBe(400);
      expect(res.body).toHaveProperty('erro');
    });
  });

  describe('POST /calculation/orientacao', () => {
    it('deve retornar resultado com dados válidos', async () => {
      // Usando um CEP real e sombra false
      const res = await request(app)
        .post('/calculation/orientacao')
        .send({
          cep: '01001-000',
          potencia_kwp: 2.5,
          sombra: false
        });
      expect(res.statusCode).toBe(200);
      expect(res.body).toHaveProperty('inclinacao_ideal_graus');
      expect(res.body).toHaveProperty('orientacao_ideal');
      expect(res.body).toHaveProperty('tipo_inversor_recomendado');
      expect(res.body).toHaveProperty('tecnologias_paineis_sugeridas');
    });

    it('deve retornar erro com dados inválidos', async () => {
      const res = await request(app)
        .post('/calculation/orientacao')
        .send({});
      expect(res.statusCode).toBe(500);
      expect(res.body).toHaveProperty('erro');
    });
  });
}); 