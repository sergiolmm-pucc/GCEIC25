const express = require('express');
const router = express.Router();
const cnhValidatorController = require('../controllers/cnhValidatorController');

router.post('/validate-cnh', cnhValidatorController.validate);
 
module.exports = router; 