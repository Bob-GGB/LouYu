//
//  RegistrationListViewController.m
//  LouYu
//
//  Created by barby on 2017/7/28.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "RegistrationListViewController.h"
#import "RegistrationListTableViewCell.h"
#import "censusListModel.h"
#import "RegistrationDetailViewController.h"
#import "NoDataView.h"
@interface RegistrationListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *listTableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSNumber *tokenStr;
//服务器返回的数据存到这个字典里
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;
@property(nonatomic,strong)NoDataView *nodataView;
@end

@implementation RegistrationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
    
//    [self.view setBackgroundColor:KRGB(211, 211, 211, 1.0)];
    self.title=self.typeName;
    // [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self getToken];
    [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/census/getCensusList"];
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
    
}

/**********************上传json到服务器请求数********************************/
-(void)PostDataToSeverWithUrl:(NSString *)Url{
    
//    [self.nodataView removeFromSuperview];
//    [self.listTableView removeFromSuperview];
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:self.typeID forKey:@"typeID"];
    [HttpRequest POST:Url getToken:self.tokenStr paramentDict:dictionary success:^(id responseObj) {
        
                //请求成功返回数据；需要转化成字典（即json格式数据）
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
//                                NSLog(@"dict:%@",dict);
        if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
            [ClearCache showHUDWithText:@"该账号已在其他设备登录，请重新登录"];
            LoginViewController *logInCV=[[LoginViewController alloc] init];
            [self presentViewController:logInCV animated:YES completion:nil];
        }

        else{
            if ([dict[@"code"] isEqualToNumber:@(-3)]) {
                
                [self.listTableView removeFromSuperview];
                self.nodataView =[[NoDataView alloc] init];
                
                [self.view addSubview:self.nodataView];
            }
            else{
                
                [self.nodataView removeFromSuperview];
                [self.listTableView removeFromSuperview];
            
                self.InfoDictionary =[NSMutableDictionary dictionaryWithDictionary:dict];
        
                //取到articleList
                NSArray *arr= self.InfoDictionary[@"content"][@"censusList"];
        
                for (NSDictionary *obj in arr) {
                    censusListModel *model=[[censusListModel alloc] initWithDict:obj];
                    [self.dataArr addObject:model];
        
                }
                
                [self.view addSubview:self.listTableView];
            }
        }
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];
}












-(UITableView *)listTableView{
    if (_listTableView ==nil) {
        
        _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64*Height) style:UITableViewStyleGrouped];
//        _listTableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
        _listTableView.showsVerticalScrollIndicator = NO;
        
        [_listTableView setBackgroundColor:[UIColor whiteColor]];
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
        //_XiaoFangTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
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
    
    
    
    static NSString *ListID=@"ListID";
    RegistrationListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ListID];
    if (cell==nil) {
        cell=[[RegistrationListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListID];
    }
    censusListModel *model=self.dataArr[indexPath.row];
    [cell bindDataWithModel:model];
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
    
    return 95*Height;
    
}
//反选  点击的时候灰色 返回来的时候 又变回白色
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    censusListModel *model=self.dataArr[indexPath.row];
    RegistrationDetailViewController *DetailCV=[[RegistrationDetailViewController alloc] init];
    DetailCV.censusID=model.censusID;
    DetailCV.titleStr=self.typeName;
    DetailCV.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:DetailCV animated:NO];
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
