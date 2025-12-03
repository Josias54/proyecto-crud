# Script para conectarse a la base de datos PostgreSQL en Render
# Ejecuta este script desde PowerShell

# Tu Database URL (ajusta si es necesario)
$DATABASE_URL = "postgresql://crud_db_r791_user:znL2ZXteEAncQpr5tTwCKMLB9lDcLh2k@dpg-d4masrchg0os73bnoaq0-a.oregon-postgres.render.com:5432/crud_db_r791"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Conectando a PostgreSQL en Render" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar si psql está instalado
$psqlPath = Get-Command psql -ErrorAction SilentlyContinue

if (-not $psqlPath) {
    Write-Host "❌ psql no está instalado." -ForegroundColor Red
    Write-Host ""
    Write-Host "Para instalar psql en Windows:" -ForegroundColor Yellow
    Write-Host "1. Descarga PostgreSQL desde: https://www.postgresql.org/download/windows/" -ForegroundColor Yellow
    Write-Host "2. O instala usando Chocolatey: choco install postgresql" -ForegroundColor Yellow
    Write-Host "3. O usa WSL (Windows Subsystem for Linux)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Alternativa: Usa la opción automática - tu código crea la tabla solo." -ForegroundColor Green
    exit 1
}

Write-Host "✅ psql encontrado" -ForegroundColor Green
Write-Host ""
Write-Host "Conectando a la base de datos..." -ForegroundColor Yellow
Write-Host ""

# Conectarse y crear la tabla
$createTableSQL = @"
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    correo TEXT
);
"@

# Intentar conectar y crear la tabla
try {
    Write-Host "Ejecutando: CREATE TABLE users..." -ForegroundColor Yellow
    echo $createTableSQL | psql $DATABASE_URL
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✅ Tabla 'users' creada exitosamente!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Verificando que la tabla existe..." -ForegroundColor Yellow
        
        # Verificar que la tabla existe
        echo "\dt" | psql $DATABASE_URL
        
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host "  ✅ Conexión exitosa!" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Cyan
    } else {
        Write-Host ""
        Write-Host "⚠️  Hubo un problema. Verifica la URL de conexión." -ForegroundColor Yellow
        Write-Host "   Asegúrate de que la URL incluya el dominio completo:" -ForegroundColor Yellow
        Write-Host "   postgresql://usuario:password@host:5432/database" -ForegroundColor Yellow
    }
} catch {
    Write-Host ""
    Write-Host "❌ Error al conectar: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Verifica:" -ForegroundColor Yellow
    Write-Host "1. Que la URL esté completa (con dominio y puerto)" -ForegroundColor Yellow
    Write-Host "2. Que uses la External Database URL (no Internal)" -ForegroundColor Yellow
    Write-Host "3. Que tu IP esté permitida (algunos planes de Render requieren whitelist)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "💡 Tip: Si tienes problemas, usa la opción automática." -ForegroundColor Cyan
Write-Host "   Tu código crea la tabla automáticamente al iniciar." -ForegroundColor Cyan

