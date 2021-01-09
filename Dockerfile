FROM ubuntu:16.04
ENV user mysql
ENV group mysql
ENV uid 1000
ENV gid 1000

RUN groupadd -g ${gid} ${group} \
  && useradd -u ${uid} -g ${gid} -s /bin/bash ${user}

RUN apt-get update \
  && apt-get install -y software-properties-common supervisor lsb-core \
  && apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 \
  && add-apt-repository "deb [arch=amd64,arm64,ppc64el] http://mariadb.mirror.liquidtelecom.com/repo/10.4/ubuntu $(lsb_release -cs) main" \
  && apt update \
  && apt -y install mariadb-server \
  && rm -rf /var/lib/apt/lists/* && apt-get clean \
  && mv /var/lib/mysql /opt

COPY conf/startup.sh /scripts/startup.sh
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf


EXPOSE 3306
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
#ENTRYPOINT ["/bin/bash", "-c", "/usr/bin/mysqld --user=mysql --console --skip-networking=0"]

