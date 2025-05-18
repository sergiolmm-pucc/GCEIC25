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
