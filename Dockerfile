# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║ SOURCE BUILD                                                              ║
# ║                                                                           ║
# ║ Build the docker cli binary                                               ║
# ║                                                                           ║
# ╚═══════════════════════════════════════════════════════════════════════════╝
FROM    golang:1.13.15-alpine as src-docker

RUN apk add --no-cache git \
                      bash \
                      coreutils \
                      gcc \
                      musl-dev

ENV CGO_ENABLED=0 \
    DISABLE_WARN_OUTSIDE_CONTAINER=1

RUN mkdir -p /go/src/github.com/docker \
 && cd /go/src/github.com/docker \
 && git clone --depth 1 https://github.com/docker/cli.git

WORKDIR /go/src/github.com/docker/cli

RUN ./scripts/build/binary

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║ SOURCE BUILD                                                              ║
# ║                                                                           ║
# ║ Build the kubectl binary                                                  ║
# ║                                                                           ║
# ╚═══════════════════════════════════════════════════════════════════════════╝
FROM alpine:edge as src-kubernetes

RUN apk add --no-cache  bash \
			build-base \
			git \
                        go \
                        make \
			rsync \
			tar \
			tzdata

RUN git config --global advice.detachedHead false \
 && git clone -b v1.19.3 --depth 1 https://github.com/kubernetes/kubernetes

WORKDIR /kubernetes
RUN make kubectl

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║ CONTAINER BUILD                                                           ║
# ║                                                                           ║
# ║ Cluster Environment build for development and administration              ║
# ║                                                                           ║
# ╚═══════════════════════════════════════════════════════════════════════════╝
FROM alpine:3.12.1

# Expose Ports
EXPOSE 22/tcp 137/udp 138/udp 139/tcp 445/tcp
# EXPOSE 22/tcp

# Timezone
COPY --from=src-kubernetes /usr/share/zoneinfo/America/New_York /etc/localtime
RUN echo "America/New_York" > /etc/timezone

RUN apk add --no-cache	curl \
		        docker-cli \
			git \
			libxdg-basedir \
			nano \
		        openssh \
                        samba \
			screen \
			sudo \
			shadow \
			zsh


# user
# ----
RUN echo "%wheel         ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    adduser -D -s /bin/zsh prometheus && \
    echo 'prometheus:prometheus' | chpasswd && \
    usermod -aG wheel prometheus
    # passwd --expire prometheus && \
    # zsh install plugins

# system
# ------
# configure - motd
COPY etc/motd /etc/motd
# install - xdg 
COPY etc/xdg.sh /etc/profile.d/xdg.sh
# configure - xdg
RUN mkdir -p /home/prometheus/.config \
             /home/prometheus/.cache \
             /home/prometheus/.local/share \
             /home/prometheus/.var \
 && mkdir -p /opt/cluster-data \
 && chmod 0777 /opt/cluster-data \
 && chown -R prometheus:prometheus /home/prometheus

# zsh
# ---
# install - powerlevel10k
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /var/lib/powerlevel10k
# configuration - powerlevel10k
# RUN echo 'source /var/lib/powerlevel10k/powerlevel10k.zsh-theme' >> /home/prometheus/.zshrc
# COPY zsh/cache /home/prometheus/.cache
COPY config /home/prometheus/.config
RUN ln -s /home/prometheus/.config/zsh/rc /home/prometheus/.zshrc

# ssh
# ---
RUN ssh-keygen -A

#
# smb
# ---
RUN mv /etc/samba/smb.conf /etc/samba/smb.conf~
COPY etc/smb.conf /etc/samba/smb.conf

# kubectl
# -------
# install
COPY --from=src-kubernetes /kubernetes/_output/local/bin/linux/arm64/kubectl /usr/bin/kubectl
# configure
COPY kube /home/prometheus/.kube

# docker
# ------
COPY --from=src-docker /go/src/github.com/docker/cli/build/docker-linux-arm64 /usr/bin/docker

RUN echo $(date) > /flip-flop
COPY entrypoint /entrypoint
ENTRYPOINT ["/entrypoint"]
CMD ["tail", "-f", "/dev/null"]


# CMD ["/entrypoint"]

# CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]

# RUN apk del --no-cache shadow
