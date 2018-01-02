//
//  CommentTextViewAndButtonView.m
//  LouYu
//
//  Created by barby on 2017/8/30.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "CommentTextViewAndButtonView.h"

@interface CommentTextViewAndButtonView ()<UITextViewDelegate>

@end

@implementation CommentTextViewAndButtonView

{
    
    float _currentLineNum;
    NSString *textStr;
    
}

- (instancetype)initWithFrame:(CGRect)frame

{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor =[UIColor whiteColor];
        
        _currentLineNum=1;//默认文本框显示一行文字
        
        [self addSubviews];
        
    }
    
    return self;
    
}

- (void)addSubviews{
    
    self.commentField = [[UITextView alloc]init];
    
    self.commentField.backgroundColor =KRGB(240, 240, 240, 1.0);
    
    self.commentField.font = [UIFont systemFontOfSize:12];
    
   self.commentField.text = @"｜说说你的看法～";
    
    self.commentField.textColor = [UIColor grayColor];
    
    self.commentField.layer.cornerRadius = 8;
    
    self.commentField.layer.masksToBounds = YES;
    _commentField.returnKeyType = UIReturnKeySend;//return键的类型
    
    _commentField.keyboardType = UIKeyboardTypeDefault;//键盘类型

    [self addSubview:self.commentField];
    
    
    
   // self.commentField.contentInset = UIEdgeInsetsMake(-66,0,0,0);
    
    self.commentField.delegate = self;
    
    self.publishBtn = [[UIButton alloc]init];
    
    [self.publishBtn setTitle:@"发送" forState:UIControlStateNormal];
    
    [self.publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.publishBtn setBackgroundColor:KRGB(30, 144, 255, 1.0)];
    
    self.publishBtn.layer.cornerRadius = 5;
    
    self.publishBtn.layer.masksToBounds = YES;
    
    [self.publishBtn addTarget:self action:@selector(publishBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.publishBtn];
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo([NSNumber numberWithFloat:KscreenWidth-90]);
        make.right.equalTo(@-10);
        make.centerY.mas_equalTo(self);
        make.height.greaterThanOrEqualTo(@26);
        
        
    }];

    
    [self.commentField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@10);
        
        make.right.equalTo(self.publishBtn.mas_left).offset(-10);
        
        make.centerY.mas_equalTo(self);
        
        make.height.greaterThanOrEqualTo(@30);
        
    }];
    
}



-(void)publishBtnDidPress:(UIButton *)sender{
 
    if (self.SendCommentBoclk) {
        self.SendCommentBoclk(textStr);
        self.commentField.text=NULL;
    }
}

#pragma mark - UITextViewDelegate



- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@"｜说说你的看法～"]) {
        
        textView.text = @"";
        
        self.commentField.textColor = [UIColor blackColor];
        
        self.commentField.contentInset = UIEdgeInsetsMake(2,0,-2,0);
        
    }
    
    
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    if (textView.text.length<1) {
        
        textView.text = @"｜说说你的看法～";
        
        textView.textColor = [UIColor grayColor];
        
        
    }
    else{
        textStr=textView.text;
       
    self.commentField.contentInset = UIEdgeInsetsMake(2,0,-2,0);
    
    }
    
    
    
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text] == YES)
    {
        
        [textView resignFirstResponder];
        if (self.SendCommentBoclk) {
            self.SendCommentBoclk(textStr);
            self.commentField.text=NULL;
        }
        
        return NO;
    }
    
    return YES;
}



-(void)textViewDidChange:(UITextView *)textView{
    
    float textViewWidth=textView.frame.size.width;//取得文本框高度
    
    NSString *content=textView.text;
    textStr=content;
    NSDictionary *dict=@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]};
    
    CGSize contentSize=[content sizeWithAttributes:dict];//计算文字长度
    
    float numLine=ceilf(contentSize.width/textViewWidth); //计算当前文字长度对应的行数
    
    if (numLine>10) {
        
        numLine=10;
        
    }
    
    CGFloat heightText = 14;
    
    if (numLine != 0) {
        
        if (numLine>_currentLineNum) {
            
            self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y-heightText*(numLine-_currentLineNum), KscreenWidth, self.frame.size.height+heightText*(numLine-_currentLineNum));
            
            [self.commentField mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.equalTo(@(self.commentField.frame.size.height+heightText*(numLine-_currentLineNum)));
                
            }];
            
            _currentLineNum=numLine;
            
        }else if(numLine<_currentLineNum){
            
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y-heightText*(numLine-_currentLineNum), KscreenWidth, self.frame.size.height+heightText*(numLine-_currentLineNum));
            
            [self.commentField mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.equalTo(@(self.commentField.frame.size.height+heightText*(numLine-_currentLineNum)));
                
            }];
            
            _currentLineNum=numLine;
            
        }
        
    }
    
    
    
    
    
}



@end
