//
//  SendButtonView.m
//  LouYu
//
//  Created by barby on 2017/8/16.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "SendButtonView.h"
#import "CopySendViewController.h"
#import "PersonListViewController.h"
@interface SendButtonView ()

@property(nonatomic,strong)NSNumber *warIdNum;
@property(nonatomic,strong)NSNumber *RoleIdNum;
@end

@implementation SendButtonView


-(instancetype)initWithWarnID:(NSNumber *)WarnID RoleId:(NSNumber *)RoleId{

    self=[super init];
    if (self) {
        self.warIdNum=WarnID;
        self.RoleIdNum=RoleId;
        [self setAllUIView];
    }
    return self;
}


-(void)setAllUIView{
    self.sendButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setFrame:CGRectMake(KscreenWidth/2-50*Width, 10*Height, 100*Width, 30*Height)];
    [self.sendButton setBackgroundColor:KRGB(30, 144, 255, 1.0)];
    [self.sendButton setTitle:@"抄送" forState:UIControlStateNormal];
    [self.sendButton.layer setCornerRadius:5];
    [self.sendButton.layer setMasksToBounds:YES];
    [self.sendButton.titleLabel setTextColor:[UIColor whiteColor]];
    [self.sendButton addTarget:self action:@selector(sendButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.sendButton];

}

-(void)sendButtonDidPress:(UIButton *)sender{
    
    PersonListViewController *personCv=[[PersonListViewController alloc] init];
    CopySendViewController *copyCv=[[CopySendViewController alloc] init];
    
    if ([self.RoleIdNum isEqualToNumber:@1]) {
        if (self.sendController) {
            copyCv.warnId=self.warIdNum;
            self.sendController(copyCv);
        }
    }
    if ([self.RoleIdNum isEqualToNumber:@2]||[self.RoleIdNum isEqualToNumber:@3]) {
        if (self.sendController) {
            personCv.warnIDnum=self.warIdNum;
            personCv.titleStr=sender.titleLabel.text;
            self.sendController(personCv);
        }
    }
    

}

@end
