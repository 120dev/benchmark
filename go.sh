sudo docker-compose down -v > /dev/null 2>&1
sudo docker-compose up -d --build --force-recreate > /dev/null 2>&1
sudo docker exec postgres_benchmark /scripts/postgres.sh