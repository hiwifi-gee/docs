# 交叉编译

如何像gcc一样在本地编译路由器可以运行的程序？

## 原理
* 编写一个脚本 - cross-compile.sh，利用OpenWrt的交叉编译器，将系统的gcc, g++, ld等命令“替换”成交叉编译的相应命令。实际上并没有真正替换，而是在指定目录下创建gcc, g++, ld等软链接，指向OpenWrt下对应的的mipsel-openwrt-linux-gcc, ... 等命令，再将该目录加到PATH的最前面。这样一来，执行gcc调用的就是交叉编译器的gcc。这样一来，调试路由器程序时会很方便，不必按照package编译。
* 为了支持通过执行“make”直接编译内核模块，脚本中 export 了环境变量 KERNELPATH ，指向OpenWrt的内核代码根目录；同时“替换”了 uname 命令，使内核的编译脚本认为当前系统（uname -m）是 mips 平台。

## 交叉编译环境使用方法
* cross-compile.sh脚本位于platform的OpenWrt源码的scripts目录下；
* 假设本地已有编译完成的OpenWrt源码（或toolchain根目录），位于 ./hc5761/ ，则执行
```bash
./hc5761/scripts/cross-compile.sh ./hc5761
```
* 为路由器编译程序
```bash
cd <GNU make项目目录>
make
```
* 确认生成的是路由器CPU的目标程序
```bash
file <target_binaries>    # 【确认生成的是路由器CPU上的程序】
```

## 两种交叉编译方法
* 基于 GNU configure 的项目
  * 下载/解压被编译的代码，进入到代码目录下；
  * 执行：
```bash
cross-compile.sh <openwrt_root> -n
```
  进入到添加PATH变量目录的子shell中，可直接执行 xxxx-openwrt-linux-gcc ；
  * 执行 ./configure ，选项: --host=xxxx-openwrt-linux ，例如：
```bash
./configure --host=mips-openwrt-linux
```
  * 执行:
```bash
make
```
* 基于 GNU make 的项目
  * 执行：
```bash
cross-compile.sh <openwrt_root>
```
  进入到边加PATH变量目录的子shell中，直接执行 gcc 调用的是交叉编译器的 gcc ；
  * 进入到Makefile项目的代码目录下，执行：
```bash
make
```

## 使用举例
1. 编译GNU软件包：
```bash
hiwifi@precise-vmx:~$ ls
cross-compile.sh  hc5761  revinetd-1.0.2.tar.gz
hiwifi@precise-vmx:~$ ./hc5761/scripts/cross-compile.sh ./hc5761 -n
[cross-compile@hc5761:~]$
[cross-compile@hc5761:~]$ tar -zxvf revinetd-1.0.2.tar.gz
revinetd-1.0.2/
revinetd-1.0.2/TODO
...
[cross-compile@hc5761:~]$ cd revinetd-1.0.2/
[cross-compile@hc5761:~/revinetd-1.0.2]$ ./configure --host=mipsel-openwrt-linux
configure: WARNING: If you wanted to set the --build type, don't use --host.
    If a cross compiler is detected then cross compile mode will be used.
checking for mipsel-openwrt-linux-gcc... mipsel-openwrt-linux-gcc
checking for C compiler default output file name... a.out
...
config.status: creating config.h
config.status: config.h is unchanged
[cross-compile@hc5761:~/revinetd-1.0.2]$
[cross-compile@hc5761:~/revinetd-1.0.2]$ make
mipsel-openwrt-linux-gcc -Wall -g -O2  -DHAVE_CONFIG_H   -c -o getopt.o getopt.c
mipsel-openwrt-linux-gcc -Wall -g -O2  -DHAVE_CONFIG_H   -c -o revinetd.o revinetd.c
mipsel-openwrt-linux-gcc -Wall -g -O2  -DHAVE_CONFIG_H   -c -o misc.o misc.c
mipsel-openwrt-linux-gcc -Wall -g -O2  -DHAVE_CONFIG_H   -c -o proxy.o proxy.c
mipsel-openwrt-linux-gcc -Wall -g -O2  -DHAVE_CONFIG_H   -c -o server.o server.c
mipsel-openwrt-linux-gcc -Wall -g -O2  -DHAVE_CONFIG_H   -c -o relay_agt.o relay_agt.c
mipsel-openwrt-linux-gcc -o revinetd getopt.o revinetd.o misc.o proxy.o server.o relay_agt.o
[cross-compile@hc5761:~/revinetd-1.0.2]$
[cross-compile@hc5761:~/revinetd-1.0.2]$ file revinetd         # 【确认编译出的目标代码为mipsel平台】
revinetd: ELF 32-bit LSB executable, MIPS, MIPS32 rel2 version 1, dynamically linked (uses shared libs), with unknown capability 0xf41 = 0x756e6700, with unknown capability 0x70100 = 0x3040000, not stripped
[cross-compile@hc5761:~/revinetd-1.0.2]$
```

2. 快速编译：
```
justin@precise-vmx:~/app/hae-runtime/src$ cross-compile.sh /home/justin/hc6361/platform make install
rm -f *.o haerpc haerpd appctl
gcc -Wall -c -o haerpc.o haerpc.c
gcc -o haerpc haerpc.o
gcc -Wall -c -o haerpd.o haerpd.c
gcc -o haerpd haerpd.o
gcc -Wall -c -o appctl.o appctl.c
gcc -o appctl appctl.o
`haerpd' -> `../base-files/tmp/hae.elfs/ar71xx/haerpd'
`haerpc' -> `../base-files/tmp/hae.elfs/ar71xx/haerpc'
`appctl' -> `../base-files/tmp/hae.elfs/ar71xx/appctl'
justin@precise-vmx:~/app/hae-runtime/src$
```