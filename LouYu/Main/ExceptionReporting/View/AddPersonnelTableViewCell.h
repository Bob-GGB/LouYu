//
//  AddPersonnelTableViewCell.h
//  LouYu
//
//  Created by barby on 2017/8/1.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPersonnelTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *sendLabel;
@property(nonatomic,strong)UILabel *deleteLabel;
@property(nonatomic,strong)UIImageView *addPersonImageView;



@property (nonatomic , strong) void(^sendController)(UIViewController * controller);
@end
