const validateCPF = require('../services/cpfValidatorService');

exports.validate = (req, res) => {
  const { cpf } = req.params;
  if (!cpf) {
    return res.status(400).json({ success: false, mensagem: 'CPF não fornecido' });
  }
  const isValid = validateCPF(cpf);
  res.json({
    success: isValid,
    mensagem: isValid ? 'CPF válido.' : 'CPF inválido.'
  });
};