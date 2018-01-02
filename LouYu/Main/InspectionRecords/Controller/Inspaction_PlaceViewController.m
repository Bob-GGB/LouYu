//
//  Inspaction_PlaceViewController.m
//  LouYu
//
//  Created by mc on 2017/9/13.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "Inspaction_PlaceViewController.h"
#import "GroupListModel.h"
#import "DetailRecordsViewController.h"
@interface Inspaction_PlaceViewController ()<UITableViewDelegate,UITableViewDataSource>;


@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)NSNumber *tokenStr;



//服务器返回的数据存到这个字典里
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;

//信息数组
@property(nonatomic,strong)NSMutableArray *dataArr;



@end

@implementation Inspaction_PlaceViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
    [self setTitle:@"巡检地点选择"];
    // [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor =[UIColor whiteColor];

   
    
    [self getToken];
    
    [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/patrol/getGroupList"];
    
    
    
    
    
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
    
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.typeIDNum forKey:@"typeID"];
    [dictionary setValue:self.patrolIconStr forKey:@"patrolIcon"];
    [dictionary setObject:self.statusNum forKey:@"status"];
//    NSLog(@"%@,%@,%@",self.patrolIconStr,self.typeIDNum,self.statusNum);
    [HttpRequest POST:Url getToken:self.tokenStr paramentDict:dictionary success:^(id responseObj) {
        
        //请求成功返回数据；需要转化成字典（即json格式数据）
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"%@",dict);
        
        if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
            [ClearCache showHUDWithText:@"该账号已在其他设备登录，请重新登录"];
            LoginViewController *logInCV=[[LoginViewController alloc] init];
            [self presentViewController:logInCV animated:YES completion:nil];
            
        }
        else{
            self.InfoDictionary =[NSMutableDictionary dictionaryWithDictionary:dict];
            //NSLog(@"%@",self.InfoDictionary[@"content"][@"onePatrolList"]);
            NSArray *arr= self.InfoDictionary[@"content"][@"groupList"];
            [self.dataArr removeAllObjects];
            for (NSDictionary *obj in arr) {
                GroupListModel *model=[[GroupListModel alloc] initWithDict:obj];
                [self.dataArr addObject:model];
               
            }
            [self.mainTableView removeFromSuperview];
           
            [self creatTableView];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}













-(void)creatTableView{
    
    self.mainTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64) style:UITableViewStylePlain];
    //去除分割线
//    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.mainTableView setBackgroundColor:[UIColor whiteColor]];
    [self.mainTableView setShowsVerticalScrollIndicator:NO];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    [self.view addSubview:self.mainTableView];
    //[self.mainTableView setScrollEnabled:NO];
    
    
}

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
    
    static NSString *InspactionCEll=@"InspactionCEll";
    // DetailRecordsTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:DetailRecordsID1];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];//根据indexPath准确地取出一行，而不是从cell重用队列中取出
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:InspactionCEll];
        
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    GroupListModel *model=self.dataArr[indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:16.0f];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:16.0f];
    cell.textLabel.text=model.groupName;
    cell.detailTextLabel.text=model.statusText;
    if ([model.status isEqualToNumber:@2]||[model.status isEqualToNumber:@5]) {
        cell.detailTextLabel.textColor=KRGB(252, 58, 81, 1.0);
    }
    else if ([model.status isEqualToNumber:@1]){
         cell.detailTextLabel.textColor=KRGB(104, 173, 255, 1.0);
        
    }
    else if ([model.status isEqualToNumber:@3]){
        cell.detailTextLabel.textColor=KRGB(85, 170, 119, 1.0);
        
    }
    else{
    cell.detailTextLabel.textColor=KRGB(151, 151, 151, 1.0);
    }
    
    
    
    
    
    return cell;
}

-(NSMutableArray *)dataArr{
    
    if (_dataArr==nil) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}



//返回单元格行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50*Height;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1f;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //TimeSelectTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GroupListModel *model=self.dataArr[indexPath.row];
    
    DetailRecordsViewController *DCV=[[DetailRecordsViewController alloc] init];
    DCV.patrolIconStr=self.patrolIconStr;
    DCV.typeIdNum=self.typeIDNum;
    DCV.groupIDNum=model.groupID;
    if ([model.status isEqualToNumber:@1]||[model.status isEqualToNumber:@2]||[model.status isEqualToNumber:@3 ]||[model.status isEqualToNumber:@5]) {
        [DCV setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:DCV animated:NO];
    }
    
    
    
    
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
