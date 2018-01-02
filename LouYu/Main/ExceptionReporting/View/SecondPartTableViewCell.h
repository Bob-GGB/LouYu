//
//  SecondPartTableViewCell.h
//  LouYu
//
//  Created by barby on 2017/8/1.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SecondPartTableViewCell : UITableViewCell
@property(nonatomic,strong)UITextView *suggestText;
@property(nonatomic,strong)UILabel *yuyinlabel;
@property(nonatomic,strong)UIButton *voiceButton;
@property(nonatomic,strong)UIButton *playButton;
@property(nonatomic,strong)UIImageView *voiceImageView;
@property(nonatomic,strong)UIButton *deleteButton;
//@property (nonatomic , strong) void(^sendView)(UIView * View);
@end
