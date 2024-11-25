FROM jenkins/jenkins:2.486-jdk21

USER root

RUN apt-get update && apt-get install -y lsb-release

RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg

RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

RUN apt-get update && apt-get install -y docker-ce-cli

COPY --chown=jenkins:jenkins ./casc_configs/jenkins.yaml /usr/share/jenkins/ref/casc_configs/jenkins.yaml
RUN chmod u=rwx /usr/share/jenkins/ref/casc_configs

COPY --chown=jenkins:jenkins ./.ssh /usr/share/jenkins/ref/.ssh/
RUN chmod u=rwx /usr/share/jenkins/ref/.ssh/

COPY --chown=jenkins:jenkins ./plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN chmod u=r /usr/share/jenkins/ref/plugins.txt

COPY --chown=jenkins:jenkins entrypoint.sh /entrypoint.sh
RUN chmod u=rx /entrypoint.sh

USER jenkins

RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

ENTRYPOINT [ "/entrypoint.sh" ]
