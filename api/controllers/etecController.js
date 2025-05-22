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

exports.calcularESocial = (req, res) => {
    try {
        const dados = req.body;
        const eSocial = etecService.calcularESocial(dados);
        res.status(200).json({
          success: true,
          data: {
            eSocial,
          },
        });
    } catch (error) {
        res.status(500).json({
        success: false,
        message: error.message,
        });
    }
};