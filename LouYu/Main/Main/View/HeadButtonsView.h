//
//  HeadButtonsView.h
//  LouYu
//
//  Created by barby on 2017/7/14.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadButtonsView : UITableViewCell


@property (nonatomic , strong) void(^sendController)(UIViewController * controller);

//重新定义init方法
-(instancetype)initWithRoleID:(NSNumber *)roleID;
@end
