const express = require('express');
const router = express.Router();

const markup2Controller = require('../controllers/markup2Controller');

router.post('/calcMultiplierMarkup', markup2Controller.calcMultiplierMarkup);
router.post('/auth', markup2Controller.auth);
router.post('/calcDivisorMarkup', markup2Controller.calcDivisorMarkup);
router.get('/sobre', markup2Controller.retornarSobre);
router.get('/home', markup2Controller.retornarHome);

module.exports = router;