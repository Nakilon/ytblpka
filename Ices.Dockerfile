##FROM centos:7.2.1511
FROM centos:7

##RUN yum install -y less nano

RUN yum install -y gcc libxml2-devel libshout-devel make && yum clean -y all && curl -LO http://downloads.us.xiph.org/releases/ices/ices-2.0.2.tar.gz && tar zxf ices-2.0.2.tar.gz && cd ices-2.0.2 && ./configure && make install && yum remove -y gcc libxml2-devel make && yum autoremove -y

RUN touch playlist.txt
COPY Ices.entrypoint.sh /entrypoint.sh

## https://stackoverflow.com/a/30288835/322020
##RUN chmod +x /entrypoint.sh
##ENTRYPOINT ["/entrypoint.sh"]

CMD bash entrypoint.sh
