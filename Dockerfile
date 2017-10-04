# based off of this:
# https://github.com/CentOS/CentOS-Dockerfiles/tree/master/httpd
# But here is one that is also S2I and on RHEL
# https://github.com/sclorg/httpd-container/blob/master/2.4/Dockerfile.rhel7
# This one is simpler because I am not doing S2I or SSL enablement.
# DO NOT USE IN PRODUCTION - this is just for teaching purposes

#FROM registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift
#FROM registry.access.redhat.com/rhel7
FROM centos:centos7

MAINTAINER Derek Foo <dfoodfoo@gmail.com>

#RUN yum install -y --setopt=tsflags=nodocs httpd.x86_64 && yum clean all -y
RUN yum -y install wget
#RUN wget http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7
#RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
#RUN rpm --import RPM-GPG-KEY-CentOS-7
#RUN wget http://mirror.centos.org/centos-7/7/os/x86_64/Packages/centos-release-7-4.1708.el7.centos.x86_64.rpm
#RUN wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
#RUN wget http://mirror.centos.org/centos/7/os/x86_64/Packages/aether-1.13.1-13.el7.noarch.rpm
#RUN rpm -ivh centos-release-7-4.1708.el7.centos.x86_64.rpm
#RUN yum-config-manager --enable rhel-7-server-optional-rpm
RUN wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
RUN yum -y install which java-1.8.0-openjdk.x86_64 bind-utils nc telnet net-tools git apache-maven sudo && yum clean all
RUN groupadd -r citrusgrp -g 1001 && useradd -u 1001 -r -g citrusgrp -m -d /opt/maven -s /usr/bin/bash -c "citrus" citrus && chmod 755 /opt/maven && passwd -d citrus
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.144-0.b01.el7_4.x86_64" >> /etc/profile && \
    echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile && \
    echo "export MAVEN_HOME=/usr/share/maven" >> /etc/profile && \
    echo "export PATH=\$MAVEN_HOME/bin:\$PATH" >> /etc/profile && \
    mkdir /citrus && chmod 777 /citrus && \ 
    echo "ALL ALL=NOPASSWD: /usr/bin/su - citrus" >> /etc/sudoers && \
    chmod a+s /bin/su
WORKDIR /citrus

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
