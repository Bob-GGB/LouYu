//
//  ShareCollectionViewCell.m
//  CamelBB
//
//  Created by ChangRJey on 17/3/27.
//  Copyright © 2017年 RenJiee. All rights reserved.
//

#import "ShareCollectionViewCell.h"
#import <Masonry.h>

/** 屏幕的SIZE */
#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size
/** define:屏幕的宽高比 */
#define CURRENT_SIZE(_size) _size / 375.0 * SCREEN_SIZE.width
/** 灰色 */
#define KGrayColor SELECT_COLOR(153,153,153,1)
/** 弱引用 */
#define WEAKSELF __weak typeof(self) weakSelf = self;

@implementation ShareCollectionViewCell


#pragma mark -------------------- 在layoutSubviews方法中设置子控件的frame --------------------

- (void)layoutSubviews
{
    [super layoutSubviews];
    [AtuoFillScreenUtils autoLayoutFillScreen:self];
    WEAKSELF
    [self addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(CURRENT_SIZE(40), CURRENT_SIZE(40)));
        make.centerY.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf);
    }];
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(CURRENT_SIZE(50), CURRENT_SIZE(18)));
        make.top.equalTo(self.icon).offset(50);
//        make.centerY.equalTo(self.icon);
        make.centerX.equalTo(weakSelf).offset(-1);
    }];
}

- (UIImageView *) icon{
    if(!_icon){
        _icon = [UIImageView new];
        _icon.backgroundColor = [UIColor clearColor];
        _icon.image = [UIImage imageNamed:@"微信ico"];
    }
    return _icon;
}



-(UILabel *)nameLabel{
    
    if(!_nameLabel){
        _nameLabel = [UILabel new];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor grayColor];
        _nameLabel.font = [UIFont systemFontOfSize:CURRENT_SIZE(14)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        
        
        
    }
    return _nameLabel;

}



@end
