
# 商业路由的接口文档

## 概述
本接口文档仅提供商业路由用户使用，此类用户区别于普通用户和开发者。他们购买了大量的极路由（一般至少超过了100台），为了方便这批用户远程管理他们的路由器，满足他们对路由器的远程批量管理的需求。申请商业路由的[方式](https://app.hiwifi.com/shop.php?m=vipuser&a=select)
文档提供了对所属路由器插件安装/卸载、设定固件手动/自动升级、强制固件升级、远程执行openapi的接口。


## 接口

### 获取key和company_name
获取key和company_name，key和company_name会在下面的接口中用到

链接地址 ： 
> http://business.hiwifi.com/business.php?m=code&a=info

返回结果：

| 属性	| 属性值 |
|:-------------| -------------:|
| company_name	| u138275633 | 
| key	 | df34fa86300276e05ca722f984ab5300 |




### 插件安装/卸载接口

+ 接口请求构造


属性  | 属性值 
------- | -------
接口URL |  https://app.hiwifi.com/vip.php?m=api&a=Operation
提交Method | POST

提交参数 | 参数说明
--- | ------
macs  | 设备mac列表，以英文,拼接，最多200个，如：D4EE070xxx,D4EE070xxx,D4EE070xxx
sid  |要进行操作的插件id
operation | 1/0；1：安装；0：卸载；默认是1
token | 校验串，过期时间为20s；生成规则$token = $company_name . '\|' . md5($company_name . $key . $time) . '\|' . $time;  $time为当前时间戳

+ 接口返回结果
 
参数 | 参数说明
---- | ------
stauts | = 0说明，接口请求正常，非0的时候，请求失败，具体信息看msg字段
msg | 如果出错的话，返回对应的报错信息

> 返回正确结果示例

```javascript
{
    'status': 0,
    'msg': ""
}
```

> 返回错误结果示例

```javascript
{
    'status': 1,
    'msg': "token is empty"
}
```



### 固件自动/手动升级设置接口

+ 接口请求构造

属性  | 属性值 
------- | -------
接口URL |  https://app.hiwifi.com/vip.php?m=api&a=SetUpgrade
提交Method | POST

提交参数 | 参数说明
--- | ------
macs  | 设备mac列表，以英文,拼接，最多200个，如：D4EE070xxx,D4EE070xxx,D4EE070xxx
is_auto | 1/0; 1:自动升级；0：手动。自动升级的时候，默认是凌晨4点，也可以通过hour参数设定哪个小时自动升级
hour | 0 ~ 23；升级小时。本参数仅在设定为自动升级的时候有效
token | 校验串，过期时间为20s；生成规则$token = $company_name . '\|' . md5($company_name . $key . $time) . '\|' . $time;  $time为当前时间戳

+ 接口返回结果

参数 | 参数说明
---- | ------
stauts | = 0说明，接口请求正常，非0的时候，请求失败，具体信息看msg字段
msg | 如果出错的话，返回对应的报错信息
data | 返回的数据，一般是json数组

> 返回正确结果示例

```javascript
{
    'status': 0,
    'msg': ""
}
```

> 返回错误结果示例

```javascript
{
    'status': 1,
    'msg': "token is empty"
}
```


### 获取可以升级到的version列表接口

+ 接口请求构造

属性  | 属性值 
------- | -------
接口URL |   https://app.hiwifi.com/vip.php?m=api&a=GetUpgrateVersion
提交Method | POST

提交参数 | 参数说明
--- | ------
macs | 设备mac列表，以英文,拼接，最多200个，如：D4EE070xxx,D4EE070xxx,D4EE070xxx
token | 校验串，过期时间为20s；生成规则$token = $company_name . '\|' . md5($company_name . $key . $time) . '\|' . $time;  $time为当前时间戳

+ 接口返回结果

参数 | 参数说明
---- | ------
stauts | = 0说明，接口请求正常，非0的时候，请求失败，具体信息看msg字段
msg | 如果出错的话，返回对应的报错信息
data | 返回的数据，一般是json数组

> 返回正确结果示例

```javascript
{
    'status': 0,
    'msg': "",
    'data': {对应的数据}
}
```

> 返回错误结果示例

```javascript
{
    'status': 1,
    'msg': "token is empty"
}
```

### 强制升级rom接口

+ 接口请求构造

属性  | 属性值 
------- | -------
接口URL |  https://app.hiwifi.com/vip.php?m=api&a=ForceUpgrate
提交Method | POST

提交参数 | 参数说明
--- | ------
macs  | 设备mac列表，以英文,拼接，最多200个，如：D4EE070xxx,D4EE070xxx,D4EE070xxx
token | 校验串，过期时间为20s；生成规则$token = $company_name . '\|' . md5($company_name . $key . $time) . '\|' . $time;  $time为当前时间戳

+ 接口返回结果

参数 | 参数说明
---- | ------
stauts | = 0 说明，接口请求正常，非0的时候，请求失败，具体信息看msg字段
msg | 如果出错的话，返回对应的报错信息


> 返回正确结果示例

```javascript
{
    'status': 0,
    'msg': ""
}
```

> 返回错误结果示例

```javascript
{
    'status': 1,
    'msg': "token is empty"
}
```


### 执行openapi的相关接口

+ 接口请求构造

属性  | 属性值 
------- | -------
接口URL |  https://app.hiwifi.com/vip.php?m=api&a=CallRouter
提交Method | POST

提交参数 | 参数说明
--- | ------
mac  | 设备mac，只支持单个mac修改。如：D4EE070xxx
token | 校验串，过期时间为20s；生成规则$token = $company_name . '\|' . md5($company_name . $key . $time) . '\|' . $time;  $time为当前时间戳
method | string， openai的method参数，比如：network.wireless.set_channel 
params | json字符串， openapi的参数，对应上面的例子，{"device":"radio0.network1", "channel":13}

具体都有哪些method可以调用，请参见：[OpenAPI文档](docs/openapi#title_17) 最下面的openapi接口文档，每个方法对应的参数，就是params的要求

+ 接口返回结果

参数 | 参数说明
---- | ------
stauts | = 0说明，接口请求正常，非0的时候，请求失败，具体信息看msg字段
msg | 如果出错的话，返回对应的报错信息
data | 返回的数据，一般是json数组

> 返回正确结果示例

```javascript
{
    'status': 0,
    'msg': "",
    'data': {对应的数据}
}
```

> 返回错误结果示例

```javascript
{
    'status': 1,
    'msg': "token is empty"
}
```



