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

// NOVOS TESTES USANDO TDD - Tiago
// Teste para a rota POST /MKP2/calcMultiplierMarkup
test("POST to /MKP2/calcMultiplierMarkup should return 201", async () => {
    const response = await fetch('http://localhost:3000/MKP2/calcMultiplierMarkup', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            despesasVariaveis: 10,
            despesasFixas: 20,
            margemLucro: 30
        })
    });

    /* Aqui podemos testar se o calculo do markup está correto
    const responsebody = await response.text();
    console.log(responsebody);
    expect(responsebody).toBe("2.5");
    */

    expect(response.status).toBe(200);
});

test('Teste de multiplicação de markup com valores não numéricos', () => {
    expect(markup2.calcularMarkup('a', 'b', 'c')).toBe("Erro");
});

test('Teste de multiplicação de markup com valores numeros e não numéricos', () => {
    expect(markup2.calcularMarkup(10, 'b', 30)).toBe("Erro");
});