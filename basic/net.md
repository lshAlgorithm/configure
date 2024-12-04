1. Explaining `route -n`
    ```
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
    0.0.0.0         10.88.64.1      0.0.0.0         UG    20600  0        0 wlp0s20f3
    10.88.64.0      0.0.0.0         255.255.224.0   U     600    0        0 wlp0s20f3
    172.17.0.0      0.0.0.0         255.255.0.0     U     0      0        0 docker0
    192.168.124.0   0.0.0.0         255.255.255.0   U     0      0        0 virbr0
    ```
    * Iface(Interface接口名称)
        * `wlp0s20f3` is the route you connect. 一个典型的无线局域网接口名称，表示这是物理机器上的无线网络适配器。
        * `docker0` is, you guess, for docker
        * `virbr0` is virtualized internet
    * Why Gateway is `0.0.0.0`, and Destination has `0.0.0.0`?
        * `0.0.0.0         10.88.64.1      0.0.0.0`: 这条记录表明所有发往 0.0.0.0（实际上是除了其他特定目的地址之外的所有地址）的数据包都将通过 `10.88.64.1` 这个网关进行转发，而这个网关就是你的**默认网关**。通过网关，你才可以连接到互联网。
        * `172.17.0.0      0.0.0.0         255.255.0.0`: 0.0.0.0 在这里只是用来标识默认路由的一个占位符。当一个数据包的目的地不在任何已知的子网内时，系统会使用**默认网关**来决定下一步如何处理该数据包。
    * 子网掩码：区分IP地址中的网络部分和主机部分。它帮助网络设备确定哪些IP地址属于同一个子网，从而影响数据包的路由决策。
        * 子网掩码通过一系列的二进制位来定义这两部分的边界。网络部分用于标识网络ID，而主机部分用于标识网络上的特定设备。这涉及到对目标IP地址和子网掩码进行按位与操作（AND operation），以确定目标地址所属的网络。
        * 例如，一个常见的C类网络地址可能是 192.168.1.0，其默认的子网掩码是 255.255.255.0。这个掩码表示前24位是网络部分，后8位是主机部分。因此，所有IP地址在 192.168.1.1 到 192.168.1.254 范围内的设备都属于同一个子网。
2. Find the connection mode in virtual machine: `sudo nmcli connection show`
3. Linux终端配置proxy: `export http_proxy=http://<代理地址>:<代理端口> export https_proxy=https://<代理地址>:<代理端口>`
    * 若要删除，则可`unset http_proxy`, `unset https_proxy`
4. 为什么terminal无法ping google？ping走ICMP协议，防火墙一般允许的是HTTP流量，协议不同，无法代理。
    * 可以采用TUN
    * 在网络代理中，TUN（Tap/Universe Network Virtual Interface）模式是一种虚拟网络接口技术，主要用于在两个网络之间建立隧道，实现不同网络之间的数据传输。TUN 模式通常用于三层（网络层）的数据包转发，类似于路由器的功能，可以对 IP 数据包进行封装和解封装，从而实现在不同网络之间的路由。在 TUN 模式下，代理软件（如 Shadowsocks、V2Ray、WireGuard 等）会在操作系统中创建一个虚拟的 TUN 设备。这个设备在系统看来就像一个真实的网络适配器，可以接收和发送 IP 数据包。当数据包从本地网络发送到 TUN 设备时，代理软件会对其进行加密和封装，然后通过互联网发送到远程服务器。在远程服务器上，代理软件会解封装和解密数据包，然后将其转发到目标网络。反之亦然，从目标网络发回的数据包也会经过相同的流程。与 TAP（Tap Ethernet Virtual Interface）模式相比，TUN 模式工作在网络层，可以处理不同类型的网络协议（如 IPv4、IPv6 等），并且不会涉及链路层（如 MAC 地址）。因此，TUN 模式适用于需要跨网络进行数据传输的场景，例如，建立一个安全的远程访问通道，或者绕过网络限制访问特定服务。总之，TUN 模式是一种虚拟网络接口技术，用于在不同网络之间建立隧道，实现三层数据包的转发和路由。它常用于代理软件中，以提供安全的网络通信和远程访问功能。

# SSH
## concepts
* 认证阶段：当你尝试连接到一个远程服务器时，你的SSH客户端会使用你的私钥（如id_rsa或id_ed25519）来生成一个签名。这个签名会被发送到服务器进行验证。
* 密钥交换：一旦身份验证成功，SSH会执行密钥交换过程，以创建一个临时的、对称的会话密钥，用于加密后续的通信。这一过程确保即使有人截获了你的网络流量，也无法读取你的数据。
* 数据传输：所有后续的数据传输都会使用这个会话密钥进行加密，保证了数据的安全性和完整性。

## check if sshd is running
1. 查看端口状态： `sudo systemctl status sshd`
2. start the service: `sudo systemctl start sshd`
3. Or enable it every time it boost : `sudo systemctl enable sshd`
4. Otherwise, check your `firewalld`

## check your username
## Then follow [this](https://github.com/lshAlgorithm/SHU-Computer-Architecture-Experiments/blob/main/docs/Exp03-Tutor.md#42-ssh-key-generation)
### Notice
1. if you are on a server, then use thess two steps to set the ssh-agent.
    ```
    eval $(ssh-agent -s)
    ssh-add /path/to/your/id_rsa
    ```
