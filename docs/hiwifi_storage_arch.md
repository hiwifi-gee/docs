hiwifi storage arch
=======

this doc for hiwifi plugin develop.

## 存储分类
### 按用途分类
- overlay // for conf
- crypt // for bin
- data // for data
- other usb // for general use

### 不同机型上的实际存储

HC5661
HC5761
HC5861

- crypt // mmcblk LUKS part
- data // mmcblk ext4 part

HC5961
HC5962
- crypt // nand flash, mtd:opt part

HC5961
- data // internal ssd

HC5962
- data // usb storage (兼职)

### 各存储的路径

- overlay
df -h
/overlay 是直接挂载点
/ 是 overlay 覆盖点
/ 目录下, 没有被 其他 挂载点覆盖 的路径, 都在 overlay 里.

- crypt
/tmp/cryptdata 需要判断是否为挂载点
df /tmp/cryptdata
如果不是挂载点, 那就是 tmpfs, 在内存中.

- data
df /tmp/data
如果不是挂载点, 那就是 tmpfs, 在内存中.

- other
/tmp/storage/xxx
普通存储都挂载在这里.
