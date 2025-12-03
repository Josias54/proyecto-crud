// Importar librerías necesarias
const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');

// Crear aplicación Express
const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares (procesan peticiones antes de llegar a rutas)
app.use(cors()); // Permitir peticiones desde otros dominios
app.use(express.json()); // Leer JSON del body

// Configuración de base de datos desde variables de entorno
// Soporta tanto DATABASE_URL (URL completa) como variables individuales
let dbConfig;

if (process.env.DATABASE_URL) {
  // Si existe DATABASE_URL, usarla directamente (formato de Render)
  dbConfig = {
    connectionString: process.env.DATABASE_URL,
    // Configuración del pool para mejor manejo de conexiones
    max: 20, // máximo de conexiones en el pool
    idleTimeoutMillis: 30000, // tiempo antes de cerrar conexiones inactivas
    connectionTimeoutMillis: 2000, // tiempo máximo para obtener una conexión
    ssl: process.env.DATABASE_URL.includes('render.com') ? { rejectUnauthorized: false } : false
  };
} else {
  // Si no existe DATABASE_URL, usar variables individuales
  dbConfig = {
    host: process.env.DB_HOST || 'postgres-db',
    port: parseInt(process.env.DB_PORT) || 5432,
    database: process.env.POSTGRES_DB || 'crud_db',
    user: process.env.POSTGRES_USER || 'postgres',
    password: process.env.POSTGRES_PASSWORD || 'postgres',
    // Configuración del pool para mejor manejo de conexiones
    max: 20, // máximo de conexiones en el pool
    idleTimeoutMillis: 30000, // tiempo antes de cerrar conexiones inactivas
    connectionTimeoutMillis: 2000, // tiempo máximo para obtener una conexión
  };
}

// Variable para el pool (se inicializará después de verificar conexión)
let pool;

// Función para esperar a que PostgreSQL esté disponible
async function waitForPostgres() {
  const { Client } = require('pg');
  const maxRetries = 30;
  let retries = 0;
  
  while (retries < maxRetries) {
    try {
      const client = new Client(dbConfig);
      await client.connect();
      await client.query('SELECT 1');
      await client.end();
      console.log('Conexión a PostgreSQL establecida');
      return true;
    } catch (err) {
      retries++;
      console.log(`Esperando a PostgreSQL... (intento ${retries}/${maxRetries})`);
      await new Promise(resolve => setTimeout(resolve, 2000));
    }
  }
  
  throw new Error('No se pudo conectar a PostgreSQL después de varios intentos');
}

// Crear tabla si no existe (al iniciar)
async function initDatabase() {
  try {
    await waitForPostgres();
    
    // Crear el pool después de verificar la conexión
    pool = new Pool(dbConfig);
    // Pool: grupo de conexiones reutilizables a la BD
    
    await pool.query(`
      CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        nombre TEXT,
        correo TEXT
      )
    `);
    console.log('✅ Tabla users lista');
    
    // Verificar la conexión y mostrar información
    const dbInfo = await pool.query('SELECT current_database() as db, current_user as user, version() as version');
    console.log('📊 Información de la base de datos:');
    console.log(`   - Base de datos: ${dbInfo.rows[0].db}`);
    console.log(`   - Usuario: ${dbInfo.rows[0].user}`);
    console.log(`   - PostgreSQL: ${dbInfo.rows[0].version.split(',')[0]}`);
  } catch (err) {
    console.error('Error al inicializar base de datos:', err.message);
    // Reintentar después de 2 segundos
    setTimeout(initDatabase, 2000);
  }
}

initDatabase();

// Función helper para asegurar que el pool esté disponible
function ensurePool() {
  if (!pool) {
    throw new Error('Base de datos no está lista aún');
  }
  return pool;
}

// Endpoint de salud para verificar conexión a PostgreSQL
app.get('/api/health', async (req, res) => {
  try {
    if (!pool) {
      return res.status(503).json({ 
        status: 'error', 
        message: 'Base de datos no está lista aún',
        dbConfig: {
          host: dbConfig.host,
          port: dbConfig.port,
          database: dbConfig.database
        }
      });
    }
    
    // Probar la conexión
    const result = await pool.query('SELECT NOW() as current_time, version() as pg_version');
    res.json({ 
      status: 'ok', 
      message: 'Conexión a PostgreSQL exitosa',
      database: {
        connected: true,
        host: dbConfig.host,
        database: dbConfig.database,
        currentTime: result.rows[0].current_time,
        version: result.rows[0].pg_version.split(',')[0]
      }
    });
  } catch (err) {
    res.status(500).json({ 
      status: 'error', 
      message: 'Error al conectar con PostgreSQL',
      error: err.message,
      dbConfig: {
        host: dbConfig.host,
        port: dbConfig.port,
        database: dbConfig.database
      }
    });
  }
});

// GET /api/users - Obtener todos los usuarios
app.get('/api/users', async (req, res) => {
  try {
    const result = await ensurePool().query('SELECT * FROM users');
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET /api/users/:id - Obtener un usuario específico
app.get('/api/users/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const userId = parseInt(id, 10);
    
    if (isNaN(userId)) {
      return res.status(400).json({ error: 'ID debe ser un número válido' });
    }
    
    const result = await ensurePool().query(
      'SELECT * FROM users WHERE id = $1',
      [userId]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST /api/users - Crear nuevo usuario
app.post('/api/users', async (req, res) => {
  try {
    const { nombre, correo } = req.body;
    const result = await ensurePool().query(
      'INSERT INTO users (nombre, correo) VALUES ($1, $2) RETURNING *',
      [nombre, correo]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// PUT /api/users/:id - Actualizar usuario
app.put('/api/users/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const userId = parseInt(id, 10);
    
    if (isNaN(userId)) {
      return res.status(400).json({ error: 'ID debe ser un número válido' });
    }
    
    const { nombre, correo } = req.body;
    const result = await ensurePool().query(
      'UPDATE users SET nombre=$1, correo=$2 WHERE id=$3 RETURNING *',
      [nombre, correo, userId]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// DELETE /api/users/:id - Eliminar usuario
app.delete('/api/users/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const userId = parseInt(id, 10);
    
    if (isNaN(userId)) {
      return res.status(400).json({ error: 'ID debe ser un número válido' });
    }
    
    const result = await ensurePool().query('DELETE FROM users WHERE id = $1 RETURNING *', [userId]);
    
    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }
    
    res.json({ message: 'Usuario eliminado' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Iniciar servidor en puerto 3000
app.listen(PORT, () => {
  console.log(`Servidor corriendo en puerto ${PORT}`);
});

