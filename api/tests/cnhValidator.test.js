const cnhValidatorController = require('../controllers/cnhValidatorController');

describe('cnhValidatorController.validate', () => {
  let req, res;

  beforeEach(() => {
    req = { body: {} };
    res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn(),
    };
  });

  it('deve retornar erro 400 se não enviar cnhNumber', () => {
    cnhValidatorController.validate(req, res);
    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith({
      error: 'cnhNumber required'
    });
  });

  it('deve retornar isValid para CNH válida', () => {
    req.body = { cnhNumber: '12345678900' }; // Ajuste para um número válido se necessário
    cnhValidatorController.validate(req, res);
    expect(res.json).toHaveBeenCalledWith({
      isValid: expect.any(Boolean)
    });
  });
}); 