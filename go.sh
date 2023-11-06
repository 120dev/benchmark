sudo docker-compose down -v 
sudo docker-compose up -d --build --force-recreate 
sudo docker exec postgres_benchmark /scripts/postgres.sh