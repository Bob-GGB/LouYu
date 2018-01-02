//
//  InspectionRecordsViewController.m
//  LouYu
//
//  Created by barby on 2017/8/8.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "InspectionRecordsViewController.h"
#import "TimeSelectViewController.h"
#import "InspeceRecordsTableViewCell.h"
#import "PartrolListModel.h"
#import "Inspaction_PlaceViewController.h"
#import "TyPeViewController.h"
@interface InspectionRecordsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)NSNumber *tokenStr;
@property(nonatomic,strong)NSNumber *typeIdNum;
@property(nonatomic,copy)NSString *typeNameStr;

@property(nonatomic,copy)NSString *beganStr;
@property(nonatomic,copy)NSString *EndStr;

@property(nonatomic,strong)UILabel *showLabel;
@property(nonatomic,strong)NSNumber *roleIDNum;
@property(nonatomic,strong) NoDataView *nodataView;

//服务器返回的数据存到这个字典里
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;

//信息数组
@property(nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation InspectionRecordsViewController



-(void)viewWillAppear:(BOOL)animated{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.beganStr=[defaults objectForKey:@"KBeganTime"];
    self.EndStr=[defaults objectForKey:@"KEndTime"];
    self.typeIdNum=[defaults objectForKey:@"KTypeId"];
    self.typeNameStr=[defaults objectForKey:@"KTypeName"];
    //NSLog(@"%@",[defaults objectForKey:@"KTypeName"]);
    
    [self getToken];
    
    if ([self.roleIDNum isEqualToNumber:@3]) {
        [self.view addSubview:[self setUpAllView]];
        [self.mainTableView setFrame:CGRectMake(0, CGRectGetMaxY([self setUpAllView].frame), KscreenWidth, KscreenHeight-64-[self setUpAllView].frame.size.height)];
         [self setrightBarButtonItemWithImageName:nil andTitle:@""];
        
    }
    [self.mainTableView removeFromSuperview];
    [self PostDataToSeverWithUrl: @"http://louyu.qianchengwl.cn/minapp/patrol/getPatrolList"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"巡查记录"];
    [self setrightBarButtonItemWithImageName:nil andTitle:@"日期筛选"];
    // [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];

}


-(UIView *)setUpAllView{
    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 70*Height)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    

    
    NSArray *arr=@[[UIImage imageNamed:@"btn_riqi_default.png-1"],[UIImage imageNamed:@"btn_shaixuan_default.png-1"]];
    
    for (int i=0; i<2; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(i*(KscreenWidth/2+1), 5, KscreenWidth/2-1, 35*Height)];
        btn.tag=101+i;
        [btn setImage:arr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnDidPress:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:btn];
    }
    UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(KscreenWidth/2, 0, 1, 40*Height)];
    [lineView setBackgroundColor:KRGB(240, 240, 240, 1.0f)];
    [backView addSubview:lineView];
         self.showLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,40*Height, KscreenWidth, 30*Height)];
        [ self.showLabel setFont:[UIFont systemFontOfSize:14.0]];
        [ self.showLabel setTextColor:[UIColor blackColor]];
        [self.showLabel setBackgroundColor:KRGB(240, 240, 240, 0.5f)];
    
    if (self.typeNameStr==NULL) {
        [ self.showLabel setTextColor:[UIColor lightGrayColor]];
         self.showLabel.text =@"  类型：请选择巡检类型";
    }
    else
    {
    self.showLabel.text =[NSString stringWithFormat:@"  类型：%@",self.typeNameStr];
    }

       [backView addSubview: self.showLabel];
    
    return backView;
    
}


-(void)btnDidPress:(UIButton *)sender{
    if (sender.tag==101) {
        TimeSelectViewController *timeCV=[[TimeSelectViewController alloc] init];
        [timeCV setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:timeCV animated:NO];
    }
    else{
        
    TyPeViewController  *typeCV=[[TyPeViewController alloc]init];
    [typeCV setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:typeCV animated:NO];
    }

}



-(void)getToken{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[defaults dictionaryForKey:@"UserInfoDic"];
    //取到userInfo
    NSDictionary *userDic=dic[@"content"][@"userInfo"];
    self.tokenStr=userDic[@"token"];
    self.roleIDNum=userDic[@"roleID"];
    
    // NSLog(@"self.tokenStr%@",self.tokenStr);
    
}

/**********************上传json到服务器请求数********************************/
-(void)PostDataToSeverWithUrl:(NSString *)Url{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
   
    if ([self.roleIDNum isEqualToNumber:@3]) {
        if ([defaults valueForKey:@"KcompanyID"]!=NULL && self.typeIdNum !=NULL) {
            [dictionary setObject:[defaults valueForKey:@"KcompanyID"] forKey:@"companyID"];
            [dictionary setValue:self.typeIdNum forKey:@"typeID"];
//            NSLog(@":::%@,:::%@",self.typeIdNum,[defaults valueForKey:@"KcompanyID"]);
        }
        else{
        
//            [dictionary setObject:@2 forKey:@"companyID"];
            [dictionary setValue:self.typeIdNum forKey:@"typeID"];
//            NSLog(@"--%@,--%@",self.typeIdNum,[defaults valueForKey:@"companyID"]);
        }
       
    }
    
//    NSLog(@"kaishi:%@,jiesu:%@",self.beganStr,self.EndStr);
    if (self.beganStr==NULL) {
        //获取当前时间日期
        NSDate *date=[NSDate date];
        NSDateFormatter *format1=[[NSDateFormatter alloc] init];
        [format1 setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr;
        dateStr=[format1 stringFromDate:date];
        [dictionary setValue:dateStr forKey:@"beginDate"];
        [dictionary setValue:dateStr forKey:@"endDate"];
//        NSLog(@"dateStr:%@",dateStr);
        
    }
    else{
    [dictionary setValue:self.beganStr forKey:@"beginDate"];
    [dictionary setValue:self.EndStr forKey:@"endDate"];
    }
    NSLog(@"%@",dictionary);
    [HttpRequest POST:Url  getToken:self.tokenStr paramentDict:dictionary success:^(id responseObj) {
                    //请求成功返回数据；需要转化成字典（即json格式数据）
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
        
//                NSLog(@"%@",dict);
        if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
            [ClearCache showHUDWithText:@"该账号已在其他设备登录，请重新登录"];
            LoginViewController *logInCV=[[LoginViewController alloc] init];
            [self presentViewController:logInCV animated:YES completion:nil];
        }
        //                NSLog(@"dict:%@",dict);
        else{
                if ([dict[@"code"] isEqualToNumber:@(-3)]) {
        
                    [self.mainTableView removeFromSuperview];
                  self.nodataView =[[NoDataView alloc] init];
        
                    [self.view addSubview:self.nodataView];
                }
                else{
                    [ClearCache showHUDWithText:@"数据检索中，请稍后..."];
                    [self.nodataView removeFromSuperview];
                    [self.mainTableView removeFromSuperview];
                    
                    self.InfoDictionary =[NSMutableDictionary dictionaryWithDictionary:dict];
                    NSArray *arr= self.InfoDictionary[@"content"][@"patrolList"];
                    [self.dataArr removeAllObjects];
                    for (NSDictionary *obj in arr) {
                        PartrolListModel *model=[[PartrolListModel alloc] initWithDict:obj];
                        [self.dataArr addObject:model];
                    }
                    
                    
                    
                     [self.view addSubview:self.mainTableView];
                    [self.mainTableView reloadData];
                }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}








-(UITableView *)mainTableView{
    if (_mainTableView==nil) {
    
        
        _mainTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64) style:UITableViewStylePlain];
        //去除分割线
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView setShowsVerticalScrollIndicator:NO];
        [_mainTableView setBackgroundColor:[UIColor whiteColor]];
        [_mainTableView setDelegate:self];
        [_mainTableView setDataSource:self];
        
    }
    
    
    return _mainTableView;
    
}

-(NSMutableArray *)dataArr{

    if (_dataArr==nil) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
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
    
    static NSString *InspeceRecordsID=@"InspeceRecordsID";
    InspeceRecordsTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:InspeceRecordsID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell==nil) {
        cell=[[InspeceRecordsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:InspeceRecordsID];
        
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
   // NSLog(@"self.dataArr.count:%ld",self.dataArr.count);
    if (self.dataArr.count !=0) {
        PartrolListModel *model=self.dataArr[indexPath.row];
        [cell bindDataWithModel:model];
    }
//    else
//        return cell;
    
    return cell;
}
//返回单元格行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170*Height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Inspaction_PlaceViewController *controller=[[Inspaction_PlaceViewController alloc] init];
    PartrolListModel *model=self.dataArr[indexPath.row];
    
    controller.patrolIconStr=model.patrolIcon;
    controller.typeIDNum=model.typeID;
    controller.statusNum=model.status;
   
    if ([model.status isEqualToNumber:@4]) {
        [SVProgressHUD showInfoWithStatus:@"未巡检"];
        [SVProgressHUD dismissWithDelay:0.5];
    }
    else{
     [self.navigationController pushViewController:controller animated:NO];
    }
}






-(void)rightBarButtonDidPress:(UIButton *)sender{

    if ([self.roleIDNum isEqualToNumber:@3]) {
    
    }
    else{
    TimeSelectViewController *timeCV=[[TimeSelectViewController alloc] init];
    [timeCV setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:timeCV animated:NO];
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
