# based off of this:
# https://github.com/CentOS/CentOS-Dockerfiles/tree/master/httpd
# But here is one that is also S2I and on RHEL
# https://github.com/sclorg/httpd-container/blob/master/2.4/Dockerfile.rhel7
# This one is simpler because I am not doing S2I or SSL enablement.
# DO NOT USE IN PRODUCTION - this is just for teaching purposes

FROM registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift


MAINTAINER Derek Foo <dfoodfoo@gmail.com>

#RUN yum install -y --setopt=tsflags=nodocs httpd.x86_64 && yum clean all -y
RUN su -
RUN yum install -y bind-utils nc telnet net-tools git

# A custom httpd.conf that
# 1. binds to port 8080
# 2. sends all logs to stdout through log = "|more"
#COPY conf/httpd.conf /etc/httpd/conf/httpd.conf
#COPY index.html /var/www/html
#We will also bind it to a mount point where we can put stuff

#Expose the port
#EXPOSE 8080

# need to change some permissions to allow non-root user to start things
# had to do these steps to give the httpd deamon the ability to.
# This actually appears due to a bug with Windows and Mac. It looks like
# we could have just "ls" on the directory to get the chmod to stick
#RUN rm -rf /run/httpd && mkdir /run/httpd && chmod -R a+rwx /run/httpd

USER 1001

#ENTRYPOINT /usr/bin/bash
CMD while true; do echo "All I do is sleep 300 seconds continuously to keep this system up."; sleep 300 ; done

#run it with
 #docker run -p 80:80 6e3c25bdca9b
