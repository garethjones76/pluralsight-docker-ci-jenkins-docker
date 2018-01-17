FROM jenkins:latest
 
USER root
RUN apt-get update \
      && apt-get install -y sudo \
      && rm -rf /var/lib/apt/lists/* \
      && mkdir src \
      && cd /src \
      && curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - \
      && sudo apt-get install -y nodejs \
      && npm install 
      
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
 
USER jenkins
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
RUN   cd /var/jenkins_home/workspace/docker-ci
      &&  npm install
      &&  node_modules/.bin/mocha
RUN mkdir /var/jenkins_home/.ssh \
COPY known_hosts /var/jenkins_home/.ssh/
COPY id_rsa.pub /var/jenkins_home/.ssh/
COPY id_rsa /var/jenkins_home/.ssh/
RUN  chmod 700 /var/jenkins_home/.ssh \
     &&  chmod 644 /var/jenkins_home/.ssh/known_hosts \
     &&  chmod 644 /var/jenkins_home/.ssh/id_rsa.pub \
     &&  chmod 600 /var/jenkins_home/.ssh/id_rsa 
