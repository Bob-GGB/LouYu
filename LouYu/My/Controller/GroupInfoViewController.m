//
//  GroupInfoViewController.m
//  LouYu
//
//  Created by barby on 2017/8/5.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "GroupInfoViewController.h"
#import "PlaceTableViewCell.h"
#import "TypeListModel.h"

#define defaultTag 1990
@interface GroupInfoViewController ()<UITableViewDelegate,UITableViewDataSource,SelectedCellDelegate>
@property(nonatomic,strong)UITableView *listTableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSNumber *tokenStr;
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;

@property(nonatomic,strong)TypeListModel *typeModel;

@property (assign, nonatomic) NSIndexPath *selectedIndexPath;//单选，当前选中的行
//@property(nonatomic,strong)UserListModel *Model;
@end

@implementation GroupInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.btnTag = defaultTag+1; //self.btnTag = defaultTag+1  表示默认选择第二个，依次类推
    
    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
    [self.view setBackgroundColor:KRGB(211, 211, 211, 1.0)];
    self.title=@"个人设置";
    [self setrightBarButtonItemWithImageName:nil andTitle:@"保存"];
    // [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self getToken];
    
    [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/type/getTypeList"];
    
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
            [ClearCache showHUDWithText:@"该账号已在其他设备登录，请重新登录"];
            LoginViewController *logInCV=[[LoginViewController alloc] init];
            [self presentViewController:logInCV animated:YES completion:nil];
        }
        //                NSLog(@"dict:%@",dict);
        else{
                self.InfoDictionary =[NSMutableDictionary dictionaryWithDictionary:dict];
        
                //NSLog(@"self.InfoDictionary :%@",dict);
                //取到articleList
                NSArray *arr= self.InfoDictionary[@"content"][@"typeList"];
        
                for (NSDictionary *obj in arr) {
                    TypeListModel *Model=[[TypeListModel alloc] initWithDict:obj];
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
    
    
    
    static NSString *GroupID=@"GroupID";
    PlaceTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:GroupID];
    if (cell==nil) {
        cell=[[PlaceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupID];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    TypeListModel *model=self.dataArr[indexPath.row];
    cell.nameLabel.text=model.typeName;
    cell.xlDelegate = self;
    cell.selectedIndexPath = indexPath;
    [cell.selectButton setImage:[UIImage imageNamed:@"btn_normal.png"] forState:UIControlStateNormal];

    
   

    
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
                                 [defaults setObject:self.typeModel.typeName forKey:@"MtypeName"];
                                 [defaults setObject:self.typeModel.typeID forKey:@"MtypeID"];
//                                 [defaults setObject:self.DepartModel.number forKey:@"Knumber"];
                                 //同步到本地(在某些情况下，数据可能没有保存到本地，用此代码来确保保存到本地)
                                 [defaults synchronize];
                                 //NSLog(@"路径：%@",NSHomeDirectory());
                                 
                                 [self postChangeGroupToSeVerWithUrl:@"http://louyu.qianchengwl.cn/minapp/user/typeChange"];
                                 
                                 
                                 
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
    
    PlaceTableViewCell *cell=[tableView cellForRowAtIndexPath:_selectedIndexPath];
    [cell.selectButton setImage:[UIImage imageNamed:@"btn_normal.png"] forState:UIControlStateNormal];
    cell.xlDelegate = self;
    cell.selectedIndexPath = indexPath;
    //记录当前选中的位置索引
    _selectedIndexPath = indexPath;
    //当前选择的打勾
    PlaceTableViewCell *cells = [tableView cellForRowAtIndexPath:indexPath];
    [cells.selectButton setImage:[UIImage imageNamed:@"btn_selected.png"] forState:UIControlStateNormal];
                self.typeModel=self.dataArr[indexPath.row];
    
}


- (void)handleSelectedButtonActionWithSelectedIndexPath:(NSIndexPath *)selectedIndexPath {
    
    PlaceTableViewCell *celled = [_listTableView cellForRowAtIndexPath:_selectedIndexPath];
    celled.accessoryType = UITableViewCellAccessoryNone;
    [celled.selectButton setImage:[UIImage imageNamed:@"btn_normal.png"] forState:UIControlStateNormal];
    celled.xlDelegate = self;
    //记录当前选中的位置索引
    _selectedIndexPath = selectedIndexPath;
    //当前选择的打勾
    PlaceTableViewCell *cell = [_listTableView cellForRowAtIndexPath:selectedIndexPath];
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [cell.selectButton setImage:[UIImage imageNamed:@"btn_selected.png"] forState:UIControlStateNormal];
                self.typeModel=self.dataArr[_selectedIndexPath.row];
    
}


-(void)postChangeGroupToSeVerWithUrl:(NSString *)Url{

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setValue:[defaults valueForKey:@"MtypeID"] forKey:@"typeID"];
    [HttpRequest POST:Url getToken:self.tokenStr paramentDict:dictionary success:^(id responseObj) {
        
        //请求成功返回数据；需要转化成字典（即json格式数据）
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"%@",dict);
        if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
            [ClearCache showHUDWithText:@"该账号已在其他设备登录，请重新登录"];
            LoginViewController *logInCV=[[LoginViewController alloc] init];
            [self presentViewController:logInCV animated:YES completion:nil];
        }
        //                NSLog(@"dict:%@",dict);
        else{
            if ([dict[@"code"] isEqualToNumber:@1]) {
                
                [ClearCache showHUDWithText:@"保存成功"];
                
                //创建NSUserDefaults的对象 - 单例对象
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                //保存到本地
                [defaults setObject:dict[@"content"][@"userInfo"][0][@"userRoleInfo"] forKey:@"KuserRoleInfo"];
                [defaults synchronize];
                
                //NSLog(@"---%@",dict[@"content"][@"userInfo"][0][@"userRoleInfo"]);
                
                [self.navigationController popViewControllerAnimated:NO];
            }
            else{
                 [ClearCache showHUDWithText:@"保存失败"];
                 [self.navigationController popViewControllerAnimated:NO];
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
