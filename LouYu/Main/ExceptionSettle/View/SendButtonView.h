//
//  SendButtonView.h
//  LouYu
//
//  Created by barby on 2017/8/16.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendButtonView : UIView

@property(nonatomic,strong)UIButton *sendButton;
@property (nonatomic , strong) void(^sendController)(UIViewController * controller);
//重新定义init方法
-(instancetype)initWithWarnID:(NSNumber *)WarnID RoleId:(NSNumber *)RoleId;
@end
