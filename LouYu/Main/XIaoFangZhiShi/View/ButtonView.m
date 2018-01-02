//
//  ButtonView.m
//  LouYu
//
//  Created by barby on 2017/7/26.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "ButtonView.h"
#import "NewsViewController.h"
@interface ButtonView ()
@property (strong,nonatomic)UIButton *imageButton;
@property (strong,nonatomic)UILabel *nameLabel;
@property (strong,nonatomic)NSArray *images;
@property (strong,nonatomic)NSArray *labels;
@end

static const CGFloat gap = 30;
static const NSInteger col = 3;


@implementation ButtonView

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat x = gap;
        CGFloat y = gap/gap;
        CGFloat imageButtonWidth = (KscreenWidth - gap * (col+1))/col;
        CGFloat imageButtonHeight = imageButtonWidth;
        for (int i=0; i<self.images.count; i++)
        {
            _imageButton = [[UIButton alloc]init];
            _imageButton.frame = CGRectMake(i*(30+imageButtonWidth)+gap, 0, imageButtonWidth*Width,imageButtonHeight*Height);
            [_imageButton setImage:self.images[i] forState:UIControlStateNormal];
            [_imageButton addTarget:self action:@selector(buttonDidPress:) forControlEvents:UIControlEventTouchUpInside];
            _imageButton.tag=i+101;
            _nameLabel = [[UILabel alloc]init];
            _nameLabel.textAlignment = NSTextAlignmentCenter;
            _nameLabel.font = [UIFont systemFontOfSize:13];
            _nameLabel.frame = CGRectMake(i*(30+imageButtonWidth)+gap-5, y+imageButtonHeight-5,imageButtonWidth*Width+10,20*Height);
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
       
        UIView *lineView=[[UIView alloc] init];
                          //WithFrame:CGRectMake(0, CGRectGetMaxY(self.nameLabel.frame)+5, KscreenWidth, 10)];
        [lineView setBackgroundColor:KRGB(220, 220, 220, 0.5)];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(@0);
            make.height.equalTo(@10);
            make.bottom.equalTo(@0);
        }];
        
    }
    
    return self;
}




-(NSArray *)images
{
    if (!_images)
    {
        _images = @[[UIImage imageNamed:@"xinwen1.png"],
                    [UIImage imageNamed:@"fagui.png"],
                    [UIImage imageNamed:@"bendi.png"],
                    ];
    }
    return _images;
}

-(NSArray *)labels
{
    if (!_labels)
    {
        _labels = @[@"新闻",@"法规",@"本地"
                    ];
    }
    return _labels;
}




-(void)buttonDidPress:(UIButton *)sender{
    //NSLog(@"%ld",sender.tag);
    NewsViewController *newsVC=[[NewsViewController alloc] init];
    
    if (sender.tag==101) {
        newsVC.typeIDNum=@1;
        newsVC.typeName=@"新闻";
        if (self.sendController) {
            self.sendController(newsVC);
        }
    }
    if (sender.tag==102) {
        newsVC.typeIDNum=@2;
        newsVC.typeName=@"法规";
        
        if (self.sendController) {
            self.sendController(newsVC);
        }
    }
    if (sender.tag==103) {
        newsVC.typeIDNum=@3;
        newsVC.typeName=@"本地";
        if (self.sendController) {
            self.sendController(newsVC);
        }
    }

}





- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
