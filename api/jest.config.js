module.exports = {
  testEnvironment: 'node',
  testMatch: ['**/tests/**/*.test.js'], // Necessário para encontrar os arquivos de teste
  reporters: [
    'default',
    ['jest-junit', {
<<<<<<< HEAD
      outputDirectory: 'reports',
      outputName: 'jest-junit.xml'
    }],
  ],
};
=======
      outputDirectory: './reports',
      outputName: 'jest-junit.xml',
    }],
  ],
};
>>>>>>> upstream/main
