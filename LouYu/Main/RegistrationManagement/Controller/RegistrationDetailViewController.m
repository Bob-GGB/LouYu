//
//  RegistrationDetailViewController.m
//  LouYu
//
//  Created by barby on 2017/7/28.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "RegistrationDetailViewController.h"
#import "TimeTableViewCell.h"
#import "UserTableViewCell.h"
#import "TextDescriptionTableViewCell.h"
#import "PhotosTableViewCell.h"
#import "NoteTableViewCell.h"
#import "RecordDetailModel.h"
#import "XWScanImage.h"
#import "NSArray+Safe.h"

@interface RegistrationDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *detailTableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSArray *userNameArr;
@property(nonatomic,strong)NSArray *photosArr;
@property(nonatomic,strong)NSNumber *tokenStr;
@property(nonatomic,strong)RecordDetailModel *model;
@property (nonatomic, strong) NSMutableArray *heightArray;
@property (nonatomic, strong) NSMutableArray *heightnoteArray;
//服务器返回的数据存到这个字典里
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;

@end

@implementation RegistrationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
    [self.view setBackgroundColor:KRGB(211, 211, 211, 1.0)];
    self.title=self.titleStr;
    // [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self getToken];
     [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/census/getOneRecordDetail"];
    self.detailTableView.estimatedRowHeight = 0;
    self.detailTableView.estimatedSectionHeaderHeight = 0;
    self.detailTableView.estimatedSectionFooterHeight = 0;
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
    
 
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:self.censusID forKey:@"censusID"];
  [HttpRequest POST:Url getToken:self.tokenStr paramentDict:dictionary success:^(id responseObj) {
      
              //请求成功返回数据；需要转化成字典（即json格式数据）
              NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
      //NSLog(@"dict:%@",dict);

      
      if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
          [SVProgressHUD showInfoWithStatus:@"该账号已在其他设备登录，请重新登录"];
          [SVProgressHUD dismissWithDelay:1.0];
          LoginViewController *logInCV=[[LoginViewController alloc] init];
          [self presentViewController:logInCV animated:YES completion:nil];
      }
      else{
          
         
              self.InfoDictionary =[NSMutableDictionary dictionaryWithDictionary:dict];
      //        NSLog(@"self.InfoDictionary::::%@",self.InfoDictionary);
              self.model=[[RecordDetailModel alloc] initWithDict:self.InfoDictionary[@"content"][@"recordDetail"]];
      
             // NSLog(@"self.model.photo::::%@",self.model.photo);
              [self.detailTableView removeFromSuperview];
              [self.view addSubview:self.detailTableView];
          
      }
      
  } failure:^(NSError *error) {
      NSLog(@"%@",error);
  }];
    
}






-(UITableView *)detailTableView{
    if (_detailTableView ==nil) {
        
        _detailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64*Height) style:UITableViewStylePlain];
        _detailTableView.showsVerticalScrollIndicator = NO;
        _detailTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_detailTableView setBackgroundColor:[UIColor whiteColor]];
        _detailTableView.dataSource = self;
        _detailTableView.delegate = self;
        //_XiaoFangTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
    }
    
    return _detailTableView;
}

-(NSMutableArray *)dataArr{
    if (_dataArr ==nil) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
    
}
-(NSArray *)userNameArr{
    if (_userNameArr ==nil) {
        _userNameArr=[NSArray array];
    }
    return _userNameArr;
    
}
-(NSArray *)photosArr{
    if (_photosArr ==nil) {
        _photosArr=[NSArray array];
    }
    return _photosArr;
    
}
- (NSMutableArray *)heightArray{
    if (!_heightArray) {
        _heightArray = @[].mutableCopy;
    }
    return _heightArray;
}
#pragma mark - 数据源方法
//设置组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
//设置每一组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        static NSString *TimeID=@"TimeID";
        TimeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:TimeID];
        if (cell==nil) {
            cell=[[TimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TimeID];
        }
        cell.trainingtimeLable.text=self.model.trainingtime;
        return cell;

    }
    else if (indexPath.section==1){
    
        static NSString *UserID=@"UserID";
        UserTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:UserID];
        if (cell==nil) {
            cell=[[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UserID];
        }
        NSString *str=[NSString stringWithFormat:@"%@",self.model.userName];
        cell.userNameLabel.text=str;
        return cell;

    
    }
    else if (indexPath.section==2){
        
        static NSString *TextDescriptionID=@"TextDescriptionID";
        TextDescriptionTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:TextDescriptionID];
        if (cell==nil) {
            cell=[[TextDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextDescriptionID];
        }
        CGRect fcRect = [self.model.textDescription boundingRectWithSize:CGSizeMake(KscreenWidth-cell.descripLabel.frame.size.width-10-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
        cell.textDescriptionLabel.frame =CGRectMake(CGRectGetMaxX(cell.descripLabel.frame)+20, 10, KscreenWidth-cell.descripLabel.frame.size.width-10-20, fcRect.size.height);
        cell.textDescriptionLabel.text=self.model.textDescription;
        return cell;
        
        
    }
    
    else if (indexPath.section==3){
        
        static NSString *PhotosID=@"PhotosID";
        PhotosTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:PhotosID];
        if (cell==nil) {
            cell=[[PhotosTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PhotosID];
        }
//        NSString *photoStr=[NSString stringWithFormat:@"%@",self.model.photo];
//        [cell bindDataWithModel:self.model.photo[]];
        for (int i=0; i<self.model.photo.count; i++) {
            
            cell.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(110 + 10) +10,CGRectGetMaxY(cell.photoLabel.frame)+10,110 , 120)];
            cell.photoImageView.tag = i;//这句话不写等于废了
            // [self.WarnImageView setBackgroundColor:[UIColor redColor]];
            [cell.photoImageView sd_setImageWithURL:self.model.photo[i]];
            [cell addSubview:cell.photoImageView];
            
            //为UIImageView1添加点击事件
            UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick1:)];
            [cell.photoImageView addGestureRecognizer:tapGestureRecognizer1];
            //让UIImageView和它的父类开启用户交互属性
            [cell.photoImageView setUserInteractionEnabled:YES];
        }

        return cell;
        
        
    }
    else if (indexPath.section==4){
        
        static NSString *NoteID=@"NoteID";
        NoteTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NoteID];
        if (cell==nil) {
            cell=[[NoteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NoteID];
        }
        
        cell.noteLabel.text=self.model.note;
        return cell;
        
        
    }
    
   else
       return nil;
    
    
}

////返回表头高度
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.1f;
//}
//返回单元格行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0||indexPath.section==1) {
        return 45;
    }
     else if (indexPath.section==2) {
        
//       CGRect fcRect = [self.model.textDescription boundingRectWithSize:CGSizeMake(KscreenWidth-150-10-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
//        return fcRect.size.height;
         NSNumber *cellHeight = [self.heightArray h_safeObjectAtIndex:indexPath.row];
         if (cellHeight) {
             //NSLog(@"不用计算，直接返回行高了");
             return [cellHeight floatValue];
         }else{
             NSString *status = self.model.textDescription;
             CGFloat statusHeight = [TextDescriptionTableViewCell tableView:tableView rowHeightForObject:status];
             CGFloat iconHeight = 20;
             [self.heightArray addObject:@(statusHeight + iconHeight)];
            // NSLog(@"第一次加载计算一次，每次展示都计算一次");
             return statusHeight + iconHeight;

         }
    }
    else if (indexPath.section==3){
    
        return 160;
    }
    else if (indexPath.section==4){
        self.heightnoteArray=[NSMutableArray array];
        NSNumber *cellHeight = [self.heightnoteArray h_safeObjectAtIndex:indexPath.row];
        if (cellHeight) {
            NSLog(@"%f",[cellHeight floatValue]);
            return [cellHeight floatValue];
        }else{
            NSString *status = self.model.note;
            CGFloat statusHeight = [TextDescriptionTableViewCell tableView:tableView rowHeightForObject:status];
            CGFloat iconHeight = 20;
            [self.heightnoteArray addObject:@(statusHeight + iconHeight)];
            // NSLog(@"第一次加载计算一次，每次展示都计算一次");
            return statusHeight + iconHeight;
        }

    }
    else return 0;
}


//反选  点击的时候灰色 返回来的时候 又变回白色
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    censusListModel *model=self.dataArr[indexPath.row];
//    RegistrationDetailViewController *DetailCV=[[RegistrationDetailViewController alloc] init];
//    DetailCV.censusID=model.censusID;
//    DetailCV.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:DetailCV animated:YES];
//    //newsDetailCV.hidesBottomBarWhenPushed=NO;
    
}
#pragma mark - 浏览大图点击事件
-(void)scanBigImageClick1:(UITapGestureRecognizer *)tap{
    
    UIImageView *clickedImageView = (UIImageView *)tap.view;
    [XWScanImage scanBigImageWithImageView:clickedImageView];
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
