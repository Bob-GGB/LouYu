//
//  ButtonTableViewCell.h
//  LouYu
//
//  Created by barby on 2017/7/25.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonTableViewCell : UITableViewCell
@property(nonatomic,strong)UIButton *ReporteButton;
@property(nonatomic,strong)UIButton *SuggestButton;
@property(nonatomic,strong)UIButton *sendButton;
@property (nonatomic , strong) void(^sendController)(UIViewController * controller);
@property(nonatomic,copy)NSString *noteStr;
//重新定义init方法
-(instancetype)initWithWarnID:(NSNumber *)WarnID RoleId:(NSNumber *)RoleId;

@end
