FROM alpine:latest

# Set language to avoid bugs that sometimes appear
ENV LANG en_US.UTF-8

# Set up requirements
RUN echo "root:root" | chpasswd \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --no-cache \
      openconnect \
      openvpn \
      openssh \
      vim \
    && mkdir ${HOME}/.ssh \
# Clean-up
    && rm  -rf /tmp/* /var/cache/apk/*

# Allow SOCKS proxy
RUN sed -i 's/AllowTcpForwarding/#AllowTcpForwarding/g' /etc/ssh/sshd_config

COPY ./domirete* /etc/openvpn/
#COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
#RUN chmod +x /usr/local/bin/docker-entrypoint.sh

#ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["sh", "-c", "echo \"${SSH_KEY}\" > ~/.ssh/authorized_keys && ssh-keygen -A && /usr/sbin/sshd && openvpn --config /etc/openvpn/domirete.conf"]
