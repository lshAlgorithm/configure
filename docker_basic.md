# Fedora docker download
```powershell
docker pull fedora # 从docker hub拉取fedora镜像
docker container run -it -v /Users/xxxx/yourFilePath:/csapp --name=csapp_env fedora /bin/bash # /Users/xxxx/yourFilePath 请替换成你自己想要进行同步的目录 :/csapp 替换成你自己想要命名的目录

# ----------automatically get into the docker---------------
vi /etc/resolv.conf #

nameserver 8.8.8.8 # 更改为您想要使用的DNS服务器的IP地址, 此为谷歌公共dns服务器ip
# 如果对隐私保护比较关注，或者需要更高性能和可靠性的 DNS 解析服务，可以考虑选择其他的公共 DNS 服务器，例如 Cloudflare 的 1.1.1.1 或 OpenDNS 的 208.67.222.222 和 208.67.220.220。
# -- from chatgpt
:wq

ping google.com # get access to internet
```
