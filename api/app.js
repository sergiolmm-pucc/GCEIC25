const express = require('express');
const cors = require('cors');

const piscinaRoutes = require('./routes/piscina3Routes');

const ipiRoutes = require('./routes/ipiRoutes5');
const icmsRoutes = require('./routes/icmsRoutes5'); 
const irpjRoutes = require('./routes/irpjRoutes5');
const issRoutes = require('./routes/issRoutes5'); 

const app = express();

app.use(cors());
app.use(express.json());

app.use('/MOB3', piscinaRoutes);

app.use('/api', ipiRoutes);
app.use('/api', icmsRoutes); 
app.use('/api', irpjRoutes);
app.use('/api', issRoutes); 

module.exports = app;