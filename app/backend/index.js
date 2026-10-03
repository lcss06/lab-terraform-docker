const http = require('http');
const { Pool } = require('pg');

const PORT = process.env.PORT || 3000;
const AMBIENTE = process.env.AMBIENTE || 'local';

const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT || 5432,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

function responder(res, status, body) {
  res.writeHead(status, {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
  });
  res.end(JSON.stringify(body));
}

const server = http.createServer(async (req, res) => {
  if (req.url === '/') {
    return responder(res, 200, { ok: true, servicio: 'api', ambiente: AMBIENTE });
  }

  if (req.url === '/db') {
    try {
      const result = await pool.query('SELECT current_database() AS bd, now() AS hora');
      return responder(res, 200, { ok: true, ambiente: AMBIENTE, ...result.rows[0] });
    } catch (err) {
      return responder(res, 500, { ok: false, error: err.message });
    }
  }

  responder(res, 404, { ok: false, error: 'Ruta no encontrada' });
});

server.listen(PORT, () => {
  console.log(`API (${AMBIENTE}) escuchando en el puerto ${PORT}`);
});
