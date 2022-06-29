FROM debian:bullseye-slim

RUN export DEBIAN_FRONTEND="noninteractive" && \
  apt-get update && \
  apt-get install --no-install-recommends -y curl lsb-release gnupg wget awscli && \
  curl -o mysql-apt-config_0.8.22-1_all.deb https://repo.mysql.com/mysql-apt-config_0.8.22-1_all.deb && \
  dpkg -i mysql-apt-config_0.8.22-1_all.deb && \
  rm mysql-apt-config_0.8.22-1_all.deb && \
  apt-get update && \
  apt-get install --no-install-recommends -y mysql-client && \
  rm -rf /var/lib/apt/lists

COPY . /src

WORKDIR /src

CMD ["/bin/bash", "/src/dump_all.sh"]
