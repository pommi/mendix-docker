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

# transfer the image to Kadaster environment
due to proxy restrictions building the image behind the firewall is difficult (although technically not impossiible). Therefore I choose to build the image externally without restrictions and the copying the image to the destination machine.
```
docker save --output=mendix-docker.tar mendix-docker
```
This tar can be transported to the destination machine (with whatever means necessary and available (be creative :-) )
It can then be imported using:
```
cat mendix-docker.tar > docker load
```
I use docker load based on `stdin` because of problems using the `--input` flag eith corrupted tar messages
