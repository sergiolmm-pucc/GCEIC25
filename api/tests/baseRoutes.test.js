const request = require('supertest');
const app = require('../server');

describe('Base Routes', () => {
  it('GET /datetime deve retornar a data/hora atual', async () => {
    const res = await request(app).get('/datetime');
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('datetime');
  });

  it('POST /concat deve concatenar a frase', async () => {
    const res = await request(app)
      .post('/concat')
      .send({ value: 'Teste' });
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('success', true);
    expect(res.body.result).toContain('Teste');
  });
});
