//
//  PersonalResponseViewController.h
//  LouYu
//
//  Created by barby on 2017/8/30.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseViewController.h"

@interface PersonalResponseViewController : BaseViewController
@property(nonatomic,strong)NSNumber *articleID;
@property(nonatomic,strong)NSNumber *contentID;
@property(nonatomic,strong)NSNumber *userID;
@property(nonatomic,copy)NSString  *headUrl;
@property(nonatomic,copy)NSString  *nameStr;
@property(nonatomic,copy)NSString  *timeStr;
@property(nonatomic,copy)NSString  *contentStr;
@property(nonatomic,strong)NSNumber *pastNum;
@property(nonatomic,strong)NSNumber *praiseNum;

@property(nonatomic,assign)CGFloat cellHieght;

@end
