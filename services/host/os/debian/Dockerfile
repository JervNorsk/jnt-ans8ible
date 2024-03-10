FROM ubuntu

USER root

RUN apt update \
 && apt install -y \
        openssh-server \
        procps \
        net-tools \
 && apt clean

RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo -n 'root:admin' | chpasswd

ADD init /srv/init

ENTRYPOINT ["/srv/init/entrypoint.sh"]
CMD [ "/sbin/init"]
