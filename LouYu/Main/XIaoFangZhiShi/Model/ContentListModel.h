//
//  ContentListModel.h
//  LouYu
//
//  Created by barby on 2017/7/27.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

@interface ContentListModel : BaseModel
@property(nonatomic,copy)NSString *photo;
@property(nonatomic,copy)NSString *text;

@property (nonatomic, assign)CGFloat cellHeight;
@end
