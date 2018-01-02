//
//  TyPeViewController.m
//  LouYu
//
//  Created by barby on 2017/8/9.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "TyPeViewController.h"
#import "TypeListModel.h"
@interface TyPeViewController ()
@property(nonatomic,strong)UIButton *selectButton;
@property(nonatomic,strong)NSMutableArray *dataArr;

@property(nonatomic,strong)NSNumber *tokenStr;
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;

@property(nonatomic,strong)NSNumber *typeId;
@property(nonatomic,copy)NSString *typeNameStr;

@end

@implementation TyPeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
    [self setTitle:@"类型"];
    // [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor =[UIColor whiteColor];
    
    [self getToken];
    [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/type/getTypeList"];
    
    [self creatButtonView];
    
}

-(NSMutableArray *)dataArr{
    if (_dataArr==nil) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}

-(void)creatButtonView{

    
    NSArray *arr=@[[UIImage imageNamed:@"quxiao.png"],[UIImage imageNamed:@"queding.png"]];
    
    for (int i=0; i<2; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame: CGRectMake((KscreenWidth/2)*i, (KscreenHeight-64-46)*Height, KscreenWidth/2, 49*Height)];
        button.tag=i+101;
        [button setImage:arr[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonDidPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        
    }
    
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40*Width, 15*Height)];
    [imageView setImage:[UIImage imageNamed:@"msg_default.png"]];
    [self.view addSubview:imageView];




}


-(void)buttonDidPress:(UIButton *)sender{
    if (sender.tag==102) {
        
        NSUserDefaults *Defaults=[NSUserDefaults standardUserDefaults];
        [Defaults removeObjectForKey:@"KTypeId"];
        [Defaults setObject: self.typeId forKey:@"KTypeId"];
        [Defaults setObject:self.typeNameStr forKey:@"KTypeName"];
        [Defaults synchronize];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
    [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)clickedBtnWith:(UIButton *)btn{
   // 单选
        if(_selectButton== btn) {
            //上次点击过的按钮，不做处理
        } else{
            //本次点击的按钮设为红色
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:KRGB(30, 144, 255, 0.5)];
            //将上次点击过的按钮设为黑色
            [_selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_selectButton setBackgroundColor:KRGB(240, 240, 240,1.0)];
        }
        _selectButton = btn;
    
    self.typeNameStr=btn.titleLabel.text;
    
   // NSLog(@"typeNameStr:%@",typeNameStr);
    self.typeId=[NSNumber numberWithInteger:(long)btn.tag - 101];
    
   
    
}



-(void)getToken{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[defaults dictionaryForKey:@"UserInfoDic"];
    //取到userInfo
    NSDictionary *userDic=dic[@"content"][@"userInfo"];
    self.tokenStr=userDic[@"token"];
    // NSLog(@"self.tokenStr%@",self.tokenStr);
    
}

/**********************上传json到服务器请求数********************************/
-(void)PostDataToSeverWithUrl:(NSString *)Url{
    

    [HttpRequest POST:Url getToken:self.tokenStr paramentDict:nil success:^(id responseObj) {
        
                //请求成功返回数据；需要转化成字典（即json格式数据）
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
        if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
            [ClearCache showHUDWithText:@"该账号已在其他设备登录，请重新登录"];
            LoginViewController *logInCV=[[LoginViewController alloc] init];
            [self presentViewController:logInCV animated:YES completion:nil];
            
        }
        else{

                self.InfoDictionary =[NSMutableDictionary dictionaryWithDictionary:dict];
        
                //NSLog(@"self.InfoDictionary :%@",self.InfoDictionary);
                //取到articleList
                NSArray *arr= self.InfoDictionary[@"content"][@"typeList"];
        
                for (NSDictionary *obj in arr) {
                    TypeListModel *Model=[[TypeListModel alloc] initWithDict:obj];
                    [self.dataArr addObject:Model];
        
                }
                for (int i = 0; i < self.dataArr.count; i++) {
        
                    TypeListModel *model=self.dataArr[i];
                    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.backgroundColor = [UIColor groupTableViewBackgroundColor];
                     [btn setTitle:model.typeName forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                     btn.tag = [model.typeID intValue] + 101;
                    [btn addTarget:self action:@selector(clickedBtnWith:) forControlEvents:UIControlEventTouchUpInside];
        
                    if (i%2==0) {
        
                        btn.frame = CGRectMake(20, (i/2) * 70+50, (KscreenWidth-60)/2, 50);
                    }
                    else{
                        btn.frame = CGRectMake(20+((KscreenWidth-60)/2+20), (i/2) * 70+50, (KscreenWidth-60)/2, 50);
                        
                    }
                    
                    
                    [self.view addSubview:btn];
                    self.selectButton = btn;
                }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
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
