#!/bin/bash

# Start root timer for total execution time measurement.
start_time_root=$(date +%s%N)

# Convert environment variables file from DOS to UNIX format and load it.
dos2unix /scripts/.env 
source /scripts/.env

# Wait until PostgreSQL is ready to accept commands.
while ! pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB} ; do
  sleep 2
done

# Create the required extensions if they are not already present.
psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -c "CREATE DATABASE bench;"
psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -c "CREATE DATABASE pgbench_db;"
psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -c "CREATE EXTENSION IF NOT EXISTS cube"
psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -c "CREATE EXTENSION IF NOT EXISTS earthdistance" 
psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -c "CREATE TABLE IF NOT EXISTS gps_data (id SERIAL PRIMARY KEY, latitude NUMERIC, longitude NUMERIC);"
psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -c "CREATE TABLE IF NOT EXISTS points_of_interest (id SERIAL PRIMARY KEY, name TEXT, latitude NUMERIC, longitude NUMERIC);"



echo "Benchmarking started..."
echo "Benchmarking started..." >> benchmark_results.txt

# Begin timing the pgbench insert operations.
start_time=$(date +%s%N)
pgbench -i -U ${POSTGRES_USER} pgbench_db
pgbench -U ${POSTGRES_USER} -c 15 -j 2 -t 1000 pgbench_db
duration=$(($(date +%s%N) - start_time))
echo "pgbench insertion time: $((duration / 1000000)) ms
" >> benchmark_results.txt
# --------------------------------------------------------------------------------------------------------------


# Insert fake GPS coordinates data.
start_time=$(date +%s%N)
for i in {1..100}; do
    lat=$(echo "40 + $RANDOM * 0.01" | bc -l)
    lon=$(echo "-73 + $RANDOM * 0.01" | bc -l)
    PGPASSWORD=${POSTGRES_PASSWORD} psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -c "INSERT INTO gps_data (latitude, longitude) VALUES ($lat, $lon);"  > /dev/null 2>&1
done
duration=$(($(date +%s%N) - start_time))
echo "GPS data insertion time: $((duration / 1000000)) ms" >> benchmark_results.txt

# Insert fake data for points of interest.
start_time=$(date +%s%N)
for i in {1..100}; do
    lat=$(echo "40 + $RANDOM * 0.01" | bc -l)
    lon=$(echo "-73 + $RANDOM * 0.01" | bc -l)
    PGPASSWORD=${POSTGRES_PASSWORD} psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -c "INSERT INTO points_of_interest (name, latitude, longitude) VALUES ('Point $i', $lat, $lon);"  > /dev/null 2>&1
done
duration=$(($(date +%s%N) - start_time))
echo "Points of interest insertion time: $((duration / 1000000)) ms" >> benchmark_results.txt

# Perform a complex query to find points of interest near GPS positions.
start_time=$(date +%s%N)
PGPASSWORD=${POSTGRES_PASSWORD} psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -c "
SELECT
    g.id,
    p.name,
    p.latitude,
    p.longitude,
    earth_distance(ll_to_earth(g.latitude, g.longitude), ll_to_earth(p.latitude, p.longitude)) as distance
FROM
    gps_data g
CROSS JOIN
    points_of_interest p
WHERE
    earth_box(ll_to_earth(g.latitude, g.longitude), 1000) @> ll_to_earth(p.latitude, p.longitude)
AND
    earth_distance(ll_to_earth(g.latitude, g.longitude), ll_to_earth(p.latitude, p.longitude)) < 1000;" > /dev/null
duration=$(($(date +%s%N) - start_time))
echo "Proximity complex query time: $((duration / 1000000)) ms" >> benchmark_results.txt

# Additional complex queries can be added here following the same pattern.
# ...

echo '-----------' >> benchmark_results.txt
duration_total=$(($(date +%s%N) - start_time_root))
echo "TOTAL TIME: $((duration_total / 1000000)) ms" >> benchmark_results.txt

cat benchmark_results.txt
