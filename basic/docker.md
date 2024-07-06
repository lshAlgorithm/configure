# Fedora docker download
```powershell
docker pull fedora # 从docker hub拉取fedora镜像
docker container run -it -v /Users/xxxx/yourFilePath:/csapp --name=csapp_env fedora /bin/bash # /Users/xxxx/yourFilePath 请替换成你自己想要进行同步的目录 :/csapp 替换成你自己想要命名的目录

# ----------automatically get into the docker---------------
```
* Connect to the network
> DONT USE NET ON CAMPUS
1. method1: if you have vi
```powershell
vi /etc/resolv.conf #

nameserver 8.8.8.8 # 更改为您想要使用的DNS服务器的IP地址, 此为谷歌公共dns服务器ip
# 如果对隐私保护比较关注，或者需要更高性能和可靠性的 DNS 解析服务，可以考虑选择其他的公共 DNS 服务器，例如 Cloudflare 的 1.1.1.1 或 OpenDNS 的 208.67.222.222 和 208.67.220.220。
# -- from chatgpt
:wq

ping google.com # get access to internet
```
2. method2: with sed (or echo)
```powershell
sed "1i nameserver 8.8.8.8" /etc/resolv.conf

#referred the follow
sed "15i avatar" Makefile.txt # add 'avatar' in the 15th line in Makefile.txt
```
* Basic operation outside container
```powershell
# ----------open the docker after exit------------------
docker ps -a # get the overview of the container already had
docker start container_id # type the id 启动容器
docker exec -it container_id /bin/bash # 执行容器

docker stop [container ID]

docker rm [container ID]
docker rmi [image ID] # use `docker images` to check the imageID
```
[reference](https://zhuanlan.zhihu.com/p/339047608)


## Basic operations
```powershell
echo  "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free" >/etc/apt/sources.list
echo  "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free" >>/etc/apt/sources.list
echo  "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free" >>/etc/apt/sources.list
echo  "deb http://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free" >>/etc/apt/sources.list    
```
then use apt-get
```powershell
apt-get update -y
apt-get install -y iputils-ping
```

## Common pros
1. Error response from daemon: pull access denied for your_username/your_repository
> docker login -u [your_username_in_hub]
2. Temporary failure resolving 'mirrors.tuna.tsinghua.edu.cn'
> `sudo vim /etc/docker/daemon.json`
> Add the following:
> ```powershell
> {
>  "registry-mirrors": ["https://mirrors.tuna.tsinghua.edu.cn"],
>  "dns":["114.114.114.114","8.8.8.8"],
>  "iptables": true
> }
> ```
> restart the service: `systemctl daemon-reload systemctl restart docker`
3. if the mounted folder get `Permission denied` in docker root
> run the docker like `docker run -i -t -v /soft:/soft --privileged=true 637fe9ea94f0 /bin/bash`
> `--privileged=true` matters
