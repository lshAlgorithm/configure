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
>> `--privileged=true` matters

# Concepts
* After `docker run ubuntu` to run a image as a container, it stops and exits immediately: **A container only lives as long as the process inside it is alive.** 
  * You can use `docker run ubuntu sleep 5` to execute the command `sleep 5`
* `-d` run the container in the background
* `-t`(pseudo terminal) have the docker container's **t**erminal attached to the CLI you have
* `-i` **i**nteractive way, accept your input
* `-p` port mapping, map the port number of the host to the port number of docker.
  * e.g. `docker run -p 80:5000 kodekloud/webapp`, and user outside the host(who cannot use the port inside, i.e. 5000) can access the web application using `http://192.168.1.5:80`(IP + port number). Then, user can use port 80, which has been mapped to 5000
  * one port on host can only map to only container instance; while one container with the same port number(e.g. 5000) can be mapped by different ports in host.
* `-v` volume mapping, kind of shared directory
  * e.g. `docker run -v /my/path mysql`
* `docker inspect [container name]` show the details of the container
* `docker logs [container name]` view the log of container running before
* `docker run ubuntu:[version]` add a tag to the image

# Dockerfile
* Format: `[Instruction] [Argument]`
```Dockerfile
FROM Ubuntu # Every docker image must be based off of another image, the key is the based OS

RUN apt-get update # install dependency
RUN apt-get install python

RUN pip install flask
RUN pip install flask-mysql

COPY . /opt/source_code # copy source code

ENTRYPOINT FLASK_APP=/opt/source_code/app.py flask run  # specify a command that will be run 
```
> if entry looks like `ENTRYPOINT ["python", "app.py"]`, then after creating a container, `python app.py` is run **automatically**.
* build command: `docker build Dockerfile -t lsh/my_app`
* Layer architecture
  * Each layer only stores the **changes** from the previous layer
  * use docker history will show a bunch of containers, each is a layer, e.g. `docker history fba1999a2752`
  * Each layer is cached(saved), so you don't have to restart whether you fail or add new layers. Only the layers above the changes are needed to rebuild.
* Web app stuff
  * if you start a container using `docker run`, and a webapp begin to run, then you can access with `http://[ip]:[port]`.
  * if you are outside the host, then you need to map the port when `docker run`.
  * The container supply the web server, and if you quit it, you will get `502 bad gateway` in browser.
  * In web app code in python, `app.run(host = "0.0.0.0", port = 8080)` means: this starts the Flask development server. It listens on all network interfaces (host="0.0.0.0") and on port 8080. This means you can access the application from any device **on the same network** by visiting http://[your-server-ip]:8080
  * 
    ```python
    @app.route("/") # binds the following function to the URL route specified
    def main(): 
    ```
  *  An IP address identifies a host on the network, while a port number identifies a specific service or application running on that host.
  *  The transport layer (e.g., TCP or UDP) uses port numbers to distinguish between different conversations happening at the same time on the same host.
  * IMHO, **one** port in host can only map to **one** port in one container. You can create multiple containers so that one port in host can map to the seemingly same port number of actually different containers

***

Here's an explanation of each directory under the root (/) in a typical Unix-like system, such as Linux:

    bin: This directory contains essential binary executable files (commands) that can be used by all users. These commands are generally used for basic system management and file manipulation.

    boot: This directory contains files required for the boot process, such as the kernel image and initial RAM disk (initrd). These files are necessary for the system to boot and load the kernel.

    dev: This directory contains device files, which represent hardware devices connected to the system. These files allow processes to interact with hardware components like keyboards, mice, and storage devices.

    etc: This directory contains configuration files for various programs and services. These files typically contain settings and parameters that control how different applications and system services behave.

    home: This directory contains subdirectories for each user account on the system. Each user's subdirectory (e.g., /home/user1) contains their personal files and settings.

    lib and lib64: These directories contain shared library files, which are used by various programs and services. The libraries provide reusable code that can be linked by multiple applications. The lib64 directory specifically contains 64-bit libraries.

    media: This directory is used for mounting removable media, such as USB drives and CD/DVDs. Subdirectories are created dynamically when a new medium is inserted.

    mnt: This directory is used for manually mounting filesystems. It's not usually used by default, but it can be useful for temporary mounting points.

    opt: This directory is used for installing optional software packages that are not part of the core system. These packages are typically installed by the software vendor.

    proc: This directory contains information about running processes and system memory. It's a virtual filesystem that provides a way to access kernel data structures without reading files on disk.

    root: This directory contains the home directory for the root user, who has administrative privileges over the system.

    run: This directory contains runtime state information for services and applications. It's similar to /var/run, but it's intended to be cleared during system startup.

    sbin: This directory contains system administration binary executable files (commands) that are typically used by the root user or system administrators. These commands are often related to system management and maintenance.

    srv: This directory contains data for services provided by the system, such as web servers, FTP servers, and other network services.

    sys: This directory is a virtual filesystem that provides an interface to the kernel's device drivers and other system information.

    tmp: This directory contains temporary files and data that are not meant to persist across system reboots.

    usr: This directory contains user-related programs, libraries, and data. It's divided into subdirectories such as /usr/bin, /usr/lib, and /usr/share.

    var: This directory contains variable data, such as log files, spool files, and application data that changes during system operation. It's further divided into subdirectories like /var/log, /var/spool, and /var/cache.
