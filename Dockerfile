FROM odoo:9.0
MAINTAINER Philipp Hug <philipp@hug.cx>

# Set user back to root
USER root

RUN apt-get update && apt-get install -y build-essential python-gevent python-dev python-pip libffi-dev libssl-dev && rm -rf /var/lib/apt/lists/*
RUN pip install psycogreen pysftp xlwt pyCrypto unidecode

ADD odoo /opt/odoo
ADD enterprise /opt/odoo-enterprise
ADD odoo-addons-mfgt /opt/odoo-mfgt

# remove web plugin
RUN rm -Rf /opt/odoo/addons/web

# Overwrite entrypoint with ours
COPY ./entrypoint.sh /

COPY ./openerp-server /usr/bin/openerp-server
RUN chmod +x /usr/bin/openerp-server
RUN chown odoo /usr/bin/openerp-server

COPY ./openerp-server.conf /etc/odoo/
#RUN chown odoo /etc/odoo/openerp-server.conf

# Set default user when running the container
USER odoo

