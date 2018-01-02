//
//  RegistrationViewController.m
//  LouYu
//
//  Created by barby on 2017/7/28.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "RegistrationViewController.h"
#import "censusTypeListModel.h"
#import "RegistrationListViewController.h"
@interface RegistrationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *registrationTableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSNumber *tokenStr;
//服务器返回的数据存到这个字典里
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;
@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view setUserInteractionEnabled:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
 
    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
   
    [self.view setBackgroundColor:KRGB(211, 211, 211, 1.0)];
    [self setTitle:@"单位户籍化信息"];
     [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self getToken];
    [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/census/getCensusTypeList"];
    
    self.registrationTableView.estimatedRowHeight = 0;
    self.registrationTableView.estimatedSectionHeaderHeight = 0;
    self.registrationTableView.estimatedSectionFooterHeight = 0;
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
//                  NSLog(@"dict:%@",dict);
        if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
            [ClearCache showHUDWithText:@"该账号已在其他设备登录，请重新登录"];
            LoginViewController *logInCV=[[LoginViewController alloc] init];
            [self presentViewController:logInCV animated:YES completion:nil];
        }
        //                NSLog(@"dict:%@",dict);
        else{
                self.InfoDictionary =[NSMutableDictionary dictionaryWithDictionary:dict];
        
               // NSLog(@"self.InfoDictionary :%@",self.InfoDictionary);
                //取到articleList
                NSArray *arr= self.InfoDictionary[@"content"][@"censusTypeList"];
        
                for (NSDictionary *obj in arr) {
                    censusTypeListModel *model=[[censusTypeListModel alloc] initWithDict:obj];
                    [self.dataArr addObject:model];
        
                }
               
                [self.view addSubview:self.registrationTableView];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}






-(UITableView *)registrationTableView{
    if (_registrationTableView ==nil) {
        
        _registrationTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64) style:UITableViewStyleGrouped];
        
        _registrationTableView.showsVerticalScrollIndicator = NO;
        
        [_registrationTableView setBackgroundColor:[UIColor whiteColor]];
        _registrationTableView.dataSource = self;
        _registrationTableView.delegate = self;
        //_XiaoFangTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
    }
    
    return _registrationTableView;
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
    
    
    
    static NSString *regestID=@"regestID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:regestID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:regestID];
    }
    cell .accessoryType  = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    [cell.textLabel setTextColor:KRGB(51, 51, 51, 1.0)];
    //先取到对象
    censusTypeListModel *model=self.dataArr[indexPath.row];
    cell.textLabel.text=model.typeName;

    return cell;
    
    
}

//返回表头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}
//返回单元格行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50*Height;
    
}

//反选  点击的时候灰色 返回来的时候 又变回白色
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    censusTypeListModel *model=self.dataArr[indexPath.row];
    RegistrationListViewController *listCV=[[RegistrationListViewController alloc] init];
    listCV.typeName=model.typeName;
    listCV.typeID=model.typeID;
    listCV.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:listCV animated:NO];
    //newsDetailCV.hidesBottomBarWhenPushed=NO;
    
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
