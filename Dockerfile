FROM debian:trixie-slim

RUN export DEBIAN_FRONTEND="noninteractive" && \
  apt-get update && \
  apt-get install --no-install-recommends -y curl ca-certificates lsb-release gnupg wget awscli bzip2 jq && \
  curl -L -o /usr/local/bin/supercronic https://github.com/aptible/supercronic/releases/download/v0.2.47/supercronic-linux-amd64 && \
  echo "dcb1403c188a9438c47d4bba82a9c357fc9351ce91627fb2bae627f0f5becfc4 /usr/local/bin/supercronic" | sha256sum -c - && \
  chmod +x /usr/local/bin/supercronic && \
  curl -O https://repo.mysql.com/mysql-apt-config_0.8.39-1_all.deb && \
  echo "45bcfcd426dd548980c391e2c3c8e399899fea661035d4d0a059e0494721f7e0 mysql-apt-config_0.8.39-1_all.deb" | sha256sum -c - && \
  dpkg -i mysql-apt-config_0.8.39-1_all.deb && \
  rm mysql-apt-config_0.8.39-1_all.deb && \
  apt-get update && \
  apt-get install --no-install-recommends -y mysql-client && \
  rm -rf /var/lib/apt/lists

COPY . /src

WORKDIR /src

CMD ["/src/entrypoint.sh"]
