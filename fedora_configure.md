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

# VS code
* [Download vscode](https://code.visualstudio.com/docs/setup/linux)
```powershell
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf check-update
sudo dnf install code # or code-insiders
```
* have g++ gdb etc.
```powershell
sudo dnf gcc-c++ cmake gdb
```
* Fonts
   - [JetBrain Mono](https://www.jetbrains.com/lp/mono/#how-to-install)
   - unzip the zip
   - `sudo mv ./JetBrainsMono-2.304/* /usr/share/fonts`
   - restart IDE
   - modify the font size and allow font ligatures in json
* code-snippets
  - Preference -> Configure user snippets -> Global
  - did as comments say
  

# Docker
download and refer to [it](https://docs.docker.com/engine/install/fedora/)
more it on `./docker_basic.md`

# Anaconda
[Details](https://docs.anaconda.com/free/miniconda/#quick-command-line-install)
```powershell
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm -rf ~/miniconda3/miniconda.sh

~/miniconda3/bin/conda init bash
~/miniconda3/bin/conda init zsh
```

Add the conda to path
```powershell
# get the path of miniconda3/bin
# this time is: /home/brianlee/miniconda3/bin
vim ~/.bashrc 
export PATH = "/home/brianlee/miniconda3/bin:$PATH" # add it to the end of the file
source ~/.bashrc 
```

## About mirror
[Details](https://mirrors.tuna.tsinghua.edu.cn/help/anaconda/)
Add mirror
```powershell
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/menpo/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/bioconda/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/msys2/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
```

Delete mirror
```powershell
conda config --remove channels 'https://github.com/mstamy2/PyPDF2/'
```

# CUDA
* check the version of your cuda using `nvidia-smi`
* install through the command in pytorch official website, **match the cuda version**

# Extension
* hide the top-bar: [gnome extension](https://extensions.gnome.org/extension/545/hide-top-bar/)
* LibreOffice: `sudo dnf install LibreOffice`, to have ps-like, word-like, excel-like software
* Stacer: `sudo dnf install stacer`, to have monitor on your device


