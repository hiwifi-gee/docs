
# 插件系统组件

## 定时调用
在系统中一共有两种方式来定时执行：


### 定期执行命令：crontab
具体的命令格式：
增加
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