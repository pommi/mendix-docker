Docker setup files for Mendix

## build the image
```
docker-compose build
```

## run the image
```
docker-compose up -d
```

## start the App
```
# exec in to container
docker exec -it mendix_app su mendix -c "cd; /bin/bash"
curl http://download.mendix.com/sample/sample.mda -o data/model-upload/sample.mda
m2ee --yolo unpack sample.mda
m2ee download_runtime
m2ee --yolo start
```

## visit the App
```
curl localhost:$(docker inspect -f '{{(index (index .NetworkSettings.Ports "8000/tcp") 0).HostPort}}' mendix_app)
```
