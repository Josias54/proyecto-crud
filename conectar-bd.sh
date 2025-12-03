#!/bin/bash
# Script para conectarse a la base de datos PostgreSQL en Render
# Ejecuta este script desde Linux/Mac/WSL

# Tu Database URL (ajusta si es necesario)
DATABASE_URL="postgresql://crud_db_r791_user:znL2ZXteEAncQpr5tTwCKMLB9lDcLh2k@dpg-d4masrchg0os73bnoaq0-a.oregon-postgres.render.com:5432/crud_db_r791"

echo "========================================"
echo "  Conectando a PostgreSQL en Render"
echo "========================================"
echo ""

# Verificar si psql está instalado
if ! command -v psql &> /dev/null; then
    echo "❌ psql no está instalado."
    echo ""
    echo "Para instalar psql:"
    echo "  Ubuntu/Debian: sudo apt-get install postgresql-client"
    echo "  Mac: brew install postgresql"
    echo "  CentOS/RHEL: sudo yum install postgresql"
    echo ""
    echo "Alternativa: Usa la opción automática - tu código crea la tabla solo."
    exit 1
fi

echo "✅ psql encontrado"
echo ""
echo "Conectando a la base de datos..."
echo ""

# SQL para crear la tabla
CREATE_TABLE_SQL="CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    correo TEXT
);"

# Conectarse y crear la tabla
echo "Ejecutando: CREATE TABLE users..."
echo "$CREATE_TABLE_SQL" | psql "$DATABASE_URL"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Tabla 'users' creada exitosamente!"
    echo ""
    echo "Verificando que la tabla existe..."
    echo "\dt" | psql "$DATABASE_URL"
    
    echo ""
    echo "========================================"
    echo "  ✅ Conexión exitosa!"
    echo "========================================"
else
    echo ""
    echo "⚠️  Hubo un problema. Verifica la URL de conexión."
    echo "   Asegúrate de que la URL incluya el dominio completo:"
    echo "   postgresql://usuario:password@host:5432/database"
fi

echo ""
echo "💡 Tip: Si tienes problemas, usa la opción automática."
echo "   Tu código crea la tabla automáticamente al iniciar."

