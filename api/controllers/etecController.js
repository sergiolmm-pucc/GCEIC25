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