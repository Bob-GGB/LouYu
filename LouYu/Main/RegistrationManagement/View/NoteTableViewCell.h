//
//  NoteTableViewCell.h
//  LouYu
//
//  Created by barby on 2017/7/28.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *miaoshulabel;
@property(nonatomic,strong)UILabel *noteLabel;

/**
 *  传入每一行cell数据，返回行高，提供接口
 *
 *  @param tableView 当前展示的tableView
 *  @param object cell的展示数据内容
 */
+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object;
@end
