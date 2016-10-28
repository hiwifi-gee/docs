
# 插件系统组件

## 定时调用
在系统中一共有两种方式来定时执行：


### 定期执行命令：crontab
具体的命令格式：[请参阅](https://wiki.openwrt.org/doc/howto/cron)

因为没有办法用crontab -e 编辑crontab列表


### 延时执行某个命令：hwf-at
具体的命令格式：
hwf-at  second "command"
```bash
## 举个例子，5s之后重新reload nginx
hwf-at 5 "/etc/init.d/nginx reload"
```


## kproxy

## nginx

## lua

## openapi

## openvpn