//
//  HeadButtonsView.m
//  LouYu
//
//  Created by barby on 2017/7/14.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "HeadButtonsView.h"
#import "ApproveViewController.h"
#import "XiaoFangViewController.h"
#import "ExceptionReportViewController.h"
#import "FireTestViewController.h"
#import "InspectionRecordsViewController.h"
#import "SponsorEventMianViewController.h"
#import "ExceptionSettleViewController.h"
#import "RegistrationViewController.h"

@interface HeadButtonsView ()
@property (strong,nonatomic)UIButton *imageButton;
@property (strong,nonatomic)UILabel *nameLabel;
@property (strong,nonatomic)NSArray *images;
@property (strong,nonatomic)NSArray *labels;
@property (strong,nonatomic)NSArray *imagefzr;
@property (strong,nonatomic)NSArray *labelsfzr;

@property (strong,nonatomic)NSArray *imagexjr;
@property (strong,nonatomic)NSArray *labelsxjr;

@property(nonatomic,strong)NSNumber *roleId;
@end

static const CGFloat gap = 20;
static const NSInteger col = 3;

@implementation HeadButtonsView


-(instancetype)initWithRoleID:(NSNumber *)roleID{
    self=[super init] ;
    if (self) {
        CGFloat x = gap;
        CGFloat y = gap/3;
        CGFloat imageButtonWidth = (KscreenWidth - gap * (col+1))/col;
        CGFloat imageButtonHeight = 60;
        self.roleId=roleID;
        
        if ([roleID isEqualToNumber:@2]) {//负责人
            for (int i=0; i<self.imagefzr.count; i++)
            {
                _imageButton = [[UIButton alloc]init];
                _imageButton.frame = CGRectMake(x, y, imageButtonWidth,imageButtonHeight);
                
                [_imageButton setImage:self.images[i] forState:UIControlStateNormal];
                [_imageButton addTarget:self action:@selector(buttonDidPress:) forControlEvents:UIControlEventTouchUpInside];
                _imageButton.tag=i+101;
                _nameLabel = [[UILabel alloc]init];
                _nameLabel.textAlignment = NSTextAlignmentCenter;
                _nameLabel.font = [UIFont systemFontOfSize:13];
                _nameLabel.frame = CGRectMake(x, y+imageButtonHeight,imageButtonWidth,10);
                _nameLabel.text = self.labelsfzr[i];
                
                if ((i+1) % col == 0 && i !=0)
                {
                    x = gap;
                    y += imageButtonHeight + gap;
                }
                else
                {
                    x += imageButtonWidth + gap;
                }
                
                [self addSubview:_imageButton];
                [self addSubview:_nameLabel];
            }
        }
        

        
        if ([roleID isEqualToNumber:@1]) {//巡检人
            for (int i=0; i<self.imagexjr.count; i++)
            {
                _imageButton = [[UIButton alloc]init];
                _imageButton.frame = CGRectMake(x, y, imageButtonWidth,imageButtonHeight);
                
                [_imageButton setImage:self.imagexjr[i] forState:UIControlStateNormal];
                [_imageButton addTarget:self action:@selector(buttonDidPress:) forControlEvents:UIControlEventTouchUpInside];
                _imageButton.tag=i+101;
                _nameLabel = [[UILabel alloc]init];
                _nameLabel.textAlignment = NSTextAlignmentCenter;
                _nameLabel.font = [UIFont systemFontOfSize:13];
                _nameLabel.frame = CGRectMake(x, y+imageButtonHeight,imageButtonWidth,10);
                _nameLabel.text = self.labelsxjr[i];
                
                if ((i+1) % col == 0 && i !=0)
                {
                    x = gap;
                    y += imageButtonHeight + gap;
                }
                else
                {
                    x += imageButtonWidth + gap;
                }
                
                [self addSubview:_imageButton];
                [self addSubview:_nameLabel];
            }
        }

        if ([roleID isEqualToNumber:@3]) {//总负责人
            for (int i=0; i<self.images.count; i++)
            {
                _imageButton = [[UIButton alloc]init];
                _imageButton.frame = CGRectMake(x, y, imageButtonWidth,imageButtonHeight);
                
                [_imageButton setImage:self.images[i] forState:UIControlStateNormal];
                [_imageButton addTarget:self action:@selector(buttonDidPress:) forControlEvents:UIControlEventTouchUpInside];
                _imageButton.tag=i+101;
                _nameLabel = [[UILabel alloc]init];
                _nameLabel.textAlignment = NSTextAlignmentCenter;
                _nameLabel.font = [UIFont systemFontOfSize:13];
                _nameLabel.frame = CGRectMake(x, y+imageButtonHeight,imageButtonWidth,10);
                _nameLabel.text = self.labels[i];
                
                if ((i+1) % col == 0 && i !=0)
                {
                    x = gap;
                    y += imageButtonHeight + gap;
                }
                else
                {
                    x += imageButtonWidth + gap;
                }
                
                [self addSubview:_imageButton];
                [self addSubview:_nameLabel];
            }
        }

        
        
        
        }
    return self;
}




-(NSArray *)images
{
    if (!_images)
    {
        _images = @[[UIImage imageNamed:@"矢量智能对象"],
                    [UIImage imageNamed:@"btn_2.png"],
                    [UIImage imageNamed:@"btn_3.png"],
                    [UIImage imageNamed:@"btn_04.png"],
                    [UIImage imageNamed:@"btn_5.png"],
                    [UIImage imageNamed:@"btn_6.png"],
                    
                    ];
    }
    return _images;
}

-(NSArray *)labels
{
    if (!_labels)
    {
        _labels = @[@"户籍管理",@"巡查记录",@"待我审批",@"消防知识",@"培训考试",@"发起事件"
                    ];
    }
    return _labels;
}

-(NSArray *)imagefzr{
    if (!_imagefzr) {
        _imagefzr=@[[UIImage imageNamed:@"矢量智能对象"],
                    [UIImage imageNamed:@"btn_2.png"],
                    [UIImage imageNamed:@"btn_3.png"],
                    [UIImage imageNamed:@"btn_04.png"],
                    [UIImage imageNamed:@"btn_5.png"],
                    [UIImage imageNamed:@"btn_shangbao.png"],];
    }
    return _imagefzr;
}

-(NSArray *)labelsfzr{
    if (!_labelsfzr) {
        
        _labelsfzr=@[@"户籍管理",@"巡查记录",@"待我审批",@"消防知识",@"培训考试",@"异常上报"];
        
    }
    
    return _labelsfzr;
}

-(NSArray *)imagexjr{
    if (!_imagexjr) {
        _imagexjr=@[[UIImage imageNamed:@"矢量智能对象"],
                    [UIImage imageNamed:@"btn_2.png"],
                    [UIImage imageNamed:@"btn_yichangchuli.png"],
                    [UIImage imageNamed:@"btn_04.png"],
                    [UIImage imageNamed:@"btn_5.png"],
                    [UIImage imageNamed:@"btn_shangbao.png"],];
    }
    return _imagexjr;
}

-(NSArray *)labelsxjr{
    if (!_labelsxjr) {
        _labelsxjr=@[@"户籍管理",@"巡查记录",@"异常处理",@"消防知识",@"培训考试",@"异常上报"];
        
    }
    
    return _labelsxjr;
}


-(void)buttonDidPress:(UIButton *)sender{
    //NSLog(@"%ld",sender.tag);
    ApproveViewController *appCV=[[ApproveViewController alloc] init];
    XiaoFangViewController *xiaoFangCV=[[XiaoFangViewController alloc] init];
    ExceptionReportViewController *exceptionCV=[[ExceptionReportViewController alloc] init];
    InspectionRecordsViewController *inspectionCV=[[InspectionRecordsViewController alloc] init];
    FireTestViewController *FireTestCV=[[FireTestViewController alloc] init];
    SponsorEventMianViewController *sponsorCV=[[SponsorEventMianViewController alloc] init];
    ExceptionSettleViewController *settleCV=[[ExceptionSettleViewController alloc] init];
    RegistrationViewController *registCV=[[RegistrationViewController alloc] init];
    
    

    if ([self.roleId isEqualToNumber:@1])//巡检人
    {
        switch (sender.tag) {
            case 101:
                if (self.sendController) {
                    self.sendController(registCV);
                }
                break;
            case 102:
                if (self.sendController) {
                    self.sendController(inspectionCV);
                }
                break;
            case 103:
                if (self.sendController) {
                    settleCV.roleIDNum=self.roleId;
                    self.sendController(settleCV);
                }
                break;
            case 104:
                if (self.sendController) {
                    self.sendController(xiaoFangCV);
                }

                break;
            case 105:
                if (self.sendController) {
                    self.sendController(FireTestCV);
                }
                
                break;
            case 106:
                if (self.sendController) {
                    self.sendController(exceptionCV);
                }

                
            default:
                break;
        }
    }
    
    if ([self.roleId isEqualToNumber:@2])//负责人
    {
        switch (sender.tag) {
            case 101:
                if (self.sendController) {
                    self.sendController(registCV);
                }
                break;
            case 102:
                if (self.sendController) {
                    self.sendController(inspectionCV);
                }
                break;
            case 103:
                if (self.sendController) {
                    self.sendController(appCV);
                }

                break;
            case 104:
                if (self.sendController) {
                    self.sendController(xiaoFangCV);
                }
                break;
            case 105:
                if (self.sendController) {
                    self.sendController(FireTestCV);
                }
                break;
            case 106:
                if (self.sendController) {
                    self.sendController(exceptionCV);
                }

                
            default:
                break;
        }
    }
    
    
    
    if ([self.roleId isEqualToNumber:@3])//总负责人
    {
        switch (sender.tag) {
            case 101:
                if (self.sendController) {
                    self.sendController(registCV);
                }
                break;
            case 102:
                if (self.sendController) {
                    self.sendController(inspectionCV);
                }
                break;
            case 103:
                if (self.sendController) {
                    
                    appCV.roleIDNum=self.roleId;
                    self.sendController(appCV);
                }

                break;
            case 104:
                if (self.sendController) {
                    self.sendController(xiaoFangCV);
                }
                break;
            case 105:
                if (self.sendController) {
                    self.sendController(FireTestCV);
                }
                break;
            case 106:
                if (self.sendController) {
                    self.sendController(sponsorCV);
                }
            default:
                break;
        }
    }
    
  

    
    
}

@end
