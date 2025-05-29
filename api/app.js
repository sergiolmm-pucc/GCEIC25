const express = require('express');
const cors = require('cors');
const piscinaRoutes = require('./routes/piscina3Routes');

const app = express();

app.use(cors());
app.use(express.json());

app.use('/MOB3', piscinaRoutes);

module.exports = app;
