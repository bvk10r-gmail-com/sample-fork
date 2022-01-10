# Pull tomcat latest image from dockerhub
From tomcat:8.0

# Maintainer
MAINTAINER "VAMSI"

# copy war file on to container
COPY ./webapp.war /usr/local/tomcat/webapps

