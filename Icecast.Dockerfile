##FROM centos:7.2.1511
FROM centos:7

RUN yum install -y https://centos7.iuscommunity.org/ius-release.rpm
RUN yum install -y icecast

EXPOSE 8000

##RUN yum install -y less nano net-tools

COPY player.htm /usr/share/icecast/web/
COPY Icecast.entrypoint.sh /entrypoint.sh

## https://stackoverflow.com/a/30288835/322020
##RUN chmod +x /entrypoint.sh
##ENTRYPOINT ["/entrypoint.sh"]

CMD bash entrypoint.sh
