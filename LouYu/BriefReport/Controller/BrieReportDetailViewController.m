//
//  BrieReportDetailViewController.m
//  LouYu
//
//  Created by barby on 2017/7/29.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BrieReportDetailViewController.h"
#import "PieChartView.h"
#import "ReportDetailModel.h"
#import "ContentDataModel.h"
#import "TotalDataModel.h"
#import "BriePeportDetailTableViewCell.h"
@interface BrieReportDetailViewController ()<UITableViewDelegate,UITableViewDataSource,JHColumnChartDelegate>
@property(nonatomic,strong)UITableView *listTableView;
@property(nonatomic,strong)NSMutableArray *colunmDataArr;
@property(nonatomic,strong)NSMutableArray *pieDataArr;
@property(nonatomic,strong)NSMutableArray *detaiDataArr;
@property(nonatomic,strong)NSNumber *tokenStr;
@property(nonatomic,strong) ReportDetailModel*model;
@property(nonatomic,strong)TotalDataModel *totalModel;
@property(nonatomic,strong)JHPieChart *pie;
@property(nonatomic,strong)JHColumnChart *column;
@property (nonatomic,assign) CGFloat cellHeight;

//服务器返回的数据存到这个字典里
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;
@end

@implementation BrieReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"简报详情"];
    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"简报"];
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
//       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [ClearCache showHUDAndView:self.navigationController.view completionBlock:^{
        [self getToken];
        [self PostDataToSever];
    }];
    
    
    self.pie = [[JHPieChart alloc] initWithFrame:CGRectMake(20, 20, 150, 150)];
}

-(void)getToken{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[defaults dictionaryForKey:@"UserInfoDic"];
    //取到userInfo
    NSDictionary *userDic=dic[@"content"][@"userInfo"];
    self.tokenStr=userDic[@"token"];
    
}

/**********************上传json到服务器请求数********************************/
-(void)PostDataToSever{
    

        NSString *urlString = @"http://louyu.qianchengwl.cn/minapp/report/getReportDetail";
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        //NSLog(@"repordId:%@",self.ReportID);
        [dictionary setValue:self.ReportID forKey:@"reportID"];
    [HttpRequest POST:urlString getToken:self.tokenStr paramentDict:dictionary success:^(id responseObj) {
        
                //请求成功返回数据；需要转化成字典（即json格式数据）
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
//          NSLog(@"dict:%@",dict);
        
        if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
            [ClearCache showHUDWithText:@"该账号已在其他设备登录，请重新登录"];
            LoginViewController *logInCV=[[LoginViewController alloc] init];
            [self presentViewController:logInCV animated:YES completion:nil];
        }
        
        else{

                self.InfoDictionary =[NSMutableDictionary dictionaryWithDictionary:dict];
               // NSLog(@"self.InfoDictionary :%@",self.InfoDictionary );
                //取到articleList
        
                self.model=[[ReportDetailModel alloc] initWithDict:self.InfoDictionary[@"content"][@"reportDetail"]];
        
        
                self.totalModel=[[TotalDataModel alloc] initWithDict:self.InfoDictionary[@"content"][@"reportDetail"][@"totalData"]];
        
        
        
                NSArray *arr= self.InfoDictionary[@"content"][@"reportDetail"][@"contentData"];
        
                //NSLog(@"----- :%@",self.InfoDictionary[@"content"][@"reportDetail"][@"contentData"] );
                //2.清除就数据,添加新数据
                [self.colunmDataArr removeAllObjects];
                for (NSDictionary *obj in arr) {
                    ContentDataModel *model=[[ContentDataModel alloc] initWithDict:obj];
                    [self.colunmDataArr addObject:model];
                }
                //NSLog(@"respons:%@",self.colunmDataArr);
                [self.listTableView reloadData];
                [self.view addSubview:self.listTableView];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}












-(UITableView *)listTableView{
    if (_listTableView ==nil) {
        
        _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, KscreenWidth, KscreenHeight-64*Height) style:UITableViewStylePlain];
        _listTableView.showsVerticalScrollIndicator = NO;
        
//        [_listTableView setBackgroundColor:KRGB(245, 245, 245, 1.0)];
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
    }
    
    return _listTableView;
}



-(NSMutableArray *)colunmDataArr{
    if (_colunmDataArr ==nil) {
        _colunmDataArr=[NSMutableArray array];
    }
    return _colunmDataArr;
    
}
-(NSMutableArray *)pieDataArr{
    if (_pieDataArr ==nil) {
        _pieDataArr=[NSMutableArray array];
    }
    return _pieDataArr;
    
}
-(NSMutableArray *)detaiDataArr{
    if (_detaiDataArr ==nil) {
        _detaiDataArr=[NSMutableArray array];
    }
    return _detaiDataArr;
    
}


#pragma mark - 数据源方法
//设置组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
//设置每一组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section==0) {
        static NSString *PieChartID=@"PieChartID";
        PieChartView *cell=[tableView dequeueReusableCellWithIdentifier:PieChartID];
        if (cell==nil) {
            cell=[[PieChartView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PieChartID];
        }
          [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.pie.backgroundColor = [UIColor whiteColor];
        self.pie.center = CGPointMake(100*Width, (self.pie.frame.size.width/2)*Height+20);
        self.pie.valueArr=@[self.totalModel.allTotalNum,self.totalModel.allActualNum,self.totalModel.allWarnNum];
        [cell addSubview:self.pie];
       // self.pie.positionChangeLengthWhenClick = 15;
        self.pie.showDescripotion = NO;
        self.pie.colorArr=@[KRGB(96, 151, 232,1.0),KRGB(164, 225, 255,1.0),KRGB(255, 204, 169,1.0)];
        [self.pie showAnimation];
    
        return cell;
    }
    if (indexPath.section==1) {
        static NSString *ColumnID=@"ColumnID";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ColumnID];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ColumnID];
        }
        
        NSMutableArray *tmpArr=[NSMutableArray array];
        NSMutableArray *tmpArr2=[NSMutableArray array];
        for (ContentDataModel *model in self.colunmDataArr) {
            [tmpArr addObject:@[model.totalNumber,model.actualNumber,model.warnNumber]];
            [tmpArr2 addObject:model.typeName];
        }
        self.column = [[JHColumnChart alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 330)];
        self.column.originSize = CGPointMake(30, 20);
        self.column.drawFromOriginX = 20;
        self.column.typeSpace = 10;
        self.column.isShowYLine = NO;
        self.column.columnWidth = 18;
        self.column.bgVewBackgoundColor = [UIColor whiteColor];
        self.column.drawTextColorForX_Y = [UIColor blackColor];
        self.column.colorForXYLine = [UIColor darkGrayColor];
        self.column.valueArr=tmpArr;
        self.column.columnBGcolorsArr = @[KRGB(96, 151, 232,1.0),KRGB(164, 225, 255,1.0),KRGB(255, 204, 169,1.0),KRGB(218, 247, 232,1.0)];
        self.column.xShowInfoText =tmpArr2;
        
        self.column.xDescTextFontSize=13.0f;
        self.column.isShowLineChart = YES;
        
        self.column.delegate = self;
        [self.column showAnimation];
        [cell addSubview:self.column];
        
        
        return cell;

    }
    if (indexPath.section==2) {
        static NSString *BriePeportID=@"BriePeportID";
        BriePeportDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:BriePeportID];
        if (cell==nil) {
            cell=[[BriePeportDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BriePeportID];
            
        }
          [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};//指定字号
        CGRect rect = [[self.model.detail  stringByReplacingOccurrencesOfString: @"\\n" withString: @"\r\n"] boundingRectWithSize:CGSizeMake(KscreenWidth-20, 0)/*计算高度要先指定宽度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading attributes:dic context:nil];
        _cellHeight=rect.size.height;
        cell.detailLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(cell.titleLabel.frame)+10, KscreenWidth-20, rect.size.height)];
        [cell.detailLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [cell.detailLabel setTextColor:KRGB(51, 51, 51, 1.0)];//KRGB(134, 136, 148, 1.0)
        //    [self.detailLabel setBackgroundColor:[UIColor greenColor]];
        [cell.detailLabel setNumberOfLines:0];
        [cell addSubview:cell.detailLabel];
        cell.titleLabel.text=self.model.title;
        cell.detailLabel.text=[self.model.detail  stringByReplacingOccurrencesOfString: @"\\n" withString: @"\r\n"];
        
        return cell;
    }
    
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
    if (indexPath.section==0) {
        return 160*Height;
    }
    else if (indexPath.section==1) {
        return 330*Height;
    }
    else if (indexPath.section==2) {
        return _cellHeight+100;
    }
    else return 0;
    
    
    
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
