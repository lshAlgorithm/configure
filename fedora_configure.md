# Dual boost Fedora & Windows
0. 清空启动盘Windows
   ```powershell
   # enter cmd
   diskpart
   select disk <number>
   clean
   ```
2. 分盘+制作启动盘[详见](https://zhuanlan.zhihu.com/p/363640824)
3. Dual boot [details](https://www.youtube.com/watch?v=VaIgbTOvAd0)
4. [BtrFS](https://www.youtube.com/watch?v=DQ69xiHVYbU)

# Breakwa11
```powershell
sudo dnf copr enable zhullyb/v2rayA #add respository
sudo dnf install v2ray #add core
sudo dnf install v2raya #download v2rayA
# download complete! easy!
sudo systemctl start v2raya.service # start the v2ray
sudo systemctl enable v2raya.service # start it whenever boost
```

# Github
[Details](https://blog.csdn.net/AngelDg/article/details/106629442)
```powershell
# connect github to local
ssh-keygen -t rsa -C "lishuhuai_brian@163.com"
[Enter][Enter][Enter]
vim /Users/<your name>/.ssh/id_rsa.pub
# DO setting on github ssh
# ADD new ssh key
ssh -T git@github.com # visit to check
```

# Nvidia driver
[Details](https://zhuanlan.zhihu.com/p/627426276?utm_campaign=&utm_medium=social&utm_psn=1769327088858083328&utm_source=qq)
1. download newest .run [officially](https://www.nvidia.com/download/index.aspx)
     > original hp laptop is Geforce MX570
2. close graphical operations
   ```powershell
   init 3 # enter the non-graphical view
   systemctl get-default
   service graphical.target stop
   systemctl set-default multi-user.target
   ```
3. ban nouveau
   ```powershell
   # 在/etc/modprobe.d文件夹中新建nouveau-blacklist.conf文件，写入
   blacklist nouveau 
   options nouveau modeset=0

   #在/etc/default/grub文件的GRUB_CMDLINE_LINUX参数中添加：
   rd.driver.blacklist=nouveau

   grub2-mkconfig -o /boot/grub2/grub.cfg
   reboot
   ```
4. download driver
   ```powershell
   lsmod | grep nouveau    # 没有输出才是真禁用了
   dnf install binutils make gcc


   #涉及到kernel-headers和kernel-devel两个包的版本要与内核版本一致
   uname -r #查看内核版本
   yum info kernel-devel kernel-headers #查看kernel-headers和kernel-devel的版本
   dnf install xx # install what is not coincide
   
   cd <your-dictionary>
   sh NVIDIA-Linux-x86_64-xxx.xxx.xx.run

   systemctl set-default graphical.target
   nvidia-smi #check it!!!
   ```
