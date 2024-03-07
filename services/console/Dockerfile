FROM ghcr.io/ansible-community/community-ee-minimal

USER root
RUN dnf check-update || exit 0
RUN dnf install -y  \
        procps \
        iputils \
        make \
        jq
# && dnf clean all \
# && rm -r /var/cache/dnf

ADD init /srv/init

RUN /srv/init/scripts/setup-ssh.sh

#USER 1000

RUN ansible-galaxy collection install middleware_automation.wildfly

ENTRYPOINT ["/srv/init/entrypoint.sh"]
