module.exports = {
  testEnvironment: 'node',
  testMatch: ['**/tests/**/*.test.js'], // Necessário para encontrar os arquivos de teste
  reporters: [
    'default',
    ['jest-junit', {
      outputDirectory: './reports',
      outputName: 'jest-junit.xml',
    }],
  ],
};
