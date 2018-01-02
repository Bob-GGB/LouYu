//
//  HttpRequest.m
//  Demo_3 练习
//
//  Created by Medalands on 16/9/28.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import "HttpRequest.h"
#import "AFNetworking.h"



@implementation HttpRequest

+ (void) GET:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObj))success
     failure:(void (^)(NSError * error))failure{
    
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    // afn里面就帮我们开辟了线程,去执行网络的请求.一旦网络请求成功之后,再把数据反馈给主线程,
    [mgr GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 如果成功的block被实现了,内部就调用这个block
        if (success) {
            success(responseObject);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];
  
}


+ (void) POST:(NSString *)URLString
   parameters:(id)parameters
      success:(void (^)(id responseObj))success
      failure:(void (^)(NSError * error))failure{
    
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    mgr.requestSerializer  = [AFJSONRequestSerializer serializer];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];
    [mgr.requestSerializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type" ];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    // afn里面就帮我们开辟了线程,去执行网络的请求.一旦网络请求成功之后,再把数据反馈给主线程,
    [mgr POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 如果成功的block被实现了,内部就调用这个block
        if (success) {
            success(responseObject);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];
    
}



+(void)POST:(NSString *)URLString  getToken:(NSNumber *)token paramentDict:(NSMutableDictionary *)Dic success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];
    [manager.requestSerializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type" ];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/html", @"text/plain",nil];
    
    
    /****************************************************************************************/
    
    
    if (Dic==nil) {
        
            NSString *tmpstr=@"\"[]\"";
        
            //获取当前时间
            NSDate *date = [NSDate date];
        
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        
            [formatter setDateStyle:NSDateFormatterMediumStyle];
        
            [formatter setTimeStyle:NSDateFormatterShortStyle];
        
            [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
            NSString *DateTime = [formatter stringFromDate:date];
        
            NSMutableDictionary *Alldict=[[NSMutableDictionary alloc] init];
            [Alldict setValue:tmpstr forKey:@"app"];
        
            [Alldict setValue:token forKey:@"token"];
            [Alldict setValue:DateTime forKey:@"timestamp"];
        
        
            //md5加密
            //    //字符串拼接
        
        
            NSString *MD5string2=[NSString stringWithFormat:@"%@%@%@",[Alldict objectForKey:@"token"],[Alldict objectForKey:@"timestamp"],[Alldict objectForKey:@"app"]];
//             NSLog(@"hahahah%@",MD5string2);
            //MD5加密
            //NSLog(@"--加密之前：%@",MD5string2);
            NSString *getStrMD5=[self encryptStringWithMD5:MD5string2];
            [Alldict setValue:getStrMD5  forKey:@"checksum"];
        
        
            /****************************************************************************************/
            
            //传入的参数
            
            NSDictionary *parameters =[NSDictionary dictionaryWithObjectsAndKeys:@"[]",@"app",DateTime,@"timestamp",token,@"token",getStrMD5,@"checksum", nil];
        [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            // 如果成功的block被实现了,内部就调用这个block
            if (success) {
                success(responseObject);
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (failure) {
                failure(error);
            }
        }];
        

        
    }
    
    else{
        
        //获取当前时间
        
        NSDate *date = [NSDate date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
        NSString *DateTime = [formatter stringFromDate:date];
        
        NSMutableDictionary *Alldict=[[NSMutableDictionary alloc] init];
        
        [Alldict setValue: Dic forKey:@"app"];
        
        [Alldict setValue:token forKey:@"token"];
        [Alldict setValue:DateTime forKey:@"timestamp"];
        
        
        //md5加密
        //    //字符串拼接
        
        // NSString *MD5string=[self ziDianZhuanJson:pageDict];
        NSString *MD5String1=[self ziDianZhuanJson:Dic];
//        NSLog(@"Dic%@",Dic);
//        NSLog(@"MD5String1:%@",MD5String1);
        NSString *MD5string2=[NSString stringWithFormat:@"%@%@",[Alldict objectForKey:@"token"],[Alldict objectForKey:@"timestamp"]];
        NSString *MD5Str=[ MD5string2 stringByAppendingString: MD5String1];
//             NSLog(@"hahahah%@",MD5Str);
        //MD5加密
        NSString *getStrMD5=[self encryptStringWithMD5:MD5Str];
        [Alldict setValue:getStrMD5  forKey:@"checksum"];
        
        
        
        /****************************************************************************************/
        
        //传入的参数
        
        NSDictionary *parameters =[NSDictionary dictionaryWithObjectsAndKeys:Dic,@"app",DateTime,@"timestamp",token,@"token",getStrMD5,@"checksum", nil];
        //接口地址
        //NSString *urlString = @"http://louyu.qianchengwl.cn/minapp/patrol/getPatrolList";
        
    
    [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 如果成功的block被实现了,内部就调用这个block
        if (success) {
            success(responseObject);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];

    }
    
}


+ (void) netStatusDidChanged:(void(^)(NetworkStatus netStatus))statu{
    
    // 1.开始检测网络状态
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 2.设置网络状态改变后的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
      
        if (status == AFNetworkReachabilityStatusUnknown) {
            
            // 网络状态不知道
            statu(NetworkStatusUnknown);
        }
        else if(status == AFNetworkReachabilityStatusNotReachable){
            // 没有网络
            statu(NetworkStatusNotReachable);
        }
        else if(status == AFNetworkReachabilityStatusReachableViaWWAN){
            // 蜂窝移动
              statu(NetworkStatusReachableViaWWAN);
        }
        else if(status == AFNetworkReachabilityStatusReachableViaWiFi){
            // 无线网络
            statu(NetworkStatusReachableViaWiFi);
        }
        
        
        
    }];
   
}


+ (void) upload:(NSString *)URLString
     parameters:(id)parameters imageArr:(NSArray *)arr name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType progress:(void (^)(NSProgress *progress))progress
        success:(void (^)(id responseObj))success
        failure:(void (^)(NSError * error))failure{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.requestSerializer= [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         
                                                         @"text/html",
                                                         
                                                         @"image/jpeg",
                                                         
                                                         @"image/png",
                                                         
                                                         @"application/octet-stream",
                                                         
                                                         @"text/json",
                                                         
                                                         nil];
    

    
    [manger POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 我们需要在这里,进行图片的上传
        if (arr.count) {
            for (NSData *obj in arr) {
                
                [formData appendPartWithFileData:obj name:name fileName:fileName mimeType:mimeType];

            }
        }
        
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress) {
            progress(uploadProgress);
        }
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
  
        if (failure) {
            failure(error);
        }
  
    }];
   
}


+ (void) upload:(NSString *)URLString
     parameters:(id)parameters fileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType progress:(void (^)(NSProgress *progress))progress
        success:(void (^)(id responseObj))success
        failure:(void (^)(NSError * error))failure{

    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.requestSerializer= [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                        
                                                        @"text/html",
                                                        
                                                        @"image/jpeg",
                                                        
                                                        @"image/png",
                                                        
                                                        @"application/octet-stream",
                                                        
                                                        @"text/json",
                                                        
                                                        nil];
    
    
    [manger POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 我们需要在这里,进行图片的上传
        
                [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress) {
            progress(uploadProgress);
        }
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    

    

}






+ (void) download:(NSString *)URLString savePath:(NSString *)savePath needSuggest:(BOOL)need progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(void))success
          failure:(void (^)(NSError * error))failure{
    
    
    // 1. 创建管理者对象
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    // 2. 确定请求的url的地址
    NSURL *url = [NSURL URLWithString:URLString];
    
    // 3. 创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 4. 下载任务
    NSURLSessionDownloadTask *task = [manger downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
       
        if (progress) {
            progress(downloadProgress);
        }
        
        
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *resutSavePath = nil;
        
        if (need) {
            if ([savePath hasSuffix:@"/"]) {
               resutSavePath = [savePath stringByAppendingString:response.suggestedFilename];
            }
            else{
                resutSavePath = [savePath stringByAppendingPathComponent:response.suggestedFilename];
            }
        }
        else{
            resutSavePath = savePath;
            
        }
       
        
        NSURL *url = [NSURL fileURLWithPath:resutSavePath];

        return url;
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) {
        
            if (failure) {
                failure(error);
            }
            
        }
        else{
            
            if (success) {
                success();
            }
            
        }
        
        
    }];
    
    
    [task resume];
}



+(void)getToken:(NSNumber *)token andRoleID:(NSNumber *)roleID {
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[defaults dictionaryForKey:@"UserInfoDic"];
    //取到userInfo
    NSDictionary *userDic=dic[@"content"][@"userInfo"];
    token=userDic[@"token"];
    roleID=userDic[@"roleID"];
    
    // NSLog(@"self.tokenStr%@",self.tokenStr);
    
}

//转成json字符串
+(NSString *)ziDianZhuanJson:(NSDictionary *)object{
    
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (! jsonData) {
        NSLog(@"________Got an error________: %@", error);
    }
    else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    
    //去掉字符串中的空格
    jsonString = [jsonString stringByReplacingOccurrencesOfString: @" " withString: @""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString: @"\n" withString: @""];
    //去掉字符串中的空格
    jsonString = [jsonString stringByReplacingOccurrencesOfString: @"\n" withString: @""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString: @"\\" withString: @""];
    //去除转义字符“\”
    /*-------------------------------------------------------------------*/
    NSMutableString *imageString = [NSMutableString stringWithString:jsonString];
    NSString *character1 = nil;
    for (int i = 0; i < imageString.length; i ++) {
        character1 = [imageString substringWithRange:NSMakeRange(i, 1)];
        if ([character1 isEqualToString:@"\\"])
            [imageString deleteCharactersInRange:NSMakeRange(i, 1)];
    }
    /*-------------------------------------------------------------------*/
    

    
    return imageString;
}


//MD5加密
+(NSString *)encryptStringWithMD5:(NSString *)inputStr{
    const char *newStr = [inputStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(newStr,(unsigned int)strlen(newStr),result);
    NSMutableString *outStr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for(int i = 0;i<CC_MD5_DIGEST_LENGTH;i++){
        [outStr appendFormat:@"%02x",result[i]];//注意：这边如果是x则输出32位小写加密字符串，如果是X则输出32位大写字符串
    }
    return outStr;
}



@end
