const express = require('express');
const swaggerUi = require('swagger-ui-express');
const swaggerDocument = require('./swagger.json');
const cors = require('cors');

const app = express();
const port = process.env.PORT || 3000;

// Importa as rotas
const equipe6Routes = require('./routes/equipe6Routes');
const userRoutes = require('./routes/userRoutes');
const baseRoutes = require('./routes/baseRoutes');
const impostosRoutes = require('./routes/impostoRoutes');
const gestorFinancasRoute = require('./routes/gestor_financas_route');
const loginFixoEquipeTresRoutes = require('./routes/loginFixoEquipeTresRoutes');
const calculoPiscina = require('./routes/calculoPiscinaRoute');
const viagemRoutes = require('./routes/viagemRoutes');
const calculadoraViagemRoutes = require('./routes/calculadoraViagemRoutes');
const etecRoutes = require('./routes/etecRoutes'); // <- ADICIONADO

// Middlewares
app.use(cors()); // Habilita CORS para todas as rotas
app.use(express.json());

// Swagger
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));

// Rotas
app.use('/', baseRoutes);
app.use('/users', userRoutes);
app.use('/imposto', impostosRoutes);
app.use('/gf', gestorFinancasRoute);
app.use('/loginFixoEquipeTres', loginFixoEquipeTresRoutes);
app.use('/calcularPiscina', calculoPiscina);
app.use('/viagens2', viagemRoutes);
app.use('/equipe6', equipe6Routes);
app.use('/calculadoraViagem', calculadoraViagemRoutes);
app.use('/ETEC', etecRoutes); // <- ADICIONADO

// Inicializa o servidor
app.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
  console.log(`Swagger em http://localhost:${port}/api-docs`);
});