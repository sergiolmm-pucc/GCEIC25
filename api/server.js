const express = require('express');
const swaggerUi = require('swagger-ui-express');
const swaggerDocument = require('./swagger.json');
const cors = require('cors');

const app = express();
const port = process.env.PORT || 3000;

// importa as rotas
const userRoutes = require('./routes/userRoutes')
const baseRoutes = require('./routes/baseRoutes')
const etec2Routes = require('./routes/etec2Routes')
const pool4Routes = require('./routes/pool4Routes')
const markup2Routes = require('./routes/markup2Routes')
const markupRoutes = require('./routes/markupRoutes');
const loginRoutes = require('./routes/loginRoutes');
const aposRoutes = require('./routes/aposRoutes')
const mkp1Routes = require('./routes/mkp1Routes')
const piscinaRoutes = require('./routes/piscina3Routes');
const etecRoutes = require('./routes/etecRoutes');
const icmsRoutes = require('./routes/icmsRoutes5');
const irpjRoutes = require('./routes/irpjRoutes5');
const issRoutes = require('./routes/issRoutes5');
const ipiRoutes = require('./routes/ipiRoutes5');

app.use(cors()); // Enable CORS for all routes
app.use(express.json());
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));
app.use('/', baseRoutes);
app.use('/users', userRoutes);
app.use('/ETEC', etecRoutes);
app.use('/CCP', pool4Routes); // Grupo 02 - Cálculo Construção Piscina
app.use('/MKP2', markup2Routes);
app.use('/markup', markupRoutes);// grupo 11 - markup
app.use('/login', loginRoutes);
app.use('/APOS', aposRoutes); // Grupo 09 - Cálculo de Aposentadoria
app.use('/mkp1', mkp1Routes); // Grupo MKP1 - Cálculo de Markup
app.use('/MOB3', piscinaRoutes); // Grupo 03 --piscina
app.use('/impostos', ipiRoutes); // Grupo 05
app.use('/impostos', icmsRoutes); 
app.use('/impostos', irpjRoutes);
app.use('/impostos', issRoutes);
app.use('/etec2', etec2Routes); //Grupo 10 - ETEC



app.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
  console.log(`Swagger em http://localhost:${port}/api-docs`);
});
