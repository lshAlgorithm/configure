# Use gnome boxes
1. as normal, do what UI says
2. connect by bridge
> boxes use NAT as default
[refer](https://blog.agchapman.com/configuring-gnome-boxes-vms-using-virt-manager/)
```powershell
dnf install virt-manager
```
Then, see the reference set forth

# Clone VM and ssh through hostname
CHECK if port22 is open using `sudo ss -tulpn | grep :22` first, or `sudo service sshd start`
> To form a group
1. clone the VM in UI
2. change the hostname
> To make the hostname different, therefore can `ssh` more directly
```powershell
hostname # check the original hostname
sudo hostnamectl set-hostname [new_name]
cd /etc/hosts
# convert [original] to [new_name]
```
> if you wanna change username
```powershell
su -
usermod -l [new_name] [old_name]
```
3. add DNS resolution
```powershell
cd /etc/hosts
[ip] [hostname] # e.g. 192.168.1.101 debian-1
```
4. Then you can `ssh [hostname]` to connect to `[username]@[hostname]`
5. [More] About firewall
   > mostly use firewalld or iptable
   >> command about `firewalld` [refer](https://www.jianshu.com/p/e0fdecfcee4b)

# Extend the volume
Problem discription: when `df`, get 
```powershell
Filesystem                  1K-blocks    Used Available Use% Mounted on
/dev/mapper/debian--vg-root   6930164 6635140         0 100% /
```
0. Some concepts: [refer](https://www.cnblogs.com/stragon/p/5806388.html)
1. gnome boxes add up the `storage limit`
2. check the block devices(storage devices like HDD included) with `lsblk`, then you can find out that there are something not in use
3. 将新分配的存储空间创建物理卷, [refer](https://blog.csdn.net/weixin_49042937/article/details/116231803)中第一部分，then you can check through `lsblk`
4. 利用vgextend命令将新的物理卷（/dev/[new_name]）加入到卷组中, [refer](https://www.cnblogs.com/stragon/p/5806388.html) in the ending part
