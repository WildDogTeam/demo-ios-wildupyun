## demo-IOS-WilddogImg  

基于野狗和又拍API开发的简单图片上传demo
  
  
###概述
本示例适用于IOS开发，基于野狗和又拍API 构建，其中上传功能基于又拍云云。开发者使用   
本示例可以方便的从IOS客户端上传图片至又拍云云存储， 并对上传成功后的图片的url等基  
础信息存入野狗实时数据库。  

![一个demo页面的快照](1.png =414x736)

### 加入又拍云
* 1 [注册](https://console.upyun.com)一个又拍云账号
* 2 下载又拍云SDK
* 3 参照又拍云的开发指南在自己的又拍云中控制中心做好一切准备，如创建空间等



### 具体步骤

* 1 导入又拍云SDK，并上传图片，主要代码如下:

  ``` 
     UpYun *uy = [[UpYun alloc] init];
    /**
     *	@brief	根据 UIImage 上传
     */
    NSString *imageName = [self getSaveKey];
    [uy uploadFile:self.imageView.image saveKey:imageName];`

    uy.successBlocker = ^(id data)
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"上传成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        successBlock([NSString stringWithFormat:@"%@/%@",UPYUN_IMG_DOMAIN, imageName]);

    };
    uy.failBlocker = ^(NSError * error)
    {
        NSString *message = [error.userInfo objectForKey:@"message"];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"error" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        failBlcok(error);
        
    };
  ```  

* 2 图片上传成功后返回图片的URL,将URL存入野狗云.



## 相关文档s

* [Wilddog 概览](https://z.wilddog.com/overview/guide)
* [IOS SDK快速入门](https://z.wilddog.com/ios/quickstart)
* [IOS SDK 开发向导](https://z.wilddog.com/ios/guide/1)
* [IOS SDK API](https://z.wilddog.com/ios/api)
* [下载页面](https://www.wilddog.com/download/)
* [Wilddog FAQ](https://z.wilddog.com/faq/qa)
* [又拍官方文档-开发指南](http://docs.upyun.com/guide/)
* [又拍官方文档-图片处理](http://docs.upyun.com/guide/#_9)

## License
[MIT](http://wilddog.mit-license.org/)

## 感谢 Thanks

We would like to thank the following projects for helping us achieve our goals:




 
