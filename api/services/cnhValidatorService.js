function validateCNH(cnhNumber) {
  // CNH deve ter 11 dígitos numéricos
  const regex = /^\d{11}$/;
  return regex.test(cnhNumber);
}

module.exports = validateCNH; 