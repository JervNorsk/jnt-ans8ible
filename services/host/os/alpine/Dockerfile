FROM alpine

USER root

RUN apk add --no-cache \
        openssh-server \
        procps \
        iputils

RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo -n 'root:admin' | chpasswd

ADD init /srv/init

ENTRYPOINT ["/srv/init/entrypoint.sh"]
CMD [ "/sbin/init"]
