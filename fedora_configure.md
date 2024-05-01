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
