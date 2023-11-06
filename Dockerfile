# Utiliser l'image officielle PostgreSQL comme base
FROM postgres:latest
RUN apt-get update && apt-get install -y bc dos2unix

# Copier le script de benchmark dans le conteneur
COPY ./scripts /scripts
COPY ./.env /scripts/.env

# Rendre le script exécutable
RUN chmod +x /scripts/*.sh
