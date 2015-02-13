# mendix-docker
Docker setup files for Mendix PoC at Kadaster
* runtime version 5.12.0 is downloaded during build (to prevent proxy issues)
* removed ipv6 support in nginx.conf because this doesn't work in kadaster environment

# build the image
```
docker build --rm -t mendix-docker .
```

# run the image
just start using the provided fig.yml or use `bootdocker.sh`
```
fig up -d
```

## changing ownership on attached volume to mendix user
```
docker exec -it mendix_app_1 'chown mendix:mendix -R /home/mendix/data/model-upload'
```
## running the test application
```
# exec in to container
docker exec -it mendix_app_1 /bin/bash
su mendix
m2ee
unpack App_1.0.0.3.mda
start
```
If m2ee asks for updating the database then just accept this and do so.
The default user for the test appication is : `MxUser`
You can create a password for this user within the m2ee tools using the `create-admin-user` command

# TL;DR
## <a name="transfer"></a>transfer the image to Kadaster environment
due to proxy restrictions building the image behind the firewall is difficult (although technically not impossiible). Therefore I choose to build the image externally without restrictions and the copying the image to the destination machine.
```
docker save --output=mendix-docker.tar mendix-docker
```
This tar can be transported to the destination machine (with whatever means necessary and available (be creative :-) )
It can then be imported using:
```
docker load --input=mendix-docker.tar
```
If `--input` leads to an error, then use docker load based on `stdin` because of problems using the `--input` flag with corrupted tar messages:
```
cat mendix-docker.tar > docker load
```

# bypass for installing runtime behind proxy
I can't get the m2ee tools to download the mendix runtime when behind the proxy, therefore I donwloaded the runtime 5.12.0 as part of the build itself
