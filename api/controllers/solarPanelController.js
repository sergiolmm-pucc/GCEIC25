function calcularPotenciaNecessaria(consumoMensalKwh, horasSolDia) {
    return consumoMensalKwh / (30 * horasSolDia);
}

function calcularAreaNecessaria(qtdPaineis, areaPainelM2 = 1.6) {
    return qtdPaineis * areaPainelM2;
}

async function pegarLatitudePorCep(cep) {
    const cepLimpo = cep.replace(/\D/g, '');
    if (cepLimpo.length !== 8) {
        throw new Error("CEP inválido. O CEP deve conter 8 dígitos.");
    }

    try {
        const viaCepUrl = `https://viacep.com.br/ws/${cepLimpo}/json/`;
        const viaCepResponse = await fetch(viaCepUrl);
        const viaCepData = await viaCepResponse.json();
        if (viaCepData.erro) {
            throw new Error("CEP não encontrado pelo ViaCEP.");
        }
        const endereco = [
            viaCepData.logradouro,
            viaCepData.bairro,
            viaCepData.localidade,
            viaCepData.uf,
            'Brasil'
        ].filter(Boolean).join(', ');
        // Substitua pela sua chave real:
        const googleGeocodingUrl = `https://maps.googleapis.com/maps/api/geocode/json?address=${encodeURIComponent(endereco)}&key=AIzaSyDb9KYzzxefFH29dufLkdtH8fVsdXVDaGs`;
        const googleResponse = await fetch(googleGeocodingUrl);
        const googleData = await googleResponse.json();

        if (googleData.status === 'OK' && googleData.results.length > 0) {
            const location = googleData.results[0].geometry.location;
            return location.lat;
        } else {
            throw new Error(`Não foi possível geocodificar o endereço: ${googleData.status}`);
        }

    } catch (error) {
        console.error("Erro ao obter latitude por CEP:", error);
        throw error;
    }
}


// POST /calcular
exports.calcular = (req, res) => {
    try {
        const dados = req.body;
        if (!dados.consumo_mensal_kwh) {
            return res.status(400).json({ erro: 'Consumo mensal em kWh é obrigatório.' });
        }
        if (!dados.horas_sol_dia) {
            return res.status(400).json({ erro: 'Horas de sol por dia é obrigatório.' });
        }
        if (!dados.tarifa_energia) {
            return res.status(400).json({ erro: 'Tarifa de energia é obrigatório.' });
        }
        if (!dados.preco_medio_conta) {
            return res.status(400).json({ erro: 'Preço médio da conta é obrigatório.' });
        }
        const VALOR_PAINEL = 3000;
        const consumoMensalKwh = parseFloat(dados.consumo_mensal_kwh);
        const horasSolDia = parseFloat(dados.horas_sol_dia);
        const tarifaEnergia = parseFloat(dados.tarifa_energia);
        const precoMedioConta = parseFloat(dados.preco_medio_conta);
        const espacoDisponivelM2 = parseFloat(dados.espaco_disponivel_m2);

        const potenciaNecessariaKwp = calcularPotenciaNecessaria(consumoMensalKwh * 1.15, horasSolDia);
        const geracaoPainel = 75;
        const quantidadePaineis = Math.ceil(consumoMensalKwh / geracaoPainel);
        const areaTotal = calcularAreaNecessaria(quantidadePaineis);
        const espacoSuficiente = espacoDisponivelM2 >= areaTotal;
        const areaExtra = Math.max(0, areaTotal - espacoDisponivelM2);
        const custoTotal = quantidadePaineis * VALOR_PAINEL;
        const economiaAnual = precoMedioConta * 12;
        const economiaTotal = economiaAnual - 540;
        const payback = custoTotal / economiaTotal || null;

        const resultado = {
            potencia_necessaria_kwp: parseFloat(potenciaNecessariaKwp.toFixed(2)),
            quantidade_paineis: quantidadePaineis,
            area_necessaria_m2: parseFloat(areaTotal.toFixed(2)),
            espaco_disponivel_m2: parseFloat(espacoDisponivelM2.toFixed(2)),
            espaco_suficiente: espacoSuficiente,
            area_extra_necessaria_m2: parseFloat(areaExtra.toFixed(2)),
            custo_total_r$: parseFloat(custoTotal.toFixed(2)),
            payback_anos: payback ? parseFloat(payback.toFixed(2)) : null
        };

        res.json(resultado);
    } catch (error) {
        res.status(400).json({ erro: 'Valores inválidos ou ausentes.' });
    }
}

//POST /impacto-ambiental
exports.impactoAmbiental = (req, res) => {
    try {
        const dados = req.body;
        const potenciaKwp = parseFloat(dados.potencia_kwp);
        const cidadeEstado = dados.cidade_estado;

        if (!cidadeEstado) {
            return res.status(400).json({ erro: 'Cidade e estado são obrigatórios.' });
        }
        if (!potenciaKwp) {
            return res.status(400).json({ erro: 'Potência em kWp é obrigatório.' });
        }
        // Fatores de emissão por região (kg CO2/kWh)
        const fatoresEmissao = {
            'norte': 0.12,
            'nordeste': 0.35,
            'centro-oeste': 0.15,
            'sudeste': 0.12,
            'sul': 0.12
        };

        // Determina a região baseada no estado
        const regioesPorEstado = {
            'AC': 'norte', 'AP': 'norte', 'AM': 'norte', 'PA': 'norte', 'RO': 'norte', 'RR': 'norte', 'TO': 'norte',
            'AL': 'nordeste', 'BA': 'nordeste', 'CE': 'nordeste', 'MA': 'nordeste', 'PB': 'nordeste', 'PE': 'nordeste', 'PI': 'nordeste', 'RN': 'nordeste', 'SE': 'nordeste',
            'DF': 'centro-oeste', 'GO': 'centro-oeste', 'MT': 'centro-oeste', 'MS': 'centro-oeste',
            'ES': 'sudeste', 'MG': 'sudeste', 'RJ': 'sudeste', 'SP': 'sudeste',
            'PR': 'sul', 'RS': 'sul', 'SC': 'sul'
        };

        const estado = cidadeEstado.split('-')[1].trim().toUpperCase();
        const fatorEmissao = fatoresEmissao[regioesPorEstado[estado]] || 0.12; // valor padrão caso não encontre

        // Cálculos
        const geracaoAnualKwh = potenciaKwp * 1000 * 365 * 0.75; // 75% de eficiência média
        const co2EvitadoAnual = geracaoAnualKwh * fatorEmissao;
        
        // Uma árvore absorve em média 22kg de CO2 por ano
        const arvoresEquivalentes = Math.ceil(co2EvitadoAnual / 22);
        
        // Um carro a gasolina emite em média 2.3kg de CO2 por km
        const distanciaCarroEvitada = co2EvitadoAnual / 2.3;

        const resultado = {
            co2_evitado_anual_kg: parseFloat(co2EvitadoAnual.toFixed(2)),
            arvores_equivalentes: arvoresEquivalentes,
            distancia_carro_evitada_km: parseFloat(distanciaCarroEvitada.toFixed(2))
    };

    res.json(resultado);
    } catch (error) {
        res.status(400).json({ erro: 'Valores inválidos ou ausentes.' });
    }
}

// POST /orientacao
exports.orientacao = async (req, res) => {
    try {
        let { cep, potencia_kwp, sombra } = req.body;
        if (!cep) return res.status(400).json({ erro: 'CEP é obrigatório.' });
        if (!potencia_kwp) return res.status(400).json({ erro: 'Potência em kWp é obrigatório.' });
        if (sombra === undefined) sombra = false;

        const latitude = await pegarLatitudePorCep(cep);
        const inclinacao_ideal_graus = Math.round(Math.abs(latitude));

        const orientacao_ideal = "Norte geográfico (ideal para o hemisfério sul)";
        const tipo_inversor_recomendado = sombra 
            ? "Microinversor (ótimo para locais com sombreamento parcial)" 
            : "Inversor string (eficiente para áreas sem sombra)";
        const tecnologias_paineis_sugeridas = potencia_kwp < 3
            ? [
                "Painéis Monocristalinos (alta eficiência, bom para pouco espaço)", 
                "Painéis Policristalinos (custo-benefício se houver espaço de sobra)"
              ]
            : [
                "Painéis Policristalinos (custo-benefício)",
                "Thin-film (para áreas muito grandes e baixa eficiência exigida)"
              ];

        return res.json({
            inclinacao_ideal_graus,
            orientacao_ideal,
            tipo_inversor_recomendado,
            tecnologias_paineis_sugeridas
        });
    } catch (error) {
        return res.status(500).json({ erro: 'Erro ao processar os dados.', detalhes: error.message });
    }
};


// POST /login
exports.login = (req, res) => {
  const { username, password } = req.body;
  if (username === "admin" && password === "1234") {
    res.json({
      success: true,
      message: "Login bem-sucedido",
      usuario: username
    });
  }
  else {
    res.status(401).json({
      success: false,
      message: "Usuário ou senha inválidos"
    });
  }
};
