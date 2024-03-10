FROM fedora

USER root

RUN dnf install -y \
        openssh-server \
        procps \
        iputils \
 && dnf clean all \
 && rm -r /var/cache/dnf

RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo -n 'root:admin' | chpasswd

ADD init /srv/init

ENTRYPOINT ["/srv/init/entrypoint.sh"]
CMD [ "/sbin/init"]
