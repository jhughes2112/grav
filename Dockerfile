FROM trafex/alpine-nginx-php7:latest

USER root

# Adds zip (Grav needs it) then grab Grav and install it
# This always installs the latest version of Grav
# Then, configures nginx with grav's conf file, actually linking directly to the version in webserver-configs in the backed-up folder, for easy tweaking.
RUN apk --no-cache add php7-zip && \
	wget https://getgrav.org/download/core/grav-admin/latest -O grav-admin.zip && \
	mkdir /var/www/grav-admin && \
	mkdir /var/www/html/webserver-configs && \
    unzip grav-admin.zip -d /var/www/ && \
    rm grav-admin.zip && \
    cd /var/www/grav-admin && \
    bin/gpm install -f -y admin && \
    ln -s /var/www/html/webserver-configs/grav.conf /etc/nginx/conf.d/grav.conf

ADD grav.conf /var/www/grav-admin/webserver-configs/grav.conf
ADD grav.conf /var/www/html/webserver-configs/grav.conf
ADD startup.sh /startup.sh
RUN chmod a+rx /startup.sh && \
	chown nobody:nobody /startup.sh && \
	chown -R nobody:nobody /var/www/grav-admin && \
	chown -R nobody:nobody /var/www/html

USER nobody
ENTRYPOINT [ "/startup.sh" ]