const express = require('express');
const router = express.Router();
const calculatePremiumController = require('../controllers/calculatePremiumController');

router.post('/', calculatePremiumController.calculate);

module.exports = router; 