const express = require('express');
const router = express.Router();

const markup2Controller = require('../controllers/markup2Controller');

router.post('/calcMultiplierMarkup', markup2Controller.calcMultiplierMarkup);
router.post('/auth', markup2Controller.auth);

module.exports = router;