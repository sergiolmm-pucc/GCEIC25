function calcularPotenciaNecessaria(consumoMensalKwh, horasSolDia) {
    return consumoMensalKwh / (30 * horasSolDia);
}

function calcularAreaNecessaria(qtdPaineis, areaPainelM2 = 1.6) {
    return qtdPaineis * areaPainelM2;
}

// POST /calcular
exports.calcular = (req, res) => {
  const dados = req.body;
  const VALOR_PAINEL = 3000;

    try {
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
    const dados = req.body;

    try {
        const potenciaKwp = parseFloat(dados.potencia_kwp);
        const cidadeEstado = dados.cidade_estado;

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