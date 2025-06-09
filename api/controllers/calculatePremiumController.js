const calculatePremium = require('../services/calculatePremiumService');

exports.calculate = (req, res) => {
  const { year, make, model, driverAge, licenseDuration } = req.body;
  if (
    typeof year !== 'number' ||
    typeof make !== 'string' ||
    typeof model !== 'string' ||
    typeof driverAge !== 'number' ||
    typeof licenseDuration !== 'number'
  ) {
    return res.status(400).json({ error: 'Parâmetros inválidos' });
  }
  const premio = calculatePremium({ year, make, model, driverAge, licenseDuration });
  res.json({ premio });
}; 