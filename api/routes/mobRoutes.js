const express = require('express');
const router = express.Router();
const { calcularMob } = require('../controllers/pool4Controller');

router.get('/calcularMob', calcularMob);

module.exports = router; 
