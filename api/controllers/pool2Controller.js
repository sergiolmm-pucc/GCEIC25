// Variáveis globais do módulo para armazenar resultados:
let valorVolume = 0;
let valorEletrico = 0;
let valorHidraulico = 0;
let valorAgua = 0;
let valorManutencao = 0;
let valorMob = 0;

function calcularVolume(req, res) {
  const { tipo_piscina, 'Comprimento (m)': comprimento, 'Largura (m)': largura, 'Profundidade (m)': profundidade, 'Diâmetro (m)': diametro } = req.body;
  if (!tipo_piscina) {
    return res.status(400).json({ error: 'Tipo de piscina é obrigatório.' });
  }
  const tipo = tipo_piscina.toLowerCase();
  const tiposValidos = ['retangular', 'circular', 'oval', 'irregular'];
  if (!tiposValidos.includes(tipo)) {
    return res.status(400).json({ error: `Tipo de piscina inválido. Use ${tiposValidos.join(', ')}.` });
  }
  function validarNumero(valor) {
    const num = parseFloat(valor);  // converte string para número:contentReference[oaicite:7]{index=7}
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
  // Armazena o valor do volume (duas casas decimais):
  valorVolume = parseFloat(volume.toFixed(2));  // toFixed retorna string:contentReference[oaicite:8]{index=8}, convertemos para número
  // Prepara resposta:
  const response = {
    sucesso: true,
    tipo_piscina: tipo,
    volume: valorVolume,
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

function calcularMaterialEletrico(req, res) {
  try {
    const {
      luminaria_qtd, luminaria_preco,
      fio_metros, fio_preco,
      comando_qtd, comando_preco,
      disjuntor_qtd, disjuntor_preco,
      programador_qtd, programador_preco
    } = req.body;
    if (
      luminaria_qtd == null || luminaria_preco == null ||
      fio_metros == null || fio_preco == null ||
      comando_qtd == null || comando_preco == null ||
      disjuntor_qtd == null || disjuntor_preco == null ||
      programador_qtd == null || programador_preco == null
    ) {
      return res.status(400).json({ error: 'Todos os campos são obrigatórios.' });
    }
    const quantidades = { luminaria_qtd, fio_metros, comando_qtd, disjuntor_qtd, programador_qtd };
    for (const [campo, valor] of Object.entries(quantidades)) {
      const valorStr = valor.toString();
      if (valorStr.includes('.') || valorStr.includes(',')) {
        return res.status(400).json({
          error: `O campo "${campo}" deve conter apenas números inteiros, sem ponto ou vírgula.`
        });
      }
    }
    function tratarNumero(valor) {
      if (typeof valor !== 'string') valor = valor.toString();
      if (valor.includes(',') && valor.includes('.')) {
        valor = valor.replace(/\./g, '').replace(',', '.');
      } else if (valor.includes(',')) {
        valor = valor.replace(',', '.');
      } else if (/^\d{1,3}(\.\d{3})+$/.test(valor)) {
        valor = valor.replace(/\./g, '');
      }
      return parseFloat(valor);
    }
    const luminariaQtd = parseInt(luminaria_qtd);
    const fioMetros = parseInt(fio_metros);
    const comandoQtd = parseInt(comando_qtd);
    const disjuntorQtd = parseInt(disjuntor_qtd);
    const programadorQtd = parseInt(programador_qtd);
    const luminariaPreco = tratarNumero(luminaria_preco);
    const fioPreco = tratarNumero(fio_preco);
    const comandoPreco = tratarNumero(comando_preco);
    const disjuntorPreco = tratarNumero(disjuntor_preco);
    const programadorPreco = tratarNumero(programador_preco);
    const camposNumericos = [
      luminariaQtd, luminariaPreco,
      fioMetros, fioPreco,
      comandoQtd, comandoPreco,
      disjuntorQtd, disjuntorPreco,
      programadorQtd, programadorPreco
    ];
    const algumInvalido = camposNumericos.some(num => isNaN(num) || num < 0);
    if (algumInvalido) {
      return res.status(400).json({ error: 'Todos os valores devem ser numéricos e positivos.' });
    }
    // Cálculo do custo mensal:
    const total =
      (luminariaQtd * luminariaPreco) +
      (fioMetros * fioPreco) +
      (comandoQtd * comandoPreco) +
      (disjuntorQtd * disjuntorPreco) +
      (programadorQtd * programadorPreco);
    valorEletrico = parseFloat(total.toFixed(2));  // guarda o total calculado
    res.status(200).json({ custo_mensal: total.toFixed(2).replace('.', ',') });
  } catch (error) {
    res.status(500).json({ error: 'Erro ao processar os dados.' });
  }
}

function calcularMaterialHidraulico(req, res) {
  const {
    comprimentoTubos,
    custoPorMetro,
    custoValvula,
    custoBomba,
    custoFiltro,
    tipoTubulacao
  } = req.body;

  // Validação: verificar se todos os campos foram preenchidos
  if (
    comprimentoTubos === undefined || custoPorMetro === undefined ||
    custoValvula === undefined || custoBomba === undefined ||
    custoFiltro === undefined || !tipoTubulacao
  ) {
    return res.status(400).json({ error: "Preencha todos os campos antes de prosseguir." });
  }

  // Conversão
  const comprimento = parseFloat(comprimentoTubos);
  const precoMetro = parseFloat(custoPorMetro);
  const precoValvula = parseFloat(custoValvula);
  const precoBomba = parseFloat(custoBomba);
  const precoFiltro = parseFloat(custoFiltro);

  // Validação de números
  if (
    isNaN(comprimento) || isNaN(precoMetro) || isNaN(precoValvula) ||
    isNaN(precoBomba) || isNaN(precoFiltro)
  ) {
    return res.status(400).json({ error: "Todos os valores numéricos devem ser números válidos." });
  }

  // Validação de números negativos
  if (
    comprimento < 0 || precoMetro < 0 || precoValvula < 0 ||
    precoBomba < 0 || precoFiltro < 0
  ) {
    return res.status(400).json({ error: "Os valores não podem ser negativos." });
  }

  // Cálculo
  const total = comprimento * precoMetro + precoValvula + precoBomba + precoFiltro;
  valorHidraulico = total;

  // Retorno
  res.status(200).json({
    total,
    tipo_tubulacao: tipoTubulacao.toLowerCase()
  });
}

function calcularCustoDAgua(req, res) {
  const { volume, tarifa } = req.body;
  if (!volume || !tarifa) {
    return res.status(400).json({ error: 'Volume e tarifa são obrigatórios.' });
  }
  function tratarNumero(valor) {
    if (typeof valor !== 'string') valor = valor.toString();
    if (valor.includes(',') && valor.includes('.')) {
      valor = valor.replace(/\./g, '').replace(',', '.');
    } else if (valor.includes(',')) {
      valor = valor.replace(',', '.');
    } else if (/^\d{1,3}(\.\d{3})+$/.test(valor)) {
      valor = valor.replace(/\./g, '');
    }
    return parseFloat(valor);
  }
  const volumeFloat = tratarNumero(volume);
  const tarifaFloat = tratarNumero(tarifa);
  const custo = volumeFloat * tarifaFloat;
  valorAgua = parseFloat(custo.toFixed(2));  // guarda o custo da água
  res.json({ custo_agua: custo.toFixed(2) });
}

function calcularManutencaoMensal(req, res) {
  const { produtos_quimicos, energia_bomba, mao_obra, hora_bomba } = req.body;
  if (
    produtos_quimicos == null ||
    energia_bomba == null ||
    mao_obra == null ||
    hora_bomba == null
  ) {
    return res.status(400).json({
      error: 'Todos os campos (produtos_quimicos, energia_bomba, mao_obra, horas_bomba) são obrigatórios.'
    });
  }
  function tratarNumero(valor) {
    if (typeof valor !== 'string') valor = valor.toString();
    if (valor.includes(',') && valor.includes('.')) {
      valor = valor.replace(/\./g, '').replace(',', '.');
    } else if (valor.includes(',')) {
      valor = valor.replace(',', '.');
    } else if (/^\d{1,3}(\.\d{3})+$/.test(valor)) {
      valor = valor.replace(/\./g, '');
    }
    return parseFloat(valor);
  }
  const produtosQuimicosFloat = tratarNumero(produtos_quimicos);
  const energiaBombaFloat = tratarNumero(energia_bomba);
  const maoObraFloat = tratarNumero(mao_obra);
  const horasBombaFloat = tratarNumero(hora_bomba);
  const energiaMensal = energiaBombaFloat * horasBombaFloat;
  const custoTotal = produtosQuimicosFloat + energiaMensal + maoObraFloat;
  valorManutencao = parseFloat(custoTotal.toFixed(2));  // guarda o custo de manutenção
  res.json({ custo_mensal: custoTotal.toFixed(2) });
}

function calcularMob(req, res) {
  const { transporte, instalacao, maoDeObra, equipamentos } = req.body;

    if (
      transporte === undefined ||
      instalacao === undefined ||
      maoDeObra === undefined ||
      equipamentos === undefined
    ) {
      return res.status(400).json({ error: "Todos os campos são obrigatórios." });
    }

  if (
    !transporte.toString().trim() ||
    !instalacao.toString().trim() ||
    !maoDeObra.toString().trim() ||
    !equipamentos.toString().trim()
  ) {
    return res.status(400).json({ error: "Todos os campos são obrigatórios." });
  }
  const t = parseFloat(transporte);
  const i = parseFloat(instalacao);
  const m = parseFloat(maoDeObra);
  const e = parseFloat(equipamentos);
  if ([t, i, m, e].some(val => isNaN(val) || val < 0)) {
    return res.status(400).json({ error: "Todos os valores devem ser números válidos e positivos." });
  }
  const total = t + i + m + e;
  valorMob = parseFloat(total.toFixed(2));  // guarda o custo de MOB
  return res.status(200).json({
    transporte: t,
    instalacao: i,
    maoDeObra: m,
    equipamentos: e,
    total,
    mensagem: `O custo total de MOB é R$ ${total.toFixed(2).replace('.', ',')}`
  });
}

// Função adicional para retornar todos os valores e sua soma:
function calcularTotal(req, res) {
  const somaTotal = valorVolume + valorEletrico + valorHidraulico +
                    valorAgua + valorManutencao + valorMob;
  return res.status(200).json({
    valorVolume: valorVolume,
    valorMaterialEletrico: valorEletrico,
    valorMaterialHidraulico: valorHidraulico,
    valorCustoAgua: valorAgua,
    valorManutencaoMensal: valorManutencao,
    valorMob: valorMob,
    somaTotal: parseFloat(somaTotal.toFixed(2))
  });
}

function login(req, res) {
  const { email, senha } = req.body;
  if (email === 'adm@adm.com' && senha === 'adm') {
    return res.status(200).json({ sucesso: true, mensagem: 'Login realizado com sucesso!' });
  }
  return res.status(401).json({ sucesso: false, mensagem: 'E-mail ou senha inválidos.' });
}

module.exports = {
  calcularVolume,
  calcularMaterialEletrico,
  calcularMaterialHidraulico,
  calcularCustoDAgua,
  calcularManutencaoMensal,
  calcularMob,
  calcularTotal,  // exporta a função de soma
  login
};
