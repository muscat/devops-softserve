FROM ubuntu:latest

COPY ./conf/wordpress.conf      /etc/apache2/sites-available/wordpress.conf
COPY ./conf/wordpress-SSL.conf  /etc/apache2/sites-available/wordpress-SSL.conf

COPY ./conf/start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
