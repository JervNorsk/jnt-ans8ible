FROM ghcr.io/ansible-community/community-ee-minimal

USER root
RUN dnf install -y  \
        procps \
        iputils \
        make \
        jq \
 && dnf clean all \
 && rm -r /var/cache/dnf

ADD init /srv/init

#USER 1000
RUN /srv/init/scripts/setup-ssh.sh

RUN ansible-galaxy collection install middleware_automation.wildfly

ENTRYPOINT ["/srv/init/entrypoint.sh"]
