# Mount
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

# Btrfs
**Btrfs** (B-tree 文件系统) 是一个现代文件系统，提供了许多高级功能，如快照 (snapshots)、子卷 (subvolumes)、压缩、以及自修复能力。备份和数据恢复是 Btrfs 的重要应用场景之一。以下是如何使用 Btrfs 完成备份以及在 `/home` 内容丢失时的找回方法。

### 1. **Btrfs 快照功能概述**
Btrfs 的快照是一个轻量级的备份机制。快照是一个只读或可写的子卷，它在创建时捕获文件系统的状态。创建快照非常快速且占用极少的空间，因为它仅记录文件的元数据和数据块的引用。

#### 快照的特点：
- **轻量级**：快照仅保存增量数据（差异），因此初始快照几乎不占用额外空间。
- **瞬时创建**：创建快照非常迅速，即使在大型文件系统上。
- **可写快照**：快照可以是只读的，也可以是可写的。可写快照允许你在快照上进行修改，而不会影响原始数据。

### 2. **如何使用 Btrfs 创建快照**

#### 创建快照
假设 `/home` 是一个 Btrfs 子卷，你可以通过以下步骤创建一个快照：

1. **创建快照**：
   - 使用 `btrfs` 工具创建一个快照，例如：
     ```bash
     sudo btrfs subvolume snapshot /home /path/to/snapshot
     ```
   - 这会在指定的路径（`/path/to/snapshot`）创建一个 `/home` 的快照。

2. **创建只读快照**：
   - 如果你希望创建一个只读快照，使用以下命令：
     ```bash
     sudo btrfs subvolume snapshot -r /home /path/to/snapshot
     ```

#### 管理快照
你可以通过以下命令查看系统中的所有子卷和快照：
```bash
sudo btrfs subvolume list /
```

### 3. **恢复 /home 的内容**
如果 `/home` 内容丢失或损坏，你可以使用快照进行恢复。

#### 恢复步骤：
1. **删除或重命名现有的 `/home` 子卷**：
   - 如果 `/home` 子卷已损坏，可以先将其重命名或删除：
     ```bash
     sudo mv /home /home_backup
     ```

2. **还原快照**：
   - 将之前创建的快照恢复为新的 `/home` 子卷：
     ```bash
     sudo btrfs subvolume snapshot /path/to/snapshot /home
     ```
   - 这将创建一个新的 `/home` 子卷，内容与快照时的 `/home` 相同。

3. **检查并修复权限**：
   - 确保恢复的文件权限正确，必要时可以使用 `chown` 和 `chmod` 命令修复权限。

#### 删除快照
当你不再需要快照时，可以删除它以释放空间：
```bash
sudo btrfs subvolume delete /path/to/snapshot
```

### 4. **定期备份与快照管理**
为了减少数据丢失的风险，建议定期创建快照，并将关键数据的快照备份到外部存储设备上。你可以设置自动化脚本或使用工具（如 `snapper`）定期管理和清理快照。

### 5. **总结**
Btrfs 的快照功能为数据备份和恢复提供了强大的支持。当 `/home` 内容丢失时，快照是最简单有效的恢复方式。通过定期创建快照和适当的管理，你可以在系统出现问题时迅速恢复重要数据。

# Git 
## Back to the history
1. `git log` to confirm the SHA of the version you want to go back to.
2. `git checkout -b [branchName] [SHA]`, create a new branch for this version.
3. `git branch -m [NewName]` change the name of the current branch
4. `git branch -d [branchName]` delete the branch that has been merged
5. `git push origin -d [branchName]` delete the branch in remote repo.