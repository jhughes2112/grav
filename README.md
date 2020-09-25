This is a simple Docker image running Grav CMS with the admin plugin under Alpine/Nginx/PHP7.

Although this was branched from evns/grav, I have removed the ACME Lets Encrypt parts, the environment variables that configure the admin user, and indeed the entire startup script.  It had bugs and I don't want ACME stuff cluttering up my Grav container (using Kubernetes, there are better ways).

For more info on Grav, visit the [Grav Website](https://getgrav.org/).

## Usage

### Docker

The simplest way to run this image with docker alone is:

```
docker run -d -p 80:80 -v /your/local/folder:/var/www/html jhughes2112/grav-nginx
```

This will run grav, and prompt for admin user setup on startup.  Grav will be available on [http://localhost/](http://localhost/)

### Docker-Compose

To simplify further, the site can be started using the following docker compose: 

```YAML
version: '2'
services:
  site:
    image: jhughes2112/grav-nginx
    restart: always
    ports:
      - "80:80"
      - "443:443"
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
* Open ports 80 and 443 for http(s) access
* Configure the admin user
* Create a volume named `backup` with the grav user data mounted into it
* Generate trusted certificates for 'example.com' using Let's Encrypt
* Configure Nginx with SSL


## Backing up

To create a backup, click the Backup button on the admin dashboard and download it.

## Restoring/migrating

To restore your site, copy the contents of your backup archive to the backup volume on the host.

