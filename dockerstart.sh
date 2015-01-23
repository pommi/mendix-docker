# run postgres instance
docker run --name mendix_db -p 5432:5432 -e POSTGRES_USER=mendix -e POSTGRES_PASSWORD=mendix -d postgres
# run mendix runtime
docker run --name mendix -p 5000:5000 -p 7000:7000 --link mendix_db:db -d mendix-docker
