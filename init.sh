docker-compose exec koel sudo -Eu www-data php artisan koel:init --no-assets
docker-compose exec koel sudo -Eu www-data php artisan koel:search:import
