//
//  ButtonTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/7/25.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "ButtonTableViewCell.h"
#import "SuggestViewController.h"
#import "PersonelViewController.h"
#import "PersonListViewController.h"
@interface ButtonTableViewCell ()
@property(nonatomic,strong)NSNumber *warIdNum;
@property(nonatomic,strong)NSNumber *RoleIdNum;


@end
@implementation ButtonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithWarnID:(NSNumber *)WarnID RoleId:(NSNumber *)RoleId{

    self=[super init];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.warIdNum=WarnID;
        self.RoleIdNum=RoleId;
        
        
        [self setUpUI];
    }
    return self;
}

-(void)setUpUI{

    
   
    
    
    self.ReporteButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.ReporteButton setFrame:CGRectMake(10*Width, 20*Height, (KscreenWidth-40*Width)/3, 40*Height)];
    self.ReporteButton.clipsToBounds=YES;
    self.ReporteButton.layer.cornerRadius=5;
    if ([self.RoleIdNum isEqualToNumber:@2]) {
        [self.ReporteButton setTitle:@"上报" forState:UIControlStateNormal];
        
    }
    if ([self.RoleIdNum isEqualToNumber:@3]) {
        [self.ReporteButton setTitle:@"提议" forState:UIControlStateNormal];
        
    }
    self.ReporteButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [self.ReporteButton setBackgroundImage:[UIImage imageNamed:@"矩形-5"] forState:UIControlStateNormal];
    [self.ReporteButton addTarget:self action:@selector(ReporteButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.ReporteButton setTintColor:[UIColor whiteColor]];

    [self addSubview:self.ReporteButton];
    
    
    if ([self.RoleIdNum isEqualToNumber:@2]) {
        self.sendButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.sendButton setFrame:CGRectMake(CGRectGetMaxX(self.ReporteButton.frame)+10, self.ReporteButton.frame.origin.y, (KscreenWidth-40*Width)/3, 40*Height)];
        self.sendButton.clipsToBounds=YES;
        self.sendButton.layer.cornerRadius=5;
        self.sendButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [self.sendButton setBackgroundImage:[UIImage imageNamed:@"矩形-5"] forState:UIControlStateNormal];
        [self.sendButton addTarget:self action:@selector(sendButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.sendButton setTintColor:[UIColor whiteColor]];
        [self.sendButton setTitle:@"抄送" forState:UIControlStateNormal];
        [self addSubview:self.sendButton];
    }
    
    self.SuggestButton=[UIButton buttonWithType:UIButtonTypeCustom];
    if (self.sendButton.frame.origin.x !=0) {
        [self.SuggestButton setFrame:CGRectMake(CGRectGetMaxX(self.sendButton.frame)+10, self.ReporteButton.frame.origin.y, (KscreenWidth-40*Width)/3, 40)];
    }
    else{
    [self.SuggestButton setFrame:CGRectMake(CGRectGetMaxX(self.ReporteButton.frame)+(KscreenWidth-40*Width)/3+10, self.ReporteButton.frame.origin.y, (KscreenWidth-40*Width)/3, 40)];
    }
    self.SuggestButton.clipsToBounds=YES;
    self.SuggestButton.layer.cornerRadius=5;
    
    if ([self.RoleIdNum isEqualToNumber:@2]) {
        [self.SuggestButton setTitle:@"提议" forState:UIControlStateNormal];
    }
    if ([self.RoleIdNum isEqualToNumber:@3]) {
        [self.SuggestButton setTitle:@"抄送" forState:UIControlStateNormal];
    }

    
    self.SuggestButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [self.SuggestButton setBackgroundImage:[UIImage imageNamed:@"矩形-5"] forState:UIControlStateNormal];
    [self.SuggestButton addTarget:self action:@selector(SuggestButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.SuggestButton setTintColor:[UIColor whiteColor]];
    
    [self addSubview:self.SuggestButton];



}

-(void)ReporteButtonDidPress:(UIButton *)sender{
   
    SuggestViewController *suggestCV=[[SuggestViewController alloc] init];
    suggestCV.warnIDNum=self.warIdNum;
    suggestCV.noteString=self.noteStr;
    if ([self.RoleIdNum isEqualToNumber:@2]) {
        suggestCV.titleNameStr=@"上报";
        //NSLog(@"上报按钮");
    }
    if ([self.RoleIdNum isEqualToNumber:@3]) {
        suggestCV.titleNameStr=@"提议";
        //NSLog(@"提议按钮");
    }
    
    if (self.sendController) {
        self.sendController(suggestCV);
    }
    

   


}

-(void)SuggestButtonDidPress:(UIButton *)sender{
    SuggestViewController *suggestCV=[[SuggestViewController alloc] init];
    PersonListViewController *personListCv=[[PersonListViewController alloc] init];
    suggestCV.warnIDNum=self.warIdNum;
    suggestCV.noteString=self.noteStr;
    
    if ([self.RoleIdNum isEqualToNumber:@2]) {
        suggestCV.titleNameStr=sender.titleLabel.text;
        //NSLog(@"提议按钮");
        if (self.sendController) {
           
            self.sendController(suggestCV);
        }
        
     NSLog(@"提议按钮");
        
    }
    if ([self.RoleIdNum isEqualToNumber:@3]) {
        
        if (self.sendController) {
            personListCv.warnIDnum=self.warIdNum;
            personListCv.titleStr=sender.titleLabel.text;
            self.sendController(personListCv);
        }
        
    }
    

    
}



-(void)sendButtonDidPress:(UIButton *)sender{

PersonListViewController *personListCv=[[PersonListViewController alloc] init];
    if (self.sendController) {
        
        personListCv.warnIDnum=self.warIdNum;
        personListCv.titleStr=sender.titleLabel.text;
        self.sendController(personListCv);
    }

}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
