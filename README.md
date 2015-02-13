# mendix-docker
Docker setup files for Mendix PoC at Kadaster
This dockerfile is based on the Dockerfile created by pommi on https://github.com/pommi/mendix-docker/
Since I'm new at docker and just needed a runtime for installation within our infrastructure I added some
Features:
* m2ee tools installed for being able to manage the runtime without using the rest API
* installed additional OS packages procps and vim (checking status and changing container behaviour)
* runtime version 5.12.0 is downloaded during build (to prevent proxy issues when downloading a runtime)
* created a volume on /home/mendix/data/model-upload for adding the application to the runtime
* removed ipv6 support in nginx.conf because this doesn't work in kadaster environment where no ipv6 is available
* changed m2ee.yaml to use my own postgresql instance in a docker container
* created fig.yml with configuration for mendix app and the necessary postgresql database

# build the image
```
docker build --rm -t mendix-docker .
```

# run the image
just start using the provided fig.yml or use `bootdocker.sh`
```
fig up -d
```
the fig configuration starts a *app* container for the runtime and links to a *db* container which contains a postgresql database.

## changing ownership on attached volume to mendix user
Because the attached volume is used by the user `mendix` within the app container ti is necessary that the user has at least read rights. This can either be done on the host volume itself or by changing the owner ship on the mounted volume from within the app container (remember, within docker containers you are root :-) )
```
docker exec -it mendix_app_1 chown mendix:mendix -R /home/mendix/data/model-upload
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
### save the image to a tar file
```
docker save --output=mendix-docker.tar mendix-docker
```
This tar can be transported to the destination machine (with whatever means necessary and available (be creative :-) )
### load the image from a tar file
It can then be imported using:
```
docker load --input=mendix-docker.tar
```
If `--input` leads to an error, then use docker load based on `stdin` because of problems using the `--input` flag with corrupted tar messages:
```
cat mendix-docker.tar > docker load
```
