//
//  FireTestViewController.m
//  LouYu
//
//  Created by barby on 2017/8/7.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "FireTestViewController.h"
#import "TestTypeListModel.h"
#import "TestQuestionViewController.h"
@interface FireTestViewController ()<UITableViewDelegate,UITableViewDataSource >
@property(nonatomic,strong)UITableView *listTableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSNumber *tokenStr;
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;
@property(nonatomic,strong)TestQuestionViewController *testQuestionCV;
@end

@implementation FireTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"考试"];
    // [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self getToken];
    [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/test/getQuestionTypeList"];
    self.listTableView.estimatedRowHeight = 0;
    self.listTableView.estimatedSectionHeaderHeight = 0;
    self.listTableView.estimatedSectionFooterHeight = 0;
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
             [SVProgressHUD showInfoWithStatus:@"该账号已在其他设备登录，请重新登录"];
             [SVProgressHUD dismissWithDelay:1.0];
             LoginViewController *logInCV=[[LoginViewController alloc] init];
             [self presentViewController:logInCV animated:YES completion:nil];
         }
         //                NSLog(@"dict:%@",dict);
         else{
                 self.InfoDictionary =[NSMutableDictionary dictionaryWithDictionary:dict];
         
                 //NSLog(@"self.InfoDictionary :%@",self.InfoDictionary);
                 //取到articleList
                 NSArray *arr= self.InfoDictionary[@"content"][@"testTypeList"];
         
                 for (NSDictionary *obj in arr) {
                     TestTypeListModel *Model=[[TestTypeListModel alloc] initWithDict:obj];
                     [self.dataArr addObject:Model];
                 }
                 
                 [self.view addSubview:self.listTableView];
         }
     } failure:^(NSError *error) {
         NSLog(@"%@",error);
     }];
    
}





-(UITableView *)listTableView{
    if (_listTableView ==nil) {
        
        _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, KscreenWidth, KscreenHeight-64*Height) style:UITableViewStyleGrouped];
        _listTableView.showsVerticalScrollIndicator = NO;
        
        [_listTableView setBackgroundColor:KRGB(245, 245, 245, 1.0)];
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
        //_listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
    }
    
    return _listTableView;
}


-(NSMutableArray *)dataArr{
    if (_dataArr ==nil) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
    
}


#pragma mark - 数据源方法
//设置组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//设置每一组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    static NSString *textID=@"textID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:textID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textID];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
     cell .accessoryType  = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    
    TestTypeListModel *model=self.dataArr[indexPath.row];
    [cell.textLabel setTextColor:KRGB(51, 51, 51, 1.0)];
    [cell.textLabel setFont:[UIFont systemFontOfSize:15.0f]];
    cell.textLabel.text=model.typeName;
    
    
    
    
    return cell;
    
    
}

//返回表头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}



//返回单元格行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40*Height;
    
    
}


//反选  点击的时候灰色 返回来的时候 又变回白色
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TestTypeListModel *model=self.dataArr[indexPath.row];
    
   self.testQuestionCV =[[TestQuestionViewController alloc] init];

    self.testQuestionCV.typeIDNum=model.typeID;
    self.testQuestionCV.typeNameStr=model.typeName;
    [self showAlertController:@"消防基础及常识" andMessage:@"考试开始后，未提交无法退出"];
    }


- (void) showAlertController:(NSString *)title andMessage:(NSString *)msg{
    
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    //设置按钮
    UIAlertAction *action = [UIAlertAction
                             actionWithTitle:@"开始"
                             style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                                 [self.testQuestionCV setHidesBottomBarWhenPushed:YES];
                                 [self.navigationController pushViewController:self.testQuestionCV animated:NO];
                                 
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
