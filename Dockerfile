FROM php:8.4-apache

# Instalar extensiones necesarias para MongoDB
RUN apt-get update && apt-get install -y \
    libssl-dev \
    pkg-config \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copiar la aplicación
COPY . /var/www/html/

# Instalar dependencias de Composer
RUN composer install --no-dev --optimize-autoloader

# Configurar Apache para escuchar en todas las interfaces (0.0.0.0) en el puerto 80
# y usar el puerto de la variable PORT de Railway en tiempo de ejecución.
RUN sed -i 's/Listen 80/Listen 0.0.0.0:80/g' /etc/apache2/ports.conf && \
    sed -i 's/:80/:80/g' /etc/apache2/sites-available/000-default.conf

# Script de entrada personalizado para ajustar el puerto de Apache al de Railway
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Exponer el puerto 80 (Railway mapeará su PORT variable a este puerto internamente)
EXPOSE 80

# Usar el entrypoint personalizado
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
