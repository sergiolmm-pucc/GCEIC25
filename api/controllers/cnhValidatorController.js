const validateCNH = require('../services/cnhValidatorService');

exports.validate = (req, res) => {
  const { cnhNumber } = req.body;
  if (!cnhNumber) {
    return res.status(400).json({ error: 'cnhNumber required' });
  }
  const isValid = validateCNH(cnhNumber);
  res.json({ isValid });
}; 