# mendix-docker
Docker setup files for Mendix PoC at Kadaster

# build the image
```
docker build --rm -t mendix-docker .
```

# run the image
just start using the provided fig.yml or use `bootdocker.sh`
```
fig up -d
```

# <a name="transfer"></a>transfer the image to Kadaster environment
due to proxy restrictions building the image behind the firewall is difficult (although technically not impossiible). Therefore I choose to build the image externally without restrictions and the copying the image to the destination machine.
```
docker save --output=mendix-docker.tar mendix-docker
```
This tar can be transported to the destination machine (with whatever means necessary and available (be creative :-) )
It can then be imported using:
```
cat mendix-docker.tar > docker load
```
I use docker load based on `stdin` because of problems using the `--input` flag with corrupted tar messages, otherwise the next command would be more logical:
```
docker load --input=medix-docker.tar
```

# bypass for installing runtime behind proxy
I can't get the m2ee tools to download the mendix runtime, therefore I installed the runtime by running the mendix container and then commiting the result to a new image:
```
# attach to container
docker exec -it mendix_app_1 /bin/bash
# in container as root
su mendix
m2ee
download_runtime 5.5.0
# exit container
docker commit --message="runtime 5.5.0 installed" {containerid} mendix-docker-rt550
```
the newly created image can be [transported](#transfer) to the destination machine 
