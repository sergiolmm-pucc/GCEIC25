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