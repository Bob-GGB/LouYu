//
//  ShareView.m
//  CamelBB
//
//  Created by ChangRJey on 17/3/25.
//  Copyright © 2017年 RenJiee. All rights reserved.
//

#import "ShareView.h"
#import <Masonry.h>
#import "ShareCollectionViewFlowLayout.h"
#import "ShareCollectionViewCell.h"

/** 屏幕的SIZE */
#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size
/** define:屏幕的宽高比 */
#define CURRENT_SIZE(_size) _size / 375.0 * SCREEN_SIZE.width
/** 弱引用 */
#define WEAKSELF __weak typeof(self) weakSelf = self;
#define SELECT_COLOR(_r,_g,_b,_alpha) [UIColor colorWithRed:_r / 255.0 green:_g / 255.0 blue:_b / 255.0 alpha:_alpha]

/** 灰色 */
#define KGrayColor SELECT_COLOR(153,153,153,1)

@implementation ShareView


#pragma mark -------------------- 在layoutSubviews方法中设置子控件的frame --------------------

- (void)layoutSubviews
{
    [super layoutSubviews];
    WEAKSELF
[AtuoFillScreenUtils autoLayoutFillScreen:self];
    [self addSubview:self.collection];
    [self.collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_SIZE.width, CURRENT_SIZE(110)));
                make.centerX.equalTo(weakSelf);
                make.centerY.equalTo(weakSelf).offset(-10);
        
            }];
    

}


#pragma mark -------------------- 懒加载控件 --------------------


- (UICollectionView *) collection{
    if(!_collection){
        _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:[[ShareCollectionViewFlowLayout alloc] init]];
        _collection.backgroundColor = [UIColor clearColor];
        //设置cell
        [_collection registerClass:[ShareCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
    }
    return _collection;
}



@end
