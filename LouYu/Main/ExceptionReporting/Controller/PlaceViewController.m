//
//  PlaceViewController.m
//  LouYu
//
//  Created by barby on 2017/8/3.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "PlaceViewController.h"
#import "PlaceTableViewCell.h"
#import "SectionView.h"
#import "PlaceListModel.h"
#import "PlaceDetailModel.h"


@interface PlaceViewController ()<UITableViewDelegate,UITableViewDataSource,SelectedCellDelegate>
@property(nonatomic,strong)UITableView *mainTableView;
/**
 *   数据源
 */
@property (nonatomic , strong) NSMutableArray *dataArr;

/**
 *  分区头数组
 */
@property (nonatomic , strong) NSMutableArray *sections;

@property (assign, nonatomic) NSIndexPath *selectedIndexPath;//单选，当前选中的行
@property(nonatomic,strong)NSNumber *tokenStr;
@property(nonatomic,strong)PlaceDetailModel *model;
@end

@implementation PlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.section =0;
    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
    [self.view setBackgroundColor:KRGB(211, 211, 211, 1.0)];
       [self setrightBarButtonItemWithImageName:nil andTitle:@"选中"];
    // [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self getToken];
    [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/place/getAllPlaceList"];

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
        //取到articleList
        NSArray *arr= dict[@"content"][@"placeList"];
        self.sections = [NSMutableArray array];
        for (NSDictionary *obj in arr) {
            PlaceListModel *Model=[[PlaceListModel alloc] initWithDict:obj];
            
            // 创建分区头View
            SectionView *sectionView = [[SectionView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 60)];
            sectionView.sectionLable.text=Model.groupName;
            __weak typeof(self)weakSelf = self;
            // 每次点击View , 反传值给Controller, controller该刷新tableView了
            [sectionView setShouldReload:^{
                
                [weakSelf.mainTableView reloadData];
                
            }];
            [self.sections addObject:sectionView];
            
            NSMutableArray *placeArr=[NSMutableArray array];
            for (NSDictionary *obj in Model.place) {
                PlaceDetailModel *model=[[PlaceDetailModel alloc] initWithDict:obj];
                [placeArr addObject:model];
            }
            Model.place=placeArr;
            [self.dataArr addObject:Model];
        }
        [self.view addSubview:self.mainTableView];
        }
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
     //取到每一个分区头View.判断BOOL, 如果为YES 如果为NO 返回0
    
    SectionView *view = self.sections[section];
     PlaceListModel *model=self.dataArr[section];
    if (view.isOpen) {
    
     return model.place.count;
        
    }
    else{
        return 0;
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *PlaceID1=@"PlaceID1";
    PlaceTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:PlaceID1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell==nil) {
        cell=[[PlaceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PlaceID1];
        
    }
    PlaceListModel *Model=self.dataArr[indexPath.section];
    
    PlaceDetailModel *model=Model.place[indexPath.row];
    cell.nameLabel.text=model.placeName;
 
    cell.xlDelegate = self;
    cell.selectedIndexPath = indexPath;
 [cell.selectButton setImage:[UIImage imageNamed:@"btn_normal.png"] forState:UIControlStateNormal];
    
    return cell;
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
                                 [defaults setObject:self.model.placeName forKey:@"KplaceName"];
                                 [defaults setObject:self.model.placeID forKey:@"KplaceID"];
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
    return 40*Height;
}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
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
                PlaceListModel *Model=self.dataArr[indexPath.section];
                self.model=Model.place[indexPath.row];
    
}


- (void)handleSelectedButtonActionWithSelectedIndexPath:(NSIndexPath *)selectedIndexPath {
   
    PlaceTableViewCell *celled = [_mainTableView cellForRowAtIndexPath:_selectedIndexPath];
    celled.accessoryType = UITableViewCellAccessoryNone;
    [celled.selectButton setImage:[UIImage imageNamed:@"btn_normal.png"] forState:UIControlStateNormal];
    celled.xlDelegate = self;
    //记录当前选中的位置索引
    _selectedIndexPath = selectedIndexPath;
    //当前选择的打勾
    PlaceTableViewCell *cell = [_mainTableView cellForRowAtIndexPath:selectedIndexPath];
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [cell.selectButton setImage:[UIImage imageNamed:@"btn_selected.png"] forState:UIControlStateNormal];
    PlaceListModel *Model=self.dataArr[_selectedIndexPath.section];
    self.model=Model.place[_selectedIndexPath.row];
   
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
