# 使用CentOS 7的官方镜像作为基础镜像  
FROM centos:7  
   
MAINTAINER yunmiao 2893267956@qq.com

ADD resources/yacd.tar.xz /data/yacd.tar.xz
ADD resources/Country.mmdb /data/Country.mmdb
ADD resources/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
ADD resources/clash-linux-amd64-v1.11.12.gz /data/clash-linux-amd64-v1.11.12.gz

RUN cd /etc/yum.repos.d/ && \
	yum clean all && \
	yum makecache

RUN yum install -y wget gzip xz tar  

RUN mkdir -p ~/.config/clash && \
	cd ~/.config/clash && \
	wget https://sub1.fawncloud.one/link/5iAR3PZYPjXSY3Ur?clash=1 -O config.yaml

WORKDIR /data

RUN gzip -d clash-linux-amd64-v1.11.12.gz && \
	mv clash-linux-amd64-v1.11.12 clash && \
	chmod +x clash && \
	mv Country.mmdb ~/.config/clash/

  
# 暴露端口
EXPOSE 7890
EXPOSE 7891
EXPOSE 7892
EXPOSE 9090
  
# 定义容器启动时执行的命令
CMD ["/bin/bash", "-c", "/data/clash"]
# CMD ["bash", "-c", "while true; do echo 'Container is running'; sleep 1; done"]

