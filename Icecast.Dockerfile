FROM centos:7
COPY icecast.xml /
CMD cat icecast.xml
