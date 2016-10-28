
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


### 配置参数

除了可以执行之外，插件还可以接收配置参数。

#### 配置参数类型
增加配置参数，是在manifest.json中定义的
参数支持的类型类似于html，有text/txtfile/radio/selection/checkbox/password
下面是各种定义的示例，同时还支持一些属性：

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

除了类型之外，还有其他的几个属性可以设置，这里分别说明一下：
```javascript
"name": "单行文本",   //  左侧的说明文字
"type": "text",      //  类型, text:单行文本框；txtfile：多行文本；selection：下拉框；radio：单选框；checkbox：多选框；
"variable": "DTEXT", //  保存变量的变量名， **注意：不要有下划线 _**
"defaultvalue": "这是默认值",  // 可以设定默认值 
"required": 1,       //  (1：必填；0：选填)是否是必须的，如果是必须的，但是用户没有填，就不会完成配置这个流程。 
"description": "这是描述",  //  右侧的详细描述，可以提醒用户关于这个输入的注意事项或者规则
"regexpression": ""  //  输入满足的正则表达式，这个正则表达式是PCRE兼容的才可以。正则匹配用户所填数据("/^正则$/")，或使用is_ip(是否是ip)、is_port(是否是端口号)
"choices": "a=1;b=2;c=3"  //这个对于select/radio/checkbox有效，规则类似：name=value;name1=value1
```
#### 如何读取配置
配置文件会在配置完成之后，以独立文件下发，如果插件名字叫demo_test，在当时插件的临时目录会有一个demo_test.conf的文件。 直接 . demo_test.conf就可以使用变量了。
txtfile这个稍微有点特殊，由于可以存很多行，数据比较多，这个类型的参数值，会以独立的文件存在，比如上面的例子，就会有一个文件MORE，在当前目录下。直接cat MORE
这个文件就可以。

有一个具体的app_demos/yurenchen_test，里面有具体的代码可以供大家参考。

#### 需要配置插件需要注意的地方
* install函数中需要特殊处理配置文件不存在的情形，因为一些插件是允许先install然后再配置。如果配置是必要的话，就不建议在install函数中执行start函数。同时这种情况建议使用reconfigure。
* 在对参数值一般也要保存起来，方便插件在系统重启之后，或者插件重新启动之后可以正常运行

#### reconfigure
一般可以配置的插件需要修改的时候，但是如果每次都执行一次install函数的话，就太重了，需要把整个差价下载下来，同时执行install函数。
如果已经install过了，但是只是参数修改，那么reconfigure就非常方便。这种情况，服务器只会下发参数配置文件，插件包不会下发。
支持这个功能，一般要在manifest.json中声明一下：
```javascript
    "requirements": {
        "support_refconfig":1
    },
```

### 插件的安装位置
由于flash空间大小有线，对于一些大的插件，只能存放到外存中。插件可以定义插件是否依赖外存。
```javascript
//1:依赖外存 0: 不依赖外存
app_install_location ：1|0
```
如果没有设定这个选项，默认就是依赖外存的

