sudo docker-compose down -v 
sudo docker-compose up -d --build --force-recreate
# Attendre que PostgreSQL soit prêt
echo "En attente de la disponibilité de PostgreSQL..."
until sudo docker exec postgres_benchmark pg_isready -U postgres > /dev/null 2>&1; do
  sleep 1
  echo -n "."
done
echo "PostgreSQL est prêt."
sudo docker exec postgres_benchmark /scripts/postgres.sh