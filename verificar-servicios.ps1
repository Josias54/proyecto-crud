# Script de verificación de servicios CRUD
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Verificación de Servicios CRUD" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar contenedores
Write-Host "1. Verificando contenedores Docker..." -ForegroundColor Yellow
docker-compose ps
Write-Host ""

# Verificar PostgreSQL
Write-Host "2. Verificando PostgreSQL..." -ForegroundColor Yellow
docker-compose exec -T postgres-db psql -U postgres -d crud_db -c "SELECT 'PostgreSQL OK' as estado, COUNT(*) as usuarios FROM users;" 2>&1
Write-Host ""

# Verificar API Service
Write-Host "3. Verificando API Service..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost/api/users" -UseBasicParsing -ErrorAction Stop
    Write-Host "✓ API Service responde correctamente" -ForegroundColor Green
    Write-Host "  Respuesta: $($response.Content)" -ForegroundColor Gray
} catch {
    Write-Host "✗ Error al conectar con API Service: $_" -ForegroundColor Red
}
Write-Host ""

# Verificar Health Endpoint
Write-Host "4. Verificando Health Endpoint..." -ForegroundColor Yellow
try {
    $health = Invoke-WebRequest -Uri "http://localhost/api/health" -UseBasicParsing -ErrorAction Stop
    Write-Host "✓ Health endpoint responde" -ForegroundColor Green
    $healthData = $health.Content | ConvertFrom-Json
    Write-Host "  Estado: $($healthData.status)" -ForegroundColor Gray
    if ($healthData.database) {
        Write-Host "  Base de datos: $($healthData.database.database)" -ForegroundColor Gray
        Write-Host "  Host: $($healthData.database.host)" -ForegroundColor Gray
    }
} catch {
    Write-Host "✗ Error al verificar health: $_" -ForegroundColor Red
}
Write-Host ""

# Verificar NGINX Gateway
Write-Host "5. Verificando NGINX Gateway..." -ForegroundColor Yellow
try {
    $nginx = Invoke-WebRequest -Uri "http://localhost/" -UseBasicParsing -ErrorAction Stop
    Write-Host "✓ NGINX Gateway sirve la página web correctamente" -ForegroundColor Green
    Write-Host "  Tamaño de respuesta: $($nginx.Content.Length) bytes" -ForegroundColor Gray
} catch {
    Write-Host "✗ Error al conectar con NGINX Gateway: $_" -ForegroundColor Red
}
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Verificación completada" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Abre http://localhost en tu navegador para usar la aplicacion CRUD" -ForegroundColor Green

