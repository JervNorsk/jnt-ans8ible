FROM ghcr.io/ansible-community/community-ee-minimal

USER root
RUN dnf install -y  \
        make \
        procps \
        iputils \
 && dnf install -y \
        dnf-plugins-core \
 && dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo \
 && dnf install -y  \
            docker \
            docker-compose-plugin \
            jq \
 && dnf clean all \
 && rm -r /var/cache/dnf

ADD init /srv/init

#USER 1000
RUN /srv/init/scripts/setup-ssh.sh

RUN ansible-galaxy collection install community.general

RUN ansible-galaxy collection install middleware_automation.wildfly

RUN pip3 install pymysql
RUN #ansible-galaxy collection install community.mysql

ENTRYPOINT ["/srv/init/entrypoint.sh"]
CMD ["/bin/bash"]
