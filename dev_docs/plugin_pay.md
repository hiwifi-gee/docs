

## 插件收费流程

### 插件收费的两种模式

#### 一、插件付费后安装

    目前平台主要是这种付费方式，只有付费了才可安装，插件安装完成后所有功能开放。（此方式不需要在插件中做请求接口判断服务状态，只有购买的才可安装）\\

#### 二、插件功能收费（安装后付费购买）

    安装完成后，可以通过接口请求判断是否已经购买且在有效期内，来判断是否提供高级功能，接口详情如下：\\
    
    接口url:https://app.hiwifi.com/cloud.php?m=service&a=GetServiceStatus 

    method：post 

    参数:mac、token、sid

    mac：路由器mac地址
    token的两种获取方式：
    lua：
```lua
local auth = require("auth")
local token = auth.get_token("xxxx")// xxxx插件英文名
```

    shell：
```bash
token=$(lua -e '
    local auth = require("auth")
    local token = auth.get_token("xxxx")// 插件英文名
    print(token)
    ')
echo $token
```

    sid：在open平台的插件详情中的APPKEY
    
    返回值：
```javascript
{
    "status":200,
    "info":{
        "code":1,
        "expire_time":"1453176190"
    }
}
```
```javascript
{
    status：200、通信成功。其他为失败，如：{"status":414,"info":"token_invalid"}为token验证失败
    code:付费状态1、正常购买，在合法使用期内。2、试用期内。
    expire_time：过期时间。
}
```

### 插件收费的流程

#### 一、邮件告知需求

    目前所有付费插件都需要云平台手动设置，包括收费方式和定价。所以有需要付费的需求，请联系极路由商务([[Image(QDE3JQKIBZ1ONYU7M0D1R70.png)]]), 详细填写下面a内容\\

    插件名称：xxxx\\
    插件功能：xxxxxxxx\\
    开发者姓名：xxx（真实姓名）\\
    开发者电话：131xxxxxxxx\\
    开发者邮箱：xxx@xxx.xxx\\
    选择的付费方式：付费后安装/插件功能收费\\
    预期定价：月、季度、半年、一年\\
    针对用户群：

#### 二、运营沟通细节

    发送完邮件后，会有运营人员沟通细节，所以请务必正确填写联系方式\\

#### 三、插件功能测试

    这一步通常会把插件发放给一部分测试用户进行测试，没问题了才能发放到普通用户\\

#### 四、管理员设置定价

    设置价格和购买方式，发放到普通用户\\

#### 五、定期沟通收益情况

    一般会通过邮件沟通，有需要情况会人工沟通\\
    
