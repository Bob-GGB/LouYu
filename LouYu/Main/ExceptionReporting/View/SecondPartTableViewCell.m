//
//  SecondPartTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/8/1.
//  Copyright © 2017年 barby. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "SecondPartTableViewCell.h"
#import "CountAlertView.h"
#import "JYZRecorder.h"


#define RecordFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Record.caf"]

@interface SecondPartTableViewCell ()<UITextViewDelegate>

@property(strong, nonatomic)JYZRecorder * recorderJIa;
//播放器
@property(strong, nonatomic)AVPlayer * player;
@property(strong, nonatomic)AVPlayerItem * palyItem;



@end

@implementation SecondPartTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _recorderJIa = [JYZRecorder initRecorder];
        [self creatAllView];
    }
    return self;
}

-(void)creatAllView{

    self.suggestText=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 100)];
    
    [self.suggestText setFont:[UIFont systemFontOfSize:16.0f]];
    [self.suggestText setBackgroundColor:[UIColor whiteColor]];
    [self.suggestText setScrollEnabled:YES];
    [self.suggestText setDelegate:self];
    self.suggestText.text=@"描述 请输入异常描述";
    [self.suggestText setKeyboardType:UIKeyboardTypeDefault];
    [self.suggestText setTextColor:[UIColor blackColor]];
    [self.suggestText setReturnKeyType:UIReturnKeyDone];
    [self addSubview:self.suggestText];
    
    self.yuyinlabel =[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.suggestText.frame)+10, 50, 15)];
    [self.yuyinlabel setText:@"语音"];
    [self.yuyinlabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self addSubview:self.yuyinlabel];
    
    self.voiceButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.voiceButton setFrame:CGRectMake(KscreenWidth/2-80, CGRectGetMaxY(self.suggestText.frame), 160, 30)];
   
    [self.voiceButton setImage:[UIImage imageNamed:@"btn_luyin.png"] forState:UIControlStateNormal];
    [self.voiceButton addTarget:self action:@selector(voiceButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.voiceButton];
    
    self.voiceImageView=[[UIImageView alloc] initWithFrame:CGRectMake(KscreenWidth-35,self.voiceButton.frame.origin.y+2, 25, 25)];

    [self.voiceImageView setImage:[UIImage imageNamed:@"btn_yuying_normal.png"]];
    [self addSubview:self.voiceImageView];
    
            self.playButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [self.playButton setFrame:CGRectMake(self.voiceButton.frame.origin.x, CGRectGetMaxY(self.voiceButton.frame)+3, 160, 30)];
    
    
            [self.playButton setBackgroundImage:[UIImage imageNamed:@"矩形-5"] forState:UIControlStateNormal];
            [self.playButton setTitle:@"播放录音" forState:UIControlStateNormal];
            [self.playButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
            [self.playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.playButton addTarget:self action:@selector(playButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
    
            self.deleteButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [self.deleteButton setFrame:CGRectMake(KscreenWidth-40,self.playButton.frame.origin.y, 30, 30)];
             [self.deleteButton setImage:[UIImage imageNamed:@"btn_del.png"] forState:UIControlStateNormal];
            [self.deleteButton addTarget:self action:@selector(deleteButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
            

   



}

-(void)voiceButtonDidPress:(UIButton *)sender{
    NSLog(@"我要录音了");
    
[CountAlertView showWithImages:@"" descText:@"点击“开始”录音，最长60秒" LeftText:@"开始" second:0 rightText:@"取消" LeftBlock:^{
    [_recorderJIa startRecorder];
    [CountAlertView showWithImages:@"" descText:nil LeftText:@"停止" second:59 rightText:@"取消" LeftBlock:^{
        
                [_recorderJIa stopRecorder];
        [self addSubview:self.playButton];
        [self addSubview:self.deleteButton];
    
        
        
    } RightBlock:^{
        
        [_recorderJIa deleteRecord];
        
    }];
    
} RightBlock:^{
    
}];
}



-(void)playButtonDidPress:(UIButton *)sender{
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    NSURL * audioUrl  = [NSURL fileURLWithPath:RecordFile ];

    _palyItem = [[AVPlayerItem alloc]initWithURL:audioUrl];
    _player = [[AVPlayer alloc]initWithPlayerItem:_palyItem];
    AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
    _player.volume=1.0f;
    [sender.layer addSublayer:playerLayer];
    [_player play];
}

-(void)deleteButtonDidPress:(UIButton *)sender{
    //NSLog(@"删除按钮");
    [_recorderJIa deleteRecord];
    [self.playButton removeFromSuperview];
    [self.deleteButton removeFromSuperview];

}


#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"描述 请输入异常描述";
        textView.textColor = [UIColor grayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"描述 请输入异常描述"]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}

#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text] == YES)
    {
        [textView resignFirstResponder];
        
        
        return NO;
    }
    
    return YES;
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
