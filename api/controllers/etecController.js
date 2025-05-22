

// POST /salario-liquido
exports.salarioLiquido = (req, res) => {
  const { salarioBruto } = req.body;
  const inssEmpregado = salarioBruto * 0.08;
  const liquido = salarioBruto - inssEmpregado;
  res.json({ salarioLiquido: liquido.toFixed(2) });
};

// POST /total-mensal
exports.totalMensal = (req, res) => {
  const { salarioBruto } = req.body;
  const inss = salarioBruto * 0.08;
  const fgts = salarioBruto * 0.08;
  const fgtsExtra = salarioBruto * 0.032;
  const total = salarioBruto + inss + fgts + fgtsExtra;
  res.json({ totalMensal: total.toFixed(2) });
};

// POST /inss
exports.inss = (req, res) => {
  const { salarioBruto } = req.body;
  const inssEmpregado = salarioBruto * 0.08;
  const inssEmpregador = salarioBruto * 0.08;
  res.json({
    inssEmpregado: inssEmpregado.toFixed(2),
    inssEmpregador: inssEmpregador.toFixed(2)
  });
};

// POST /fgts
exports.fgts = (req, res) => {
  const { salarioBruto } = req.body;
  const fgtsMensal = salarioBruto * 0.08;
  const fgtsRescisorio = salarioBruto * 0.032;
  res.json({
    fgtsMensal: fgtsMensal.toFixed(2),
    fgtsRescisorio: fgtsRescisorio.toFixed(2)
  });
};

// POST /decimo
exports.decimo = (req, res) => {
  const { salarioBruto, mesesTrabalhados } = req.body;
  const decimo = (salarioBruto / 12) * mesesTrabalhados;
  res.json({ decimoTerceiro: decimo.toFixed(2) });
};

// POST /ferias
exports.ferias = (req, res) => {
  const { salarioBruto, mesesTrabalhados } = req.body;
  const baseFerias = (salarioBruto / 12) * mesesTrabalhados;
  const adicionalTerco = baseFerias / 3;
  const totalFerias = baseFerias + adicionalTerco;
  res.json({ ferias: totalFerias.toFixed(2) });
};



