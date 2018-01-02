//
//  HttpRequest.h
//  Demo_3 练习
//
//  Created by Medalands on 16/9/28.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NetworkStatus) {
    NetworkStatusUnknown          = -1,
    NetworkStatusNotReachable     = 0,
    NetworkStatusReachableViaWWAN = 1,
    NetworkStatusReachableViaWiFi = 2,
};


@interface HttpRequest : NSObject

/**
 *  get请求方式
 *
 *  @param URLString  接口地址
 *  @param parameters 接口参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void) GET:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObj))success
     failure:(void (^)(NSError * error))failure;


/**
 *  get请求方式
 *
 *  @param URLString  接口地址
 *   parameters 接口参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void) POST:(NSString *)URLString getToken:(NSNumber *)token paramentDict:(NSMutableDictionary *)Dic
     success:(void (^)(id responseObj))success
     failure:(void (^)(NSError * error))failure;


+ (void) POST:(NSString *)URLString
   parameters:(id)parameters
      success:(void (^)(id responseObj))success
      failure:(void (^)(NSError * error))failure;

/**
 *  网络状态发生了改变
 *
 *  @param status 改变后的网络状态
 */
+ (void) netStatusDidChanged:(void(^)(NetworkStatus netStatus))status;

/**
 *  文件的上传
 *
 *  @param URLString      接口地址
 *  @param parameters     接口参数
 *  @param name           服务器给的字段(和我们没关系)
 *  @param fileName       在服务器上保存的文件名
 *  @param mimeType       文件的类型
 *  @param progress 上传的进度
 *  @param success        成功
 *  @param failure        失败
 */
+ (void) upload:(NSString *)URLString
     parameters:(id)parameters imageArr:(NSArray *)arr name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType progress:(void (^)(NSProgress *progress))progress
        success:(void (^)(id responseObj))success
        failure:(void (^)(NSError * error))failure;

+ (void) upload:(NSString *)URLString
     parameters:(id)parameters fileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType progress:(void (^)(NSProgress *progress))progress
        success:(void (^)(id responseObj))success
        failure:(void (^)(NSError * error))failure;

/**
 *  下载
 *
 *  @param URLString 下载链接
 *  @param savePath  保存的路径
 *  @param need      是否需要使用建议的文件名
 *  @param progress  进度的回调
 *  @param success   成功的回调
 *  @param failure   失败的回调
 */
+ (void) download:(NSString *)URLString savePath:(NSString *)savePath needSuggest:(BOOL)need progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(void))success
          failure:(void (^)(NSError * error))failure;





//转成json字符串
+(NSString *)ziDianZhuanJson:(NSDictionary *)object;
//MD5加密
+(NSString *)encryptStringWithMD5:(NSString *)inputStr;




@end
