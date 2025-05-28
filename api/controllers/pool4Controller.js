export function calcularVolume(req, res) {
    const { tipo_piscina, comprimento, largura, profundidade, tipo_revestimento } = req.query;

    // Validação de preenchimento 
    if (!tipo_piscina || !comprimento || !largura || !profundidade || !tipo_revestimento) {
        return res.status(400).json({ error: "Preencha todos os campos antes de prosseguir." });
    }

    // Validação dos tipos 
    const tiposValidos = ['retangular', 'circular', 'oval', 'irregular'];
    const tipoPiscinaValido = tiposValidos.includes(tipo_piscina.toLowerCase());

    const tiposRevestimentoValidos = ['vinil', 'fibra', 'alvenaria'];
    const tipoRevestimentoValido = tiposRevestimentoValidos.includes(tipo_revestimento.toLowerCase());

    if (!tipoPiscinaValido) {
        return res.status(400).json({ error: `Tipo de piscina inválido. Use ${tiposValidos.join(', ')}.` });
    }

    if (!tipoRevestimentoValido) {
        return res.status(400).json({ error: `Tipo de revestimento inválido. Use ${tiposRevestimentoValidos.join(', ')}.` });
    }

    // Validação dos números 
    const comprimentoNum = parseFloat(comprimento);
    const larguraNum = parseFloat(largura);
    const profundidadeNum = parseFloat(profundidade);

    const camposNumericos = [comprimentoNum, larguraNum, profundidadeNum];
    const algumInvalido = camposNumericos.some(num => isNaN(num) || num <= 0);

    if (algumInvalido) {
        return res.status(400).json({ error: "Comprimento, largura e profundidade devem ser números positivos válidos." });
    }

    // Cálculo do volume 
    let volume = 0;
    const tipo = tipo_piscina.toLowerCase();

    switch (tipo) {
        case 'retangular':
            volume = comprimentoNum * larguraNum * profundidadeNum;
            break;
        case 'circular':
            const raio = comprimentoNum / 2; // comprimento como diâmetro
            volume = Math.PI * Math.pow(raio, 2) * profundidadeNum;
            break;
        case 'oval':
            // Fórmula de um cilindro oval: π * (comprimento/2) * (largura/2) * profundidade
            volume = Math.PI * (comprimentoNum / 2) * (larguraNum / 2) * profundidadeNum;
            break;
        case 'irregular':
            // Estimativa média: (comprimento * largura * profundidade) * 0.85
            // (Fator 0.85 é uma média usada em piscinas com formas livres)
            volume = comprimentoNum * larguraNum * profundidadeNum * 0.85;
            break;
    }

    // Retorno 
    return res.status(200).json({
        tipo_piscina: tipo,
        tipo_revestimento: tipo_revestimento.toLowerCase(),
        comprimento: comprimentoNum,
        largura: larguraNum,
        profundidade: profundidadeNum,
        volume_m3: parseFloat(volume.toFixed(2)),
        mensagem: `O volume da piscina é ${volume.toFixed(2)} metros cúbicos.`
    });
}

export function calcularMaterialEletrico(req, res) {

}

export function calcularMaterialHidraulico(req, res) {
 const {
        comprimentoTubos,
        custoPorMetro,
        qtdValvulas,
        custoValvula,
        custoBomba,
        custoFiltro,
        tipoTubulacao
    } = req.query;

    // Validação de preenchimento
    if (
        comprimentoTubos === undefined || custoPorMetro === undefined ||
        qtdValvulas === undefined || custoValvula === undefined ||
        custoBomba === undefined || custoFiltro === undefined ||
        !tipoTubulacao
    ) {
        return res.status(400).json({ error: "Preencha todos os campos antes de prosseguir." });
    }

    // Conversão para números
    const comprimento = parseFloat(comprimentoTubos);
    const precoMetro = parseFloat(custoPorMetro);
    const qtdConexoes = parseInt(qtdValvulas);
    const precoValvula = parseFloat(custoValvula);
    const precoBomba = parseFloat(custoBomba);
    const precoFiltro = parseFloat(custoFiltro);

    const camposNumericos = [comprimento, precoMetro, qtdConexoes, precoValvula, precoBomba, precoFiltro];
    const algumInvalido = camposNumericos.some(num => isNaN(num) || num < 0);

    if (algumInvalido) {
        return res.status(400).json({ error: "Todos os campos numéricos devem ser números válidos e não negativos." });
    }

    // Cálculo
    const custoTubos = comprimento * precoMetro;
    const custoValvulasTotal = qtdConexoes * precoValvula;
    const custoTotal = custoTubos + custoValvulasTotal + precoBomba + precoFiltro;

    // Retorno das informações 
    return res.status(200).json({
        tipo_tubulacao: tipoTubulacao.toLowerCase(),
        comprimentoTubos: comprimento,
        custoPorMetro: precoMetro,
        qtdValvulas: qtdConexoes,
        custoValvula: precoValvula,
        custoBomba: precoBomba,
        custoFiltro: precoFiltro,
        total: parseFloat(custoTotal.toFixed(2)),
        mensagem: `O custo total estimado para os materiais hidráulicos é R$ ${custoTotal.toFixed(2)}.`
    });
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

