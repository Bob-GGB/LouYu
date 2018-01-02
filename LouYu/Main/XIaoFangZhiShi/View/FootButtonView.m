//
//  FootButtonView.m
//  LouYu
//
//  Created by barby on 2017/7/27.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "FootButtonView.h"
#import "CommentsViewController.h"

#define Start_X          10.0f      // 第一个按钮的X坐标
#define Start_Y          50.0f     // 第一个按钮的Y坐标
#define Width_Space      15.0f      // 2个按钮之间的横间距

#define Button_Height   49.0f    // 高
#define Button_Width    (KscreenWidth-4*Width_Space)/3    // 宽

@interface FootButtonView ()
@property (strong,nonatomic)NSArray *images;
@property(strong,nonatomic)NSArray *selectImages;
@property(strong,nonatomic) NSNumber *articleIDNum;
@property(strong,nonatomic)NSNumber *userIDNum;
@end

@implementation FootButtonView


-(instancetype)initWithArticleID:(NSNumber *)articleID andUserID:(NSNumber *)userID{
    self=[super init];
    self.articleIDNum=articleID;
    self.userIDNum=userID;
    if (self) {
        [self addButtonS];
    }

    return self;
}

-(void)addButtonS
{
    for (int i = 0 ; i < 3; i++) {
    
        // 圆角按钮
       self.footButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.footButton.tag = i;//这句话不写等于废了
        self.footButton.frame = CGRectMake(i * (Button_Width + Width_Space)+Width_Space , 0, Button_Width, Button_Height);
        [self.footButton setImage:self.images[i] forState:UIControlStateNormal];
        //[self.footButton setImage:self.selectImages[i] forState:UIControlStateSelected];
        //按钮点击方法
        [self.footButton addTarget:self action:@selector(mapBtnClick:) forControlEvents:UIControlEventTouchUpInside];
         [self addSubview:self.footButton];
    }
}

-(NSArray *)images
{
    if (!_images)
    {
        _images = @[[UIImage imageNamed:@"btn_pinglun.png"],
                    [UIImage imageNamed:@"btn_fenxiang.png"],
                    [UIImage imageNamed:@"btn_shoucang.png"],
                    ];
    }
    return _images;
}

-(NSArray *)selectImages
{
    if (!_selectImages)
    {
        _selectImages = @[[UIImage imageNamed:@"btn_pinglun.png"],
                    [UIImage imageNamed:@"btn_fenxiang.png"],
                    [UIImage imageNamed:@"icon_shoucang.png"],
                    ];
    }
    return _selectImages;
}


//点击按钮方法,这里容易犯错
-(void)mapBtnClick:(UIButton *)sender{
    //记住,这里不能写成"mapBtn.tag",这样你点击任何一个button,都只能获取到最后一个button的值,因为前边的按钮都被最后一个button给覆盖了
    NSLog(@"%ld",(long)sender.tag);
    
    if (sender.tag==0) {
        CommentsViewController *commentCV=[[CommentsViewController alloc] init];
        commentCV.articleID=self.articleIDNum;
        [commentCV setHidesBottomBarWhenPushed:YES];
        if (self.sendController) {
            self.sendController(commentCV);
        }
    }
    
    if (sender.tag==1) {
        if (_shareBlock) {
            self.shareBlock();
            
        }
        
    }

    
    if (sender.tag==2) {
        
        _isSelect=!_isSelect;
//     NSLog(@"_isSelectvalue: %@" ,_isSelect?@"YES":@"NO");
        if (self.CollectBlock) {
            
            self.CollectBlock(_isSelect);
        }
    }
}

@end
