# 基于Centos搭建CLASH科学上网

## 1. 所需环境

1. 一台具备docker环境的机器，这里笔者是Centos7
2. git环境
3. vpn机场节点

## 2. 服务搭建

克隆代码至服务器，这里我的路径是/project/clash

```sh
[root@VM-8-14-centos clash]# git clone https://github.com/moonlight2893267956/clash_on_remote.git
Cloning into 'clash_on_remote'...
remote: Enumerating objects: 9, done.
remote: Counting objects: 100% (9/9), done.
remote: Compressing objects: 100% (8/8), done.
remote: Total 9 (delta 0), reused 9 (delta 0), pack-reused 0 (from 0)
Unpacking objects: 100% (9/9), done.
```

进入Dockerfile输入自己机场的Clash订阅链接

```dockerfile
RUN mkdir -p ~/.config/clash && \
        cd ~/.config/clash && \
        wget <你的订阅链接> -O config.yaml
```

执行Dockerfile

```sh
[root@VM-8-14-centos clash_on_remote]# docker build -t centos7-with-tools .
```

有如下打印代表build成功

![image-20240925175304186](https://yunmiao-bucket.oss-cn-beijing.aliyuncs.com/markdown/image-20240925175304186.png)

初始化执行如下指令开启一个名为centos的容器，创建config目录，将容器中的配置文件目录copy到config目录下

```sh
[root@VM-8-14-centos clash_on_remote]# docker run -d --name centos -p 7890:7890 -p 7891:7891 -p 7892:7892 -p 9090:9090 -p 7890:7890/udp -p 7891:7891/udp -p 7892:7892/udp -p 9090:9090/udp centos7-with-tools:latest
e03ed2b45ba9e0a6f30cff66212bb78239a7bd5c7a5c71aa37aa55cef29494c7

[root@VM-8-14-centos clash_on_remote]# mkdir config

[root@VM-8-14-centos clash_on_remote]# docker cp centos:/root/.config/clash ./config/
```

可以看到多了一个config/clash目录

![image-20240925180146981](https://yunmiao-bucket.oss-cn-beijing.aliyuncs.com/markdown/image-20240925180146981.png)

```sh
[root@VM-8-14-centos clash]# vi config.yaml 

port: 7890
socks-port: 7891
redir-port: 7892
allow-lan: false
mode: rule
log-level: silent
external-controller: '0.0.0.0:9090'
# clash WebUI固定写法
external-ui: '/data/yacd.tar.xz/public'
# 密码，可以不写
secret: ''

```

推出后结束并删除容器：

```sh
[root@VM-8-14-centos clash]# docker stop e03ed2b45ba9
e03ed2b45ba9
[root@VM-8-14-centos clash]# docker rm e03ed2b45ba9
e03ed2b45ba9
```

以自己的数据卷启动容器，一定要注意配置文件路径

```sh
[root@VM-8-14-centos clash]# docker run -d --name centos -p 7890:7890 -p 7891:7891 -p 7892:7892 -p 9090:9090 -p 7890:7890/udp -p 7891:7891/udp -p 7892:7892/udp -p 9090:9090/udp -v /project/clash/clash_on_remote/config/clash:/root/.config/clash/ centos7-with-tools:latest
c78aed5451b1b2171a69841f22d0ccda8b9b7feed3b89eef5a993c4f8bec6365
```

服务器防火墙开启9090端口，即可访问UI

![image-20240925181207045](https://yunmiao-bucket.oss-cn-beijing.aliyuncs.com/markdown/image-20240925181207045.png)

![image-20240925181421528](https://yunmiao-bucket.oss-cn-beijing.aliyuncs.com/markdown/image-20240925181421528.png)

**注意：**

![image-20240925181534096](https://yunmiao-bucket.oss-cn-beijing.aliyuncs.com/markdown/image-20240925181534096.png)

## 3. 使用

配置系统代理，vi /etc/profile

```sh
vi /etc/profile

export http_proxy=http://127.0.0.1:7890
export ftp_proxy=http://127.0.0.1:7890
export ALL_PROXY=socks5://127.0.0.1:7891

source /etc/profile
```

验证：访问成功即代表部署成功

```sh
[root@VM-8-14-centos clash]# curl www.google.com
```

















