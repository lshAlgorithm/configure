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
