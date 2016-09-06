
# 插件安装和配置

## 插件安装的原理
插件的入口文件是script，里面定义的各个函数就是各个动作
比如安装插件就是执行 . script && install

插件管理器安装插件的实际动作是：
```bash
tar xzf PLUGIN.tgz > DEBUG_FILE 2>&1
. script && install > DEBUG_FILE 2>&1

cp script	/etc/market/PLUGIN_NAME.script
cp app.json	/etc/market/PLUGIN_NAME.info
``` 
其中 插件tgz包被解压到临时目录, 输出被重定向到 DEBUG_FILE: /tmp/plugin/debug

所以script这个文件必须包含两个函数 install和uninstall。install就是安装，uninstall就是卸载。
在函数中返回0，说明成功，非0，说明不成功。这个和Linux/Unix错误标准一致。

## script脚本的函数说明

### install/uninstall
install和uninstall两个互逆函数。
一定要保证在install函数中做的操作，在uninstall函数中都会被撤销掉。

#### 如果安装过程中出现错误，如何提示给用户？
如果在install和uninstall中出现错误，可以echo以<User-Echo>开头的字符串，服务端会提示给用户。
具体的格式如下：
```bash
install()
{
    echo "<User-Echo>返回给用户看"
    return 1
}
```

### start/stop/status
start和stop也是一个互逆函数。
如果插件要实现显示运行状态的功能，需要在script中实现status函数，并且在manifest.json中设定：
```javascript
{
    "supportgetappstatus": 1
}
````
status函数返回的字符串**必须是json**。
可以识别的格式如下：
```javascript
{
    'status': ‘running|stopped’,
    'msg': '是可选属性，可以是文本或者html，只要保证这个是合法的json即可'
}
```


### configure/reconfigure

除了可以执行之外，插件还可以接收配置参数。

#### 配置参数类型
增加配置参数，是在manifest.json中定义的
参数支持的类型类似于html，有text/txtfile/radio/selection/checkbox/password

```javascript
{
    "manifest_version": "2.0.0",
    "requirements": {
        "support_refconfig":1
    },
    "configuration": [
        {
            "name": "单行文本",
            "type": "text",
            "variable": "DTEXT",
            "defaultvalue": "这是默认值",
            "required": 1,
            "description": "这是描述",
            "regexpression": ""
        },
        {
            "name": "多行文本",
            "type": "txtfile",
            "variable": "MORE",
            "defaultvalue": "1;2;3;4;",
            "required": "",
            "description": ""
        },
        {
            "name": "单选框",
            "type": "radio",
            "variable": "RADIO",
            "choices": "是=1;否=0",
            "defaultvalue": 1,
            "required": 1,
            "description": "这是描述"
        },
        {
            "name": "下拉菜单",
            "type": "selection",
            "variable": "SELECT",
            "choices": "a=1;b=2;c=3",
            "defaultvalue": "2",
            "required": "",
            "description": ""
        },
        {
            "name": "多选框",
            "type": "checkbox",
            "variable": "CHECKBOX",
            "choices": "a=a;b=2;v=3",
            "defaultvalue": "3",
            "required": "",
            "description": "这是描述"
        },
        {
            "name": "密码",
            "type": "password",
            "variable": "PASSWORD",
            "defaultvalue": "",
            "required": 1,
            "description": ""
        }
    ]
}
```