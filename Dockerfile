FROM debian:jessie

MAINTAINER ReanGD

ENV DEBIAN_FRONTEND noninteractive

ADD * /home/

RUN echo en_US.UTF-8 UTF-8 > /etc/locale.gen && \
    echo ru_RU.UTF-8 UTF-8 >> /etc/locale.gen && \    
    \
    apt-get update && \
    apt-get install -y --no-install-recommends locales supervisor gcc git python-minimal python-pip python-dev python-six python-psycopg2 libxml2-dev libxslt1-dev libssl-dev nginx npm && \
    apt-get install -y --no-install-recommends vim && \
    \
    mkdir -p /www/tmp/spooler /www/app /www/static/jquery /www/static/bootstrap /www/static/django_ajax /www/static/angular /www/static/slickgrid /www/static/highcharts  /www/static/ng-table && \
    echo "daemon off;" >> /etc/nginx/nginx.conf && \
    rm /etc/nginx/sites-enabled/default && \
    \
    rm -rf /usr/local/lib/python2.7/dist-packages/requests* && \
	easy_install requests==2.3.0 && \
    pip install -r /home/requirements.txt && \
    \
    cp /usr/local/lib/python2.7/dist-packages/django_ajax/static/django_ajax/js/*.min.* /www/static/django_ajax && \
    \
    git clone --branch v4.0.0 https://github.com/highslide-software/highcharts.com.git /www/static/highcharts && \
    cd /www/static/highcharts && \
    rm -rf samples tools utils test studies .git bower.json build.md build.properties build.xml changelog.htm invalidations.txt readme.md ant && \
    \
    ln -s /usr/bin/nodejs /usr/bin/node && \
    npm install -g bower && \
    \
    cd /tmp && \
    bower --allow-root --config.interactive=false install --production jquery#2.1.3 bootstrap#3.3.1 slickgrid-fastColumnSizing#2.2.1 angular#v1.3.15 ng-table#v0.5.4 && \
    cp /tmp/bower_components/jquery/dist/*.min.* /www/static/jquery/ && \
    cp -r /tmp/bower_components/bootstrap/dist/* /www/static/bootstrap/ && \
    cp -r /tmp/bower_components/slickgrid-fastColumnSizing/* /www/static/slickgrid/ && \
    cp -r /tmp/bower_components/angular/* /www/static/angular/ && \
    cp -r /tmp/bower_components/ng-table/dist/* /www/static/ng-table/ && \
    \
    bower --allow-root --config.interactive=false cache clean && \
    rm -rf /.cache/bower && \
    rm -rf /tmp/bower_components && \
    npm uninstall -g bower && \
    \
    apt-get --purge remove --auto-remove -y python-pip npm gcc && \
    apt-get clean && \
    rm -rf /var/cache/apt/* && \
    rm -rf /var/lib/apt/* && \
    rm -rf /var/lib/dpkg/* && \
    rm -rf /var/lib/cache/* && \
    rm -rf /var/lib/log/* && \
    rm -rf /usr/share/i18n/ && \
    rm -rf /usr/share/doc/ && \
    rm -rf /usr/share/locale/ && \
    rm -rf /usr/share/man/ && \
    rm -rf /usr/sbin/locale-gen && \
    rm -rf /usr/sbin/update-locale && \
    rm -rf /usr/sbin/validlocale

ENV LANG ru_RU.UTF-8
ENV LANGUAGE ru_RU.UTF-8

EXPOSE 80/tcp

VOLUME ["/www/tmp", "/www/app"]

CMD /home/run.sh
