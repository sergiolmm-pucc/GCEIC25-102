const express = require('express');
const app = express();
const etecRoutes = require('./routes/etecRoutes');
const swaggerUi = require('swagger-ui-express');
const swaggerDocument = require('./swagger.json');

app.use(express.json());
app.use('/ETEC', etecRoutes);
app.use('/docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));

app.listen(3000, () => {
  console.log('Servidor rodando na porta 3000');
});
