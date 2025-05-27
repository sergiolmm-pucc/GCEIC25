export function calcularVolume(req, res) {
    console.log('Recebido:', req.body);
    const {
    tipo_piscina,
    'Comprimento (m)': comprimento,
    'Largura (m)': largura,
    'Profundidade (m)': profundidade,
    'Diâmetro (m)': diametro,
  } = req.body;

  if (!tipo_piscina) {
    return res.status(400).json({ error: 'Tipo de piscina é obrigatório.' });
  }

  const tipo = tipo_piscina.toLowerCase();
  const tiposValidos = ['retangular', 'circular', 'oval', 'irregular'];

  if (!tiposValidos.includes(tipo)) {
    return res.status(400).json({ error: `Tipo de piscina inválido. Use ${tiposValidos.join(', ')}.` });
  }

  function validarNumero(valor) {
    const num = parseFloat(valor);
    if (isNaN(num) || num <= 0) return null;
    return num;
  }

  let volume = 0;

  switch (tipo) {
    case 'retangular':
    case 'oval':
    case 'irregular': {
      const comp = validarNumero(comprimento);
      const larg = validarNumero(largura);
      const prof = validarNumero(profundidade);
      if (comp === null || larg === null || prof === null) {
        return res.status(400).json({ error: 'Comprimento, Largura e Profundidade devem ser números positivos válidos.' });
      }

      if (tipo === 'retangular') {
        volume = comp * larg * prof;
      } else if (tipo === 'oval') {
        volume = Math.PI * (comp / 2) * (larg / 2) * prof;
      } else if (tipo === 'irregular') {
        volume = comp * larg * prof * 0.85;
      }
      break;
    }
    case 'circular': {
      const diam = validarNumero(diametro);
      const prof = validarNumero(profundidade);
      if (diam === null || prof === null) {
        return res.status(400).json({ error: 'Diâmetro e Profundidade devem ser números positivos válidos.' });
      }

      const raio = diam / 2;
      volume = Math.PI * Math.pow(raio, 2) * prof;
      break;
    }
  }

  const response = {
    sucesso: true,
    tipo_piscina: tipo,
    volume: parseFloat(volume.toFixed(2)),
    mensagem: `O volume da piscina é ${volume.toFixed(2)} metros cúbicos.`
  };

    if (['retangular', 'oval', 'irregular'].includes(tipo)) {
    response.comprimento = comprimento;
    response.largura = largura;
    response.profundidade = profundidade;
    }

    if (tipo === 'circular') {
    response.diametro = diametro;
    response.profundidade = profundidade;
    }

    return res.status(200).json(response);
}

export function calcularMaterialEletrico(req, res) {

}

export function calcularMaterialHidraulico(req, res) {

}

export function calcularCustoDAgua(req, res) {

}

export function calcularManutencaoMensal(req, res) {

}

export function calcularMob(req, res) {

}

export function login(req, res) {
    const { email, senha } = req.body;

    if (email === 'adm@adm.com' && senha === 'adm') {
        return res.status(200).json({ sucesso: true, mensagem: 'Login realizado com sucesso!' });
    }

    return res.status(401).json({ sucesso: false, mensagem: 'E-mail ou senha inválidos.' });
}

