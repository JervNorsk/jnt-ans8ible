FROM ghcr.io/ansible-community/community-ee-minimal

USER root

RUN dnf install -y \
        procps \
        iputils \
        openssh-server \
 && dnf clean all \
 && rm -r /var/cache/dnf

RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo -n 'root:admin' | chpasswd

ADD init /srv/init

ENTRYPOINT ["/srv/init/entrypoint.sh"]
CMD [ "/sbin/init"]
