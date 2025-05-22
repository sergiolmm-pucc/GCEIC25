const etecService = require('../services/etecService');

exports.calcularCustoMensal = (req,res) => {
    try {
        const dados = req.body;
        const custoMensal = etecService.calcularCustoMensal(dados);
        res.status(200).json({
            status: 'success',
            data: {
                custoMensal
            }
        });
    } catch (error) {
        res.status(500).json({
            status: 'error',
            message: error.message
        });
    }
}

exports.calcularFerias = (req, res) => {
    try {
        const dados = req.body;
        const feriasMensal = etecService.calcularFerias(dados);
        res.status(200).json({
          status: "success",
          data: {
            feriasMensal,
          },
        });
    } catch (error) {
        res.status(500).json({
        status: "error",
        message: error.message,
        });
    }
};

exports.calcularDecimoTerceiro = (req, res) => {
  try {
    const dados = req.body;
    const DecimoTerceiroData = etecService.calcularDecimoTerceiro(dados);
    res.status(200).json({
      status: "success",
      data: {
        bruto: DecimoTerceiroData.bruto,
        inss: DecimoTerceiroData.inss,
        liquido: DecimoTerceiroData.liquido
      },
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: error.message,
    });
  }
};