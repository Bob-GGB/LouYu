//
//  SuggestViewController.m
//  LouYu
//
//  Created by barby on 2017/7/25.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "SuggestViewController.h"
#import "RootTabController.h"
#import "PersonListViewController.h"
@interface SuggestViewController ()<UITextViewDelegate>
@property(nonatomic,strong)UITextView *suggestText;
@property(nonatomic,strong)UIButton *sureButton;
@property(nonatomic,strong)UIView *suggestView;
@property(nonatomic,strong)NSNumber *tokenStr;
@property(nonatomic,strong)NSNumber *rolerID;
//服务器返回的数据存到这个字典里
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;

@end

@implementation SuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
    [self.view setBackgroundColor:KRGB(240, 240, 240,0.5)];
    [self setTitle:self.titleNameStr];
// [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self setUptextFieldAndButton];
    
    [self getToken];
    
    
}

-(void)setUptextFieldAndButton{
    
    self.suggestView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 135)];
    [self.suggestView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.suggestView];
    
    self.suggestText=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 135)];
    
    [self.suggestText setFont:[UIFont systemFontOfSize:16.0f]];
    [self.suggestText setBackgroundColor:[UIColor whiteColor]];
    [self.suggestText setScrollEnabled:YES];
    [self.suggestText setDelegate:self];
    self.suggestText.text=@"描述";

    [self.suggestText setTextColor:[UIColor blackColor]];
    [self.suggestView addSubview:self.suggestText];
    self.sureButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.sureButton setFrame:CGRectMake(60,CGRectGetMaxY(self.suggestView.frame)+100, KscreenWidth-120, 30)];
    [self.sureButton setTitle:@"提交" forState:    UIControlStateNormal];
    [self.sureButton.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [self.sureButton setBackgroundImage:[UIImage imageNamed:@"矩形-5"] forState:UIControlStateNormal];
    [self.sureButton.titleLabel setTextColor:[UIColor blackColor]];
    [self.sureButton addTarget:self action:@selector(sureButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sureButton];
    
    
    
}

-(void)sureButtonDidPress:(UIButton *)sender{
    
    [self.suggestText resignFirstResponder];

    if (self.suggestText.text ==NULL||[self.suggestText.text isEqualToString:@"描述"])
    {
         [ClearCache showHUDWithText:@"你还没有输入文字"];
        
    }
    else{
        
        if ([self.rolerID isEqualToNumber:@2]) {
            
            PersonListViewController *listCV=[[PersonListViewController alloc] init];
            
            listCV.noteStr =self.suggestText.text;
            listCV.warnIDnum=self.warnIDNum;
            listCV.titleStr=self.titleNameStr;
            [listCV setHidesBottomBarWhenPushed:YES];
            
            if ([self.titleNameStr isEqualToString:@"提议"]) {
                [self showAlertController:@"确认提交本次提议？"];
            }
            [self.navigationController pushViewController:listCV animated:NO];
            
        }
        else{
            
            [self showAlertController:@"确认提交本次提议？"];
        }

        
       
        
    }
    
    
    
    
}

-(void)getToken{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[defaults dictionaryForKey:@"UserInfoDic"];
    //取到userInfo
    NSDictionary *userDic=dic[@"content"][@"userInfo"];
    self.tokenStr=userDic[@"token"];
    self.rolerID=userDic[@"roleID"];
    
}

/**********************上传json到服务器请求数********************************/
-(void)PostDataToSeverWithUrl:(NSString *)Url{
    

        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:self.warnIDNum forKey:@"warnID"];
        [dictionary setValue:self.suggestText.text forKey:@"note"];
    [HttpRequest POST:Url getToken:self.tokenStr paramentDict:dictionary success:^(id responseObj) {
        //        //请求成功返回数据；需要转化成字典（即json格式数据）
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
                //NSLog(@"responseObject:%@",dict);
        if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
            [ClearCache showHUDWithText:@"该账号已在其他设备登录，请重新登录"];
            LoginViewController *logInCV=[[LoginViewController alloc] init];
            [self presentViewController:logInCV animated:YES completion:nil];
        }
        //                NSLog(@"dict:%@",dict);
        else{
            
            if ([dict[@"code"] isEqualToNumber:@1]) {
                RootTabController *rootCV=[[RootTabController alloc] init];
                [self presentViewController:rootCV animated:NO completion:nil];
            }
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}





#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"描述";
        textView.textColor = [UIColor grayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"描述"]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.suggestText resignFirstResponder];
    
}

- (void) showAlertController:(NSString *)msg{
    
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    //设置按钮
    UIAlertAction *action = [UIAlertAction
                             actionWithTitle:@"确定"
                             style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                 [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/warn/offerWarn"];
                                                              }];
    
    UIAlertAction *action1 = [UIAlertAction
                              actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                              handler:nil];
    
    [controller addAction:action];
    [controller addAction:action1];
    
    
    [self presentViewController:controller animated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
