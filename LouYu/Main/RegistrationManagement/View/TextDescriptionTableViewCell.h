//
//  TextDescriptionTableViewCell.h
//  LouYu
//
//  Created by barby on 2017/7/28.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextDescriptionTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *descripLabel;
@property(nonatomic,strong)UILabel *textDescriptionLabel;
/**
 *  传入每一行cell数据，返回行高，提供接口
 *
 *  @param tableView 当前展示的tableView
 *  @param object cell的展示数据内容
 */
+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object;
@end
