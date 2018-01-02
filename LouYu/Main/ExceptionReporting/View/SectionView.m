//
//  SectionView.m
//  Demo_4抽屉效果
//
//  Created by Medalands on 16/9/26.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import "SectionView.h"

@interface SectionView ()
@property(nonatomic,strong)UIView *linView;

@end

@implementation SectionView

- (instancetype) initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.isOpen = YES;
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self addTarget:self action:@selector(controlDidPress:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.sectionLable];
        [self addSubview:self.headImageView];
        [self addSubview:self.linView];
    }
    
    return self;
}



- (void) controlDidPress:(SectionView *)sender{
    
    self.isOpen = !self.isOpen;
    
    if (self.isOpen==YES) {
        [self.headImageView setImage:[UIImage imageNamed:@"btn_xiala.png"]];
    }
    else
        [self.headImageView setImage:[UIImage imageNamed:@"btn_shangla.png"]];
   
    if (self.shouldReload) {
        
        self.shouldReload();
    }
    
}



-(UILabel *)sectionLable{
    if (_sectionLable ==nil) {
        _sectionLable =[[UILabel alloc] initWithFrame:CGRectMake(10, 0, KscreenWidth-100*Width, 39*Height)];
//        [_sectionLable setBackgroundColor:[UIColor greenColor]];
    }
    
    
    return _sectionLable;
}
-(UIImageView *)headImageView{
    if (_headImageView==nil) {
        _headImageView=[[UIImageView alloc] initWithFrame:CGRectMake(KscreenWidth-50*Width, 0, 40*Width
, 40*Height)];
        [_headImageView setImage:[UIImage imageNamed:@"btn_shangla.png"]];
    }
    return _headImageView;
}

-(UIView *)linView{
    
    if (_linView==nil) {
        _linView=[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.sectionLable.frame), KscreenWidth, 1)];
        [_linView setBackgroundColor: KRGB(153, 153, 153, 1.0f)];
    }
    return _linView;
    
}


@end
