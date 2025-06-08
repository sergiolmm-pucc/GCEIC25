const request = require('supertest');
const app = require('../server');

describe('User Routes', () => {
  it('GET /users deve retornar dados do usuário', async () => {
    const res = await request(app).get('/users');
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('datetime');
    expect(res.body).toHaveProperty('usuario');
    expect(res.body).toHaveProperty('turma');
    expect(res.body).toHaveProperty('aula');
  });

  it('GET /users/:id deve retornar mensagem com o ID', async () => {
    const res = await request(app).get('/users/123');
    expect(res.statusCode).toBe(200);
    expect(res.text).toContain('Buscando usuário com ID: 123');
  });

  it('POST /users deve criar um novo usuário', async () => {
    const res = await request(app).post('/users');
    expect(res.statusCode).toBe(200);
    expect(res.text).toContain('Criando um novo usuário');
  });

  it('POST /users/login com credenciais corretas deve autenticar', async () => {
    const res = await request(app)
      .post('/users/login')
      .send({ username: 'admin', password: '1234' });
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('success', true);
    expect(res.body).toHaveProperty('usuario', 'admin');
  });

  it('POST /users/login com credenciais erradas deve falhar', async () => {
    const res = await request(app)
      .post('/users/login')
      .send({ username: 'admin', password: 'errado' });
    expect(res.statusCode).toBe(401);
    expect(res.body).toHaveProperty('success', false);
  });
}); 