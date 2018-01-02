//
//  ApproveViewController.m
//  LouYu
//
//  Created by barby on 2017/7/21.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "ApproveViewController.h"
#import "DaiwoShenPiTableViewCell.h"
#import "ZFJSegmentedControl.h"
#import "warnStatusModel.h"
#import "DetailViewController.h"
#import "NoDataView.h"
#import "ExceptionSettleViewController.h"
@interface ApproveViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)ZFJSegmentedControl *zvc;
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)NoDataView *nodataViews;
@property(nonatomic,strong)NSNumber *tokenStr;
//服务器返回的数据存到这个字典里
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;
//信息数组
@property(nonatomic,strong)NSMutableArray *warnListArry;

@end

@implementation ApproveViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   [self getToken];
    if ([self.roleIDNum isEqualToNumber:@3]) {
        [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/warn/getDealingWarnList"];
        
    }
    else{
        [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/warn/getHadSubmitWarnList"];
    }
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [AtuoFillScreenUtils autoLayoutFillScreen:self.view];
       self.navigationItem.rightBarButtonItem = nil;
    [self.view setBackgroundColor:KRGB(240, 240, 240, 240)];
    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
    [self getToken];
    //[self creatTableView];
    [self setHeadButtonView];
    [self.nodataViews removeFromSuperview];
    if ([self.roleIDNum isEqualToNumber:@3]) {
    [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/warn/getDealingWarnList"];
        
    }
    else{
    [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/warn/getHadSubmitWarnList"];
    }

}



-(void)setHeadButtonView{

    NSArray *titleArr = @[@"处理中",@"待处理",@"已处理",@"待抄送"];
    NSArray *titileAllArry=@[@"处理中",@"待处理",@"已处理"];
    
    if ([self.roleIDNum isEqualToNumber:@3]) {
        self.zvc = [[ZFJSegmentedControl alloc]initwithTitleArr:titileAllArry iconArr:nil SCType:SCType_Underline];
        self.zvc.selectBtnSpace = 20;//设置按钮间的间距
        self.zvc.selectBtnWID =60*Width;//设置按钮的宽度 不设就是均分
        self.zvc.frame = CGRectMake(0, 35,KscreenWidth-100, 40);
        self.zvc.SCType_Underline_HEI = 2;//设置底部横线的高度
        self.zvc.backgroundColor=[UIColor clearColor];
        self.zvc.selectTitleColor =[UIColor whiteColor];
        self.zvc.titleFont = [UIFont systemFontOfSize:15.0f];
        self.zvc.titleColor=[UIColor whiteColor];

    }
    else{
        self.zvc = [[ZFJSegmentedControl alloc]initwithTitleArr:titleArr iconArr:nil SCType:SCType_Underline];
        self.zvc.selectBtnSpace =2;//设置按钮间的间距
        self.zvc.selectBtnWID =55*Width;//设置按钮的宽度 不设就是均分
        self.zvc.frame = CGRectMake(0, 35,KscreenWidth-100, 40);
        self.zvc.SCType_Underline_HEI = 2;//设置底部横线的高度
        self.zvc.backgroundColor=[UIColor clearColor];
        self.zvc.selectTitleColor =[UIColor whiteColor];
        self.zvc.titleFont = [UIFont systemFontOfSize:14.0f];
        self.zvc.titleColor=[UIColor whiteColor];

    }
        __weak typeof(self)weakSelf=self;
    self.zvc.selectType = ^(NSInteger selectIndex,NSString *selectIndexTitle){
         //NSLog(@"之前selectIndex:%ld",selectIndex);
        [weakSelf.warnListArry removeAllObjects];
        [weakSelf.nodataViews removeFromSuperview];
         [weakSelf.mainTableView removeFromSuperview];
        if ([weakSelf.roleIDNum isEqualToNumber:@3]) {
            
            
            if (selectIndex==0) {
                
               
                
                [weakSelf PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/warn/getDealingWarnList"];
                //[weakSelf creatTableView];
                
            }
            if (selectIndex==1) {
                
                
                
                [weakSelf PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/warn/getUnOfferWarnList"];
                //[weakSelf creatTableView];
                
            }
            if (selectIndex==2) {
               
                [weakSelf PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/warn/getHadDealWarnList"];
                //[weakSelf creatTableView];
            }

        }
        else{
        if (selectIndex==0) {
            
           
          [weakSelf PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/warn/getHadSubmitWarnList"];
            //[weakSelf creatTableView];
        }
        if (selectIndex==1) {
            
            
        
            [weakSelf PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/warn/getUnOfferWarnList"];
            //[weakSelf creatTableView];
            
        }
        if (selectIndex==2) {
           
            [weakSelf PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/warn/getHadDealWarnList"];
            //[weakSelf creatTableView];
        }
            if (selectIndex==3) {
                [weakSelf.nodataViews removeFromSuperview];
                [weakSelf.mainTableView removeFromSuperview];
                [weakSelf PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/warn/getUnCopyWarnList"];
                //[weakSelf creatTableView];
            }
            
        }
            };
    self.navigationItem.titleView=self.zvc;
    



}

-(void)creatTableView{

    self.mainTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64*Height) style:UITableViewStylePlain];
            //去除分割线
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.showsVerticalScrollIndicator=NO;
    self.mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
            [self.mainTableView setBackgroundColor:KRGB(220, 220, 220, 0.5)];
            [self.mainTableView setDelegate:self];
            [self.mainTableView setDataSource:self];
             [self.view addSubview:self.mainTableView];
    
}

-(void)getToken{

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[defaults dictionaryForKey:@"UserInfoDic"];
    //取到userInfo
    NSDictionary *userDic=dic[@"content"][@"userInfo"];
    self.tokenStr=userDic[@"token"];

}

/**********************上传json到服务器请求数********************************/
-(void)PostDataToSeverWithUrl:(NSString *)Url{
    
    [self.nodataViews removeFromSuperview];
    [self.mainTableView removeFromSuperview];
    
   [HttpRequest POST:Url getToken:self.tokenStr paramentDict:nil success:^(id responseObj) {
       
               //请求成功返回数据；需要转化成字典（即json格式数据）
               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
       if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
           [SVProgressHUD showInfoWithStatus:@"该账号已在其他设备登录，请重新登录"];
           [SVProgressHUD dismissWithDelay:1.0];
           LoginViewController *logInCV=[[LoginViewController alloc] init];
           [self presentViewController:logInCV animated:YES completion:nil];
       }
       //                NSLog(@"dict:%@",dict);
       else{
       //        NSLog(@"dict:%@",dict);
               //取到warnList
               if ([dict[@"code"] isEqualToNumber:@(-3)]) {
       
                   [self.mainTableView removeFromSuperview];
                   self.nodataViews =[[NoDataView alloc] init];
       
                   [self.view addSubview:self.nodataViews];
               }
               else{
                  [self.mainTableView removeFromSuperview];
                   [self.nodataViews removeFromSuperview];
                   
       
               self.InfoDictionary =[NSMutableDictionary dictionaryWithDictionary:dict];
               //取到warnList
               NSArray *arr= self.InfoDictionary[@"content"][@"warnList"];
               self.warnListArry=[NSMutableArray array];
               [self.warnListArry removeAllObjects];
               for (NSDictionary *obj in arr) {
                   warnStatusModel *warnStaModel=[[warnStatusModel alloc] initWithDict:obj];
                   [self.warnListArry addObject:warnStaModel];
               }
                   [self.mainTableView removeFromSuperview];
                   [self.nodataViews removeFromSuperview];
               [self.mainTableView reloadData];
               [self creatTableView];
               }
    
       }
       
   } failure:^(NSError *error) {
       NSLog(@"%@",error);
   }];
}




//设置组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//设置每一组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        return self.warnListArry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        static NSString *ShenPiIDs1=@"ShenPiIDs1";
        DaiwoShenPiTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ShenPiIDs1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell==nil) {
            cell=[[DaiwoShenPiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ShenPiIDs1];
            
        }
    
    

    
   // [cell setBackgroundColor:[UIColor greenColor]];
    warnStatusModel *model=self.warnListArry[indexPath.row];
    [cell bindDataWithModel:model];
    
    
    return cell;
}
//返回单元格行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 120*Height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController *controller=[[DetailViewController alloc] init];
    warnStatusModel *model=self.warnListArry[indexPath.row];
    controller.warnIDStr=model.warnID;
    controller.selectIndex=self.zvc.selectIndex;
    controller.RoleID=self.roleIDNum;
//    NSLog(@"---selectIndex:%ld",controller.selectIndex);
    [self.navigationController pushViewController:controller animated:NO];
    
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
