FROM alpine

USER root

RUN apk add --no-cache \
        openrc \
        bash \
        python3 \
        openssh-server \
        procps \
        iputils

RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo -n 'root:admin' | chpasswd
RUN rc-update add sshd

ADD init /srv/init

ENTRYPOINT ["/srv/init/entrypoint.sh"]
CMD [ "/sbin/init"]

# FIXME: sshd is not started
