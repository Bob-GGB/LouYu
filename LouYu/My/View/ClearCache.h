//
//  ClearCache.h
//  PostFoot(驿足)
//
//  Created by Medalands on 16/10/20.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClearCache : NSObject

+ (void) showHUDWithText:(NSString *)message;
+ (void) showHUDAndView:(UIView *)View completionBlock:(void(^)(void))completionBlock;
@end
