要在 Fedora 中挂载 Windows 分区，你需要遵循以下步骤。这里假设你的 Windows 分区使用的是 NTFS 文件系统，这是 Windows 最常用的文件系统类型。
步骤 1：确定 Windows 分区

首先，你需要找到 Windows 分区的设备名称。你可以使用 lsblk 或 fdisk -l 命令来查看所有可用的磁盘和分区。
```
sudo lsblk -f
```
查找 NTFS 分区，通常会看到类似 /dev/sda1 或 /dev/nvme0n1p1 的设备名。
步骤 2：创建挂载点
接下来，你需要在 Fedora 中创建一个目录作为挂载点。你可以选择任何你想要的位置，但通常选择 /mnt/windows 这样的位置比较合适。
```
sudo mkdir /mnt/windows
```
步骤 3：安装 NTFS-3G
Fedora 默认可能不包含 NTFS 支持，因此你需要安装 ntfs-3g 软件包，它提供了读写 NTFS 文件系统的能力。
```
sudo dnf install ntfs-3g
```
步骤 4：挂载 Windows 分区

现在你可以使用 mount 命令来挂载 Windows 分区。将下面命令中的 /dev/sda1 替换为你在第一步中找到的实际设备名。
```
sudo mount -t ntfs-3g /dev/sda1 /mnt/windows
```
步骤 5：测试挂载

进入挂载点目录，看看是否能看到 Windows 分区中的文件和目录。

cd /mnt/windows
ls

步骤 6：自动挂载（可选）

如果你想每次启动 Fedora 时自动挂载 Windows 分区，可以编辑 /etc/fstab 文件。
```
sudo nano /etc/fstab
```
在文件末尾添加如下行，记得将 /dev/sda1 和 /mnt/windows 替换为你的实际设备名和挂载点路径。
```
/dev/sda1 /mnt/windows ntfs-3g defaults,_netdev 0 0
```
保存并退出编辑器。这样设置后，每次系统启动时，Windows 分区就会自动挂载到指定目录。
注意事项

    确保在挂载分区之前，Windows 分区没有被其他系统使用，否则可能会导致数据损坏。
    在修改 /etc/fstab 时要格外小心，确保信息输入准确无误，以免造成不必要的问题。
    如果你经常需要在 Linux 和 Windows 之间共享文件，考虑使用如 Samba 这样的服务，这样可以从 Linux 系统访问 Windows 共享文件夹，反之亦然。

