This is a very lightweight, simple Docker image running Grav CMS with the admin plugin under Alpine/Nginx/PHP7.

Although this was branched from evns/grav, there's nothing really remaining of those features.  I have removed the ACME Lets Encrypt parts, the environment variables that configure the admin user, and indeed the entire startup script.  It had bugs and I don't want ACME stuff cluttering up my Grav container (using Kubernetes, there are better ways).
The server does not run as "root", instead it runs as "nobody".  That also means it cannot bind to port 80, so all traffic comes into the container on port 8000.

For more info on Grav, visit the [Grav Website](https://getgrav.org/).

## Usage

I set the startup script so that it automatically copies the Grav installation to /var/www/html if it isn't already present.  That way, you can mount an empty volume there and it'll basically configure itself.
Also, /var/www/html/webserver-configs/grav.conf is the Nginx configuration file that is used to host the site.  Since you can't restart Nginx inside a docker container, if you want to tweak the config, just edit the file and restart the container (assuming you have a volume mounted there to retain file changes).

### Docker

The simplest way to run this image with docker alone is:

```
docker run -d -p 80:8000 -v /your/local/folder:/var/www/html jhughes2112/grav-nginx-alpine
```

This will run grav, and prompt for admin user setup on startup.  Grav will be available on [http://localhost/](http://localhost/)

### Docker-Compose

To simplify further, the site can be started using the following docker compose: 

```YAML
version: '2'
services:
  site:
    image: jhughes2112/grav-nginx-alpine
    restart: always
    ports:
      - "80:8000"
    volumes:
      - backup:/var/www/html/
volumes:
  backup:
    external: false
```

then run:

```
docker-compose up -d
```

This will do the following:
* Open port 80 for http access
* Create a volume named `backup` with the grav user data mounted into it


## Backing up

To create a backup, click the Backup button on the admin dashboard and download it.

## Restoring/migrating

To restore your site, copy the contents of your backup archive to the backup volume on the host.

