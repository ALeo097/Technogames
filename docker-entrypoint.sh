#!/bin/bash
set -e

# Si la variable PORT de Railway está definida, úsala. Si no, usa el 80 por defecto.
if [ -n "$PORT" ]; then
    echo "Configurando Apache para escuchar en el puerto: $PORT"
    sed -i "s/Listen 80/Listen ${PORT}/g" /etc/apache2/ports.conf
    sed -i "s/:80/:${PORT}/g" /etc/apache2/sites-available/000-default.conf
else
    echo "No se encontró la variable PORT, usando el puerto 80 por defecto."
fi

# Ejecuta el comando que se pase como argumento (apache2-foreground)
exec "$@"
