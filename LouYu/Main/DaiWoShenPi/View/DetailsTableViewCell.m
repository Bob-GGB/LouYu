//
//  DetailsTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/7/24.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "DetailsTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "XWScanImage.h"
@interface DetailsTableViewCell ()<AVAudioPlayerDelegate>

@property(nonatomic,strong) AVAudioPlayer *audioPlayer;
@property(nonatomic,strong) AVPlayer *avPlayer;
@property(nonatomic,copy)NSString *mp3Str;

#define Start_X          12.0f      // 第一个图片的X坐标
#define Start_Y          20.0f     // 第一个图片的Y坐标
#define Width_Space      10.0f      // 2个图片之间的横间距

#define Button_Height   120.0f    // 高
#define Button_Width    (KscreenWidth-40)/3    // 宽
@end

/*
 -(void)addButtonS
 {
 for (int i = 0 ; i < 6; i++) {
 NSInteger index = i % 3;
 NSInteger page = i / 3;
 
 // 圆角按钮
 UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
 mapBtn.tag = i;//这句话不写等于废了
 mapBtn.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
 
 [self.view addSubview:mapBtn];
 //按钮点击方法
 [mapBtn addTarget:self action:@selector(mapBtnClick:) forControlEvents:UIControlEventTouchUpInside];
 }

 */

@implementation DetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)bindDataWithModel:(DetailModel *)model{
  
    self.typeLabel.text=[NSString stringWithFormat:@"类型：%@",model.title];
    self.descrLabel.text=[NSString stringWithFormat:@"描述：%@",model.textDescription];
    self.mp3Str=model.voiceDescription;
   
    
    if (model.photo.count!=0) {
        for (int i=0; i<model.photo.count; i++) {
            
            self.WarnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(Button_Width + Width_Space) +Start_X,CGRectGetMaxY(self.VoiceButton.frame)+20,Button_Width , Button_Height)];
            self.WarnImageView.tag = i;//这句话不写等于废了
            // [self.WarnImageView setBackgroundColor:[UIColor redColor]];
            [self.WarnImageView sd_setImageWithURL:model.photo[i]];
            [self addSubview:self.WarnImageView];
            
            //为UIImageView1添加点击事件
            UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick1:)];
            [self.WarnImageView addGestureRecognizer:tapGestureRecognizer1];
            //让UIImageView和它的父类开启用户交互属性
            [self.WarnImageView setUserInteractionEnabled:YES];
        }

    }
    else{
    
        [self.WarnImageView removeFromSuperview];
    }
        self.placeLabel.text=model.placeName;
    

}

#pragma mark - 浏览大图点击事件
-(void)scanBigImageClick1:(UITapGestureRecognizer *)tap{
   
    UIImageView *clickedImageView = (UIImageView *)tap.view;
    [XWScanImage scanBigImageWithImageView:clickedImageView];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUpUI];
    }
    
    return self;
}

-(void)setUpUI{
    self.typeLabel =[[UILabel alloc] initWithFrame:CGRectMake(10, 20, KscreenWidth, 17)];
    [self.typeLabel setFont:[UIFont systemFontOfSize:15.0f]];
   // [self.typeLabel setText:@"类型：是当时的我"];
    [self.typeLabel setTextColor:KRGB(51, 51, 51, 1.0f)];
    [self addSubview:self.typeLabel];
    
    self.descrLabel =[[UILabel alloc] initWithFrame:CGRectMake(self.typeLabel.frame.origin.x, CGRectGetMaxY(self.typeLabel.frame)+20, 300, 17)];
    [self.descrLabel setFont:[UIFont systemFontOfSize:15.0f]];
   // [self.descrLabel setText:@"描述：上的法国萨多家咖啡馆的撒风公交卡时代"];
    [self.descrLabel setTextColor:KRGB(51, 51, 51, 1.0f)];
    [self addSubview:self.descrLabel];
    
    self.VoiceLabel =[[UILabel alloc] initWithFrame:CGRectMake(self.typeLabel.frame.origin.x, CGRectGetMaxY(self.descrLabel.frame)+20, 50, 17)];
    [self.VoiceLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.VoiceLabel setTextColor:KRGB(51, 51, 51, 1.0f)];
    [self.VoiceLabel setText:@"语音："];
    [self addSubview:self.VoiceLabel];
    self.VoiceButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.VoiceButton setFrame:CGRectMake(CGRectGetMaxX(self.VoiceLabel.frame), CGRectGetMaxY(self.descrLabel.frame)+15, 185, 30)];
    self.VoiceButton.clipsToBounds=YES;
    self.VoiceButton.layer.cornerRadius=5;
    [self.VoiceButton setBackgroundColor:KRGB(30, 144, 255, 1.0f)];
    [self.VoiceButton setTitle:@"录音播放" forState:UIControlStateNormal];
    self.VoiceButton.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    [self.VoiceButton setBackgroundImage:[UIImage imageNamed:@"矩形-5"] forState:UIControlStateNormal];
    [self.VoiceButton addTarget:self action:@selector(voiceButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.VoiceButton setTintColor:[UIColor whiteColor]];
    UIImageView *voiceIcon=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.VoiceButton.frame)+10, self.VoiceButton.frame.origin.y, 30, 30)];
    [voiceIcon setImage:[UIImage imageNamed:@"btn_yuying_normal.png"]];
    [self addSubview:voiceIcon];
    [self addSubview:self.VoiceButton];
    self.placeImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.VoiceButton.frame)+10+120+30, 15, 15)];
    [self.placeImageView setImage:[UIImage imageNamed:@"icon_disabled.40.png"]];
    [self addSubview:self.placeImageView];
    self.placeLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.placeImageView.frame),self.placeImageView.frame.origin.y, KscreenWidth, 17)];
    [self.placeLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [self.placeLabel setTextColor:KRGB(144, 149, 158, 1.0f)];
   // [self.placeLabel setText:@"杭州西湖区216号XXX大楼"];
    [self addSubview:self.placeLabel];
//

}
-(void)voiceButtonDidPress:(UIButton *)sender{
    //语音播放设置
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    if (self.mp3Str!=NULL) {
        self.avPlayer=[[AVPlayer alloc] initWithURL:[NSURL URLWithString:self.mp3Str]];
        [self.avPlayer play];
    }
    else{
        [ClearCache showHUDWithText:@"没有录音"];
    }
    
}

//-(void)downlodMP3WithUrl:(NSString *)url AndSavePath:(NSString *)path{
//
//    [HttpRequest download:url savePath:path needSuggest:YES progress:nil success:^{
//
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
//
//
//}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
