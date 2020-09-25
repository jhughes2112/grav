FROM trafex/alpine-nginx-php7:latest

USER root

# Adds zip (Grav needs it) then grab Grav and install it
# This always installs the latest version of Grav
# Then, configures nginx with grav's conf file, actually linking directly to the version in webserver-configs in the backed-up folder, for easy tweaking.
RUN apk --no-cache add php7-zip && \
	wget https://getgrav.org/download/core/grav-admin/latest -O grav-admin.zip && \
    unzip grav-admin.zip && \
    rm grav-admin.zip && \
    cd grav-admin && \
    bin/gpm install -f -y admin && \
    ln -s /var/www/html/webserver-configs/nginx.conf /etc/nginx/conf.d/grav.conf

ADD grav.conf /var/www/html/webserver-configs/grav.conf

USER nobody
