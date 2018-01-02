//
//  SectionView.h
//  Demo_4抽屉效果
//
//  Created by Medalands on 16/9/26.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionView : UIControl

// 当前的状态.展开或者收缩  YES 表示当前正在展示.
@property (nonatomic , assign) BOOL isOpen;


// 声明一个block 反传值,告诉controller改收缩还是该展开了
@property (nonatomic , copy) void(^shouldReload)(void);

@property(nonatomic,strong)UILabel *sectionLable;

@property(nonatomic,strong)UIImageView *headImageView;

@end
