function calculatePremium({ year, make, model, driverAge, licenseDuration }) {
  let premio = 1000;
  // Ano do veículo
  if (year < 2000) premio += 500;
  if (year > 2020) premio += 150;
  // Idade do condutor
  if (driverAge < 25) premio += 300;
  if (driverAge > 60) premio += 200;
  // Tempo de habilitação
  if (licenseDuration < 2) premio += 150;
  if (licenseDuration > 10) premio -= 100;
  // Modelo do veículo
  const modelLower = (model || '').toLowerCase();
  if (modelLower.includes('suv')) premio += 250;
  if (['gol', 'palio', 'uno'].some(popular => modelLower.includes(popular))) premio += 50;
  // Prêmio mínimo
  if (premio < 200) premio = 200;
  return premio;
}

module.exports = calculatePremium; 