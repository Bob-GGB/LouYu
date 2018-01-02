//
//  DDetailRecordsViewController.m
//  LouYu
//
//  Created by barby on 2017/8/9.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "DDetailRecordsViewController.h"
#import "SectionView.h"
#import "DDetailRecordTableViewCell.h"
#import "PlaceContentListModel.h"
#import "ContentDetailModel.h"
#import "DetailViewController.h"
#define defaultTag 1990
@interface DDetailRecordsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
/**
 *   数据源
 */
@property (nonatomic , strong) NSMutableArray *dataArr;

/**
 *  分区头数组
 */
@property (nonatomic , strong) NSMutableArray *sections;

@property (nonatomic, assign) NSInteger btnTag;//默认选中的Tag

@property(nonatomic,strong)NSNumber *tokenStr;
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;

@end
@implementation DDetailRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
    [self setTitle:@"详情"];
    // [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor =[UIColor whiteColor];
    [self getToken];
    [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/patrol/getOnePatrolPlaceContent"];
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
    [dictionary setValue:self.partolIDNum forKey:@"patrolID"];
    
    
    [HttpRequest POST:Url getToken:self.tokenStr paramentDict:dictionary success:^(id responseObj) {
        
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
                NSArray *arr= self.InfoDictionary[@"content"][@"placeContentList"];
        
                self.sections = [NSMutableArray array];
                for (NSDictionary *obj in arr) {
                    PlaceContentListModel *Model=[[PlaceContentListModel alloc] initWithDict:obj];
                   // NSLog(@"Model.className%@",Model.className);
        
                    NSArray *placeArr=Model.content;
                    for (NSDictionary *obj in placeArr) {
                        ContentDetailModel *model=[[ContentDetailModel alloc] initWithDict:obj];
                        [self.dataArr addObject:model];
        
                    }
                    // 创建分区头View
                    SectionView *sectionView = [[SectionView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 60)];
        
                    sectionView.sectionLable.text=Model.className;
        
                    __weak typeof(self)weakSelf = self;
        
        
                    // 每次点击View , 反传值给Controller, controller该刷新tableView了
                    [sectionView setShouldReload:^{
        
                        [weakSelf.mainTableView reloadData];
                        
                    }];
                    
                    
                    [self.sections addObject:sectionView];
                    
                }
        }
                [self.view addSubview:self.mainTableView];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}










-(UITableView *)mainTableView{
    
    if (_mainTableView==nil) {
        _mainTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64*Height) style:UITableViewStylePlain];
        //去除多余cell
         _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //[self.mainTableView setBackgroundColor:KRGB(220, 220, 220, 0.5)];
        [_mainTableView setDelegate:self];
        [_mainTableView setDataSource:self];
    }
    return _mainTableView;
}


- (NSMutableArray *)dataArr{
    
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
        
        
    }
    
    return _dataArr;
    
}



//设置组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
}

//设置每一组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 取到每一个分区头View.判断BOOL, 如果为YES 如果为NO 返回0
    
    SectionView *view = self.sections[section];
    
    if (view.isOpen) {
        return [self.dataArr count];
        
    }
    else{
        return 0;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *DDetailRecord=@"DDetailRecord";
    DDetailRecordTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:DDetailRecord];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell==nil) {
        cell=[[DDetailRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DDetailRecord];
    }
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    ContentDetailModel *model=self.dataArr[indexPath.row];
    cell.nameLabel.text=model.contentName;
    cell.statuLabel.text=model.statusText;
    //后台给的warnId判断异常 有问题
//    if ([model.warnID isEqualToNumber:@221]) {
//        cell.statuLabel.textColor =[UIColor redColor];
//        cell.statuLabel.layer.borderColor=[UIColor redColor].CGColor;
//    }
//    if ([model.statusText isEqualToString:@"异常"]) {
//                cell.statuLabel.textColor =[UIColor redColor];
//                cell.statuLabel.layer.borderColor=[UIColor redColor].CGColor;
//
//    }
    
    NSString *str = @"异常";
    if ([model.statusText rangeOfString:str].location != NSNotFound) {
                        cell.statuLabel.textColor =[UIColor redColor];
                        cell.statuLabel.layer.borderColor=[UIColor redColor].CGColor;

    }
    else{
    
        cell.statuLabel.textColor= KRGB(104, 173, 255, 1.0);
        cell.statuLabel.layer.borderColor=KRGB(104, 173, 255, 1.0).CGColor;
    }
    
    
    return cell;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return self.sections[section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40*Height;
}

//返回单元格行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50*Height;
}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     ContentDetailModel *model=self.dataArr[indexPath.row];
    DetailViewController *detailCV=[[DetailViewController alloc] init];
    if ([model.warnID isEqualToNumber:@0]) {
        
        [SVProgressHUD showInfoWithStatus:@"正常"];
        [SVProgressHUD dismissWithDelay:0.5f];
        
            }
    
    else{
    
        detailCV.warnIDStr=model.warnID;
        [detailCV setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailCV animated:NO];
    
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
