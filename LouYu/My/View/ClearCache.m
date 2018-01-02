//
//  ClearCache.m
//  PostFoot(驿足)
//
//  Created by Medalands on 16/10/20.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import "ClearCache.h"
#import "MBProgressHUD.h"
@implementation ClearCache
+ (void) showHUDWithText:(NSString *)message{
    
    [[self class] showHUDWithText:message completionBlock:nil];
}

+ (void)showHUDWithText:(NSString *)message completionBlock:(void(^)(void))completionBlock{
    
    UIWindow *tmpWindow = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *tmpHUD = [[MBProgressHUD alloc] initWithView:tmpWindow];
    
    [tmpWindow addSubview:tmpHUD];
    
    [tmpHUD setMode:MBProgressHUDModeText];
    tmpHUD.bezelView.style=MBProgressHUDBackgroundStyleSolidColor;
    tmpHUD.bezelView.backgroundColor=[UIColor blackColor];
    // -- 设置文字
    tmpHUD.detailsLabel.text=message;
    //9，设置提示框的相对于父视图中心点的便宜，正值 向右下偏移，负值左上
    [tmpHUD setFrame:CGRectMake(KscreenWidth/2-150, KscreenHeight-200, 300, 100)];
    //10，设置各个元素距离矩形边框的距离
//    tmpHUD.margin = 0;
    tmpHUD.detailsLabel.textColor=[UIColor whiteColor];
    tmpHUD.detailsLabel.font=[UIFont systemFontOfSize:14];
//    tmpHUD.label.backgroundColor=[UIColor blackColor];
    [tmpHUD showAnimated:YES];
    
    [tmpHUD hideAnimated:YES afterDelay:1];
    
    tmpHUD.completionBlock = completionBlock;
}

+(void)showHUDAndView:(UIView *)View completionBlock:(void(^)(void))completionBlock{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:View animated:YES];
    hud.bezelView.style=MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor=[UIColor lightGrayColor];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        hud.completionBlock = completionBlock;
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:0.5];
        });
    });
    
    

}



@end
