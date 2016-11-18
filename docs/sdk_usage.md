
# SDK



## SDK 下载地址

| 型号 | 下载地址 |
| ------ | ------|
| HC5661 | [http://hiwifi-sdk.oss.aliyuncs.com/HC5661-ralink-sdk.tar.bz2](http://hiwifi-sdk.oss.aliyuncs.com/HC5661-ralink-sdk.tar.bz2) | 
| HC5661A | [http://hiwifi-sdk.oss.aliyuncs.com/HC5661s-mediatek-sdk.tar.bz2](http://hiwifi-sdk.oss.aliyuncs.com/HC5661s-mediatek-sdk.tar.bz2) |
| HC5761 | [http://hiwifi-sdk.oss.aliyuncs.com/HC5761-ralink-sdk.tar.bz2](http://hiwifi-sdk.oss.aliyuncs.com/HC5761-ralink-sdk.tar.bz2) |
| HC5761A | [http://hiwifi-sdk.oss.aliyuncs.com/HC5761s-mediatek-sdk.tar.bz2](http://hiwifi-sdk.oss.aliyuncs.com/HC5761s-mediatek-sdk.tar.bz2) |
| HC5861 | [http://hiwifi-sdk.oss.aliyuncs.com/HC5861-ralink-sdk.tar.bz2](http://hiwifi-sdk.oss.aliyuncs.com/HC5861-ralink-sdk.tar.bz2) |
| HC5962 | [http://hiwifi-sdk.oss-cn-hangzhou.aliyuncs.com/HC5962-mtk-sdk.tar.bz2](http://hiwifi-sdk.oss-cn-hangzhou.aliyuncs.com/HC5962-mtk-sdk.tar.bz2) |

链接如果过期，不能下载，请大家及时报告:sdk#hiwifi.tw


## 使用方法

* 安装Ubuntu 12.04，根据提供的SDK选择32位或64位系统;
* 配置开发环境：
```bash
apt-get install subversion git build-essential libncurses5-dev zlib1g-dev gawk unzip gettext libssl-dev intltool openjdk-6-jre-headless optipng
ln -sf bash /bin/sh
```
* 设定你当前的目录为： /home/hiwifi
* 将HC5761 sdk压缩包解压到hiwifi的中, 即代码目录位于/home/hiwifi/hc5761 ; 


## 程序编译方法

### 方法一：以package方式编译C代码
* 按照OpenWrt格式将代码目录放到hc5761/package下面;
* 在hc5761/目录下执行make menuconfig , 选中添加的package（M）, 保存退出;
* 执行: 
```bash
make package/<package目录名>/compile V=s
```

### 方法二：使用OpenWrt工具链中的编译器直接交叉编译程序
 工具包中提供了名为cross-compile.sh的脚本, 在hc5761/主目录下执行:
```bash
./scripts/cross-compile.sh ./
```
 之后, 该shell环境中的gcc, g++, ld等命令即引用到交叉编译工具的相应命令。详细使用方法请参考[交叉编译环境建立方法](./cross_compile)，或SDK工具包中的cross-compile.docx。

## 添加feeds中的软件包的方法
* 以增加 libffmpeg 为例：
```bash
./scripts/feeds update
./scripts/feeds install ffmpeg
```
* 然后执行：
```bash
make menuconfig
```
* 在 Libraries 里把libffmpeg-xxxx 选中（M）,再执行：
```bash
make package/ffmpeg/compile
make package/ffmpeg/install
```


