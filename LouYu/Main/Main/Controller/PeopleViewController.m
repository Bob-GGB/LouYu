//
//  PeopleViewController.m
//  LouYu
//
//  Created by barby on 2017/8/23.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "PeopleViewController.h"
#import "PersonnelTableViewCell.h"
#import "UserListModel.h"
#import "ExceptionReportViewController.h"


#define defaultTag 1990
@interface PeopleViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *listTableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSNumber *tokenStr;
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;
@property (nonatomic, assign) NSInteger btnTag;//默认选中的Tag
@property(nonatomic,strong)UserListModel *Model;
@property(nonatomic,strong)NSNumber *roleID;
@property(nonatomic,strong)NSNumber *userID;

@end

@implementation PeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.btnTag = defaultTag+1; //self.btnTag = defaultTag+1  表示默认选择第二个，依次类推
    
    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
    [self.view setBackgroundColor:KRGB(211, 211, 211, 1.0)];
    [self setTitle:@"上报"];
    [self setrightBarButtonItemWithImageName:nil andTitle:@"选中"];
    // [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self getToken];
    if ([self.roleID isEqualToNumber:@2]||[self.roleID isEqualToNumber:@3]) {
        [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/department/getUsualUserList"];
    }
    //   else if ([self.roleID isEqualToNumber:@3]) {
    //        [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/department/getAllPatrolChargeList"];
    //    }
    
    else{
        [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/department/getUserList"];
        
    }
}


-(void)getToken{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[defaults dictionaryForKey:@"UserInfoDic"];
    //取到userInfo
    NSDictionary *userDic=dic[@"content"][@"userInfo"];
    self.tokenStr=userDic[@"token"];
    self.roleID=userDic[@"roleID"];
    
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
        //                NSLog(@"dict:%@",dict);
        else if ([dict[@"code"] isEqualToNumber:@-3]){
            
            [ClearCache showHUDWithText:@"暂无人员"];
        }
        else{
                self.InfoDictionary =[NSMutableDictionary dictionaryWithDictionary:dict];
        
                //        NSLog(@" dict :%@",dict);
                //取到articleList
                NSArray *arr= self.InfoDictionary[@"content"][@"userList"];
        
                for (NSDictionary *obj in arr) {
                    UserListModel *Model=[[UserListModel alloc] initWithDict:obj];
                    [self.dataArr addObject:Model];
                    //            NSLog(@"%@",self.dataArr);
                }
                
                [self.view addSubview:self.listTableView];
        }
        
    } failure:^(NSError *error) {
        
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
    
    
    
    static NSString *personcellID=@"personcellID";
    PersonnelTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:personcellID];
    if (cell==nil) {
        cell=[[PersonnelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:personcellID];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UserListModel *model=self.dataArr[indexPath.row];
    [cell bindDataWithModel:model];
    
    
    cell.selectButton.tag = defaultTag+indexPath.row;
    
    if (cell.selectButton.tag == self.btnTag) {
        cell.isSelect = YES;
        [cell.selectButton setImage:[UIImage imageNamed:@"btn_selected.png"] forState:UIControlStateNormal];
    }else{
        cell.isSelect = NO;
        [cell.selectButton setImage:[UIImage imageNamed:@"btn_normal.png"] forState:UIControlStateNormal];
    }
    __weak PersonnelTableViewCell *weakCell = cell;
    [cell setQhxSelectBlock:^(BOOL choice,NSInteger btnTag){
        if (choice) {
            [weakCell.selectButton setImage:[UIImage imageNamed:@"btn_selected.png"] forState:UIControlStateNormal];
            self.btnTag = btnTag;
            self.Model=self.dataArr[indexPath.row];
            //            NSLog(@"我选的是：%@",self.Model.userName);
            self.userID= self.Model.userID;
            //
            
            [self.listTableView reloadData];
        }
        else{
            //选中一个之后，再次点击，是未选中状态，图片仍然设置为选中的图片，记录下tag，刷新tableView，这个else 也可以注释不用，tag只记录选中的就可以
            [weakCell.selectButton setImage:[UIImage imageNamed:@"btn_selected.png"] forState:UIControlStateNormal];
            self.btnTag = btnTag;
            [self.listTableView reloadData];
            // NSLog(@"#####%ld",(long)btnTag);
        }
    }];
    
    
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
    
    return 50*Height;
    
    
}


-(void)rightBarButtonDidPress:(UIButton *)sender{
    
    [self showAlertController:@"是否确认选中"];
    
}


- (void) showAlertController:(NSString *)msg{
    
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    //设置按钮
    UIAlertAction *action = [UIAlertAction
                             actionWithTitle:@"确定"
                             style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                 
                                 
                                
                                     
                                     
                                     //创建NSUserDefaults的对象 - 单例对象
                                     NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                                     //保存到本地
                                     [defaults setObject:self.Model.userName forKey:@"MUserName"];
                                     [defaults setObject:self.Model.userID forKey:@"MuserID"];
                                     [defaults setObject:self.Model.headImgUrl forKey:@"MheadImgUrl"];
                                     //同步到本地(在某些情况下，数据可能没有保存到本地，用此代码来确保保存到本地)
                                     [defaults synchronize];
                                     //NSLog(@"路径：%@",NSHomeDirectory());
                                     
                                     
                                     [self.navigationController popViewControllerAnimated:NO];
                                     
    
                                 
                                 
                             }];
    UIAlertAction *action1 = [UIAlertAction
                              actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                              handler:nil];
    
    [controller addAction:action];
    [controller addAction:action1];
    
    
    [self presentViewController:controller animated:YES completion:nil];
}


//反选  点击的时候灰色 返回来的时候 又变回白色
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
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