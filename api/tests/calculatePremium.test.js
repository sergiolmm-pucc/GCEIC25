const calculatePremiumController = require('../controllers/calculatePremiumController');

describe('calculatePremiumController.calculate', () => {
  let req, res;

  beforeEach(() => {
    req = { body: {} };
    res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn(),
    };
  });

  it('deve retornar erro 400 se faltar parâmetros', () => {
    calculatePremiumController.calculate(req, res);
    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith({
      error: 'Parâmetros inválidos'
    });
  });

  it('deve retornar o prêmio para dados válidos', () => {
    req.body = {
      year: 2020,
      make: 'Toyota',
      model: 'Corolla',
      driverAge: 30,
      licenseDuration: 10
    };
    calculatePremiumController.calculate(req, res);
    expect(res.json).toHaveBeenCalledWith({
      premio: expect.any(Number)
    });
  });

  it('deve retornar erro se algum parâmetro for do tipo errado', () => {
    req.body = {
      year: '2020', // string, deveria ser number
      make: 'Toyota',
      model: 'Corolla',
      driverAge: 30,
      licenseDuration: 10
    };
    calculatePremiumController.calculate(req, res);
    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith({
      error: 'Parâmetros inválidos'
    });
  });
}); 