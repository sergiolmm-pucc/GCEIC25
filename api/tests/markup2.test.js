const markup2 = require('../controllers/markup2Controller');
const { test, expect } = require('@jest/globals');

test('Teste de multiplicação de markup', () => {
    expect(markup2.calcularMarkup(10, 20, 30)).toBe(2.5);
});

test('Teste de multiplicação de markup com valores negativos', () => {
    expect(markup2.calcularMarkup(-10, -20, -30)).toBe(0.63);
});

test('Teste de multiplicação de markup com valores zero', () => {
    expect(markup2.calcularMarkup(0, 0, 0)).toBe(1);
});

test('Teste de multiplicação de markup com valores decimais', () => {
    expect(markup2.calcularMarkup(16.2, 28.5, 3.8)).toBe(1.94);
});

test('Teste de divisão de markup', () => {
    expect(markup2.calcularMarkupDivisor(100, 50)).toBe(0.5);
});

test('Teste de divisão de markup com valores negativos', () => {
    expect(markup2.calcularMarkupDivisor(-100, -50)).toBe(0.5);
}); 

test('Teste de divisão de markup com valores zero', () => {
    expect(markup2.calcularMarkupDivisor(0, 0)).toBe(0);
});

test('Teste de divisão de markup com valores decimais', () => {
    expect(markup2.calcularMarkupDivisor(100.5, 50.25)).toBe(0.5);
});

// NOVOS TESTES USANDO TDD - Tiago
// Teste para a rota POST /MKP2/calcMultiplierMarkup
// API tem que estar rodando para testar
// test("POST to /MKP2/calcMultiplierMarkup should return 201", async () => {
//     const response = await fetch('http://localhost:3000/MKP2/calcMultiplierMarkup', {
//         method: 'POST',
//         headers: {
//             'Content-Type': 'application/json'
//         },
//         body: JSON.stringify({
//             despesasVariaveis: 10,
//             despesasFixas: 20,
//             margemLucro: 30
//         })
//     });

//     /* Aqui podemos testar se o calculo do markup está correto
//     const responsebody = await response.text();
//     console.log(responsebody);
//     expect(responsebody).toBe("2.5");
//     */

//     expect(response.status).toBe(200);
// });

test('Teste de multiplicação de markup com valores não numéricos', () => {
    expect(markup2.calcularMarkup('a', 'b', 'c')).toBe("Erro");
});

test('Teste de multiplicação de markup com valores numeros e não numéricos', () => {
    expect(markup2.calcularMarkup(10, 'b', 30)).toBe("Erro");
});

//Enzo
test("Teste da função sobre não retornar as strings", () => {
    const jest = require('@jest/globals').jest;
    const req = {};
    const res = {
        json: jest.fn()
    };

    markup2.retornarSobre(req, res);

    expect(res.json).toHaveBeenCalled();

    const chamadoCom = res.json.mock.calls[0][0];
    expect(chamadoCom).not.toBeUndefined();

    expect(Object.keys(chamadoCom).length).toBeGreaterThan(0);

        for (const [key, value] of Object.entries(chamadoCom)) {
        expect(key).not.toBe('');
        expect(value).not.toBe('');
    }
});

test('Teste de autenticação', () => {
    expect(markup2.autentication('admin@email.com', "123456")).toBe(true)
})

test('Teste de autenticação', () => {
    expect(markup2.autentication(1, 12)).toBe(false)
})

test('Teste de autenticação', () => {
    expect(markup2.autentication('vinicius@exemplo.com', "123456")).toBe(false)
})

test('Teste de autenticação', () => {
    expect(markup2.autentication('admin@email.com', "123")).toBe(false)
})

test('Teste de autenticação', () => {
    expect(markup2.autentication('', "")).toBe(false)
})

test('Teste de autenticação', () => {
    expect(markup2.autentication(null, null)).toBe(false)
})
