//
//  RelateToMe_ConmentsListViewController.m
//  LouYu
//
//  Created by barby on 2017/9/1.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "RelateToMe_ConmentsListViewController.h"
#import "UITableViewCell+FSAutoCountHeight.h"
#import "NoDataView.h"
#import "CommentTextViewAndButtonView.h"
#import "CommentsListModel.h"
#import "CommentsTableViewCell.h"
#import "PersonalResponseViewController.h"
#import "GetContentForMeModel.h"
#import "RelateToMe_ConmentsListTableViewCell.h"


@interface RelateToMe_ConmentsListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *NewsTableView;
@property(nonatomic,strong)NSMutableArray *commentArr;
@property(nonatomic,strong) NoDataView *nodataView;
@property(nonatomic,strong)NSNumber *tokenStr;
//服务器返回的数据存到这个字典里
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;

@property(nonatomic,assign)CGFloat cellHeight;

@end

@implementation RelateToMe_ConmentsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setUserInteractionEnabled:YES];
    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
    //    [self.view setBackgroundColor:KRGB(211, 211, 211, 1.0)];
    [self setTitle:@"全部评论"];
    // [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    [self getToken];
    [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/article/getContentForMe"];
    
    
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
    [dictionary setValue:self.articleID forKey:@"articleID"];
    
    [HttpRequest POST:Url getToken:self.tokenStr paramentDict:dictionary success:^(id responseObj) {
        
        //请求成功返回数据；需要转化成字典（即json格式数据）
//        NSData*jsondata = responseObj;
//        
//        NSString *jsonStr = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", jsonStr);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
        
        
        if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
            [ClearCache showHUDWithText:@"该账号已在其他设备登录，请重新登录"];
            LoginViewController *logInCV=[[LoginViewController alloc] init];
            [self presentViewController:logInCV animated:YES completion:nil];
        }
        //
        else{
            
            if ([dict[@"code"] isEqualToNumber:@(-3)]) {
                
                [self.NewsTableView removeFromSuperview];
                self.nodataView =[[NoDataView alloc] init];
                
                [self.view addSubview:self.nodataView];
            }
            else{
                
                [self.nodataView removeFromSuperview];
                [self.NewsTableView removeFromSuperview];
                self.InfoDictionary =[NSMutableDictionary dictionaryWithDictionary:dict];
                
                
                NSArray *arr= self.InfoDictionary[@"content"][@"reply"];
                
                [self.commentArr removeAllObjects];
                for (NSDictionary *obj in arr) {
                    GetContentForMeModel *Model=[[GetContentForMeModel alloc] initWithDict:obj];
                    [self.commentArr addObject:Model];
                    
                }
                
                [self.view addSubview:self.NewsTableView];
                [self.NewsTableView reloadData];
                
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}





-(UITableView *)NewsTableView{
    if (_NewsTableView ==nil) {
        
        _NewsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64*Height) style:UITableViewStyleGrouped];
        _NewsTableView.showsVerticalScrollIndicator = NO;
        
        [_NewsTableView setBackgroundColor:[UIColor whiteColor]];
        _NewsTableView.dataSource = self;
        _NewsTableView.delegate = self;
        //_XiaoFangTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
    }
    
    return _NewsTableView;
}

-(NSMutableArray *)commentArr{
    if (_commentArr ==nil) {
        _commentArr=[NSMutableArray array];
    }
    return _commentArr;
    
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
    
    return self.commentArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    先取到对象
    GetContentForMeModel *model=self.commentArr[indexPath.row];
    
    static NSString *RelateToMe_ConmentsList=@"RelateToMe_ConmentsList";
//    RelateToMe_ConmentsListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:RelateToMe_ConmentsList];
         RelateToMe_ConmentsListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[RelateToMe_ConmentsListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:RelateToMe_ConmentsList andExist:model.exist ];
    
    }
    
    [cell sendDataWithContentListModel:model];
    
    if ([model.exist isEqualToNumber:@1]) {
        
       
        cell.replayLabel=[[UILabel alloc] init];
        [cell.replayLabel setBackgroundColor:KRGB(240, 240, 240, 0.5)];
        [cell.replayLabel setTextColor:KRGB(153, 153, 153, 1.0)];
        [cell.replayLabel setNumberOfLines:0];
        [cell.replayLabel setFont:[UIFont systemFontOfSize:15]];
        [cell.replayLabel.layer setCornerRadius:2];
        [cell.replayLabel.layer setMasksToBounds:YES];

        //                      WithFrame:CGRectMake(self.sendNameLabel.frame.origin.x, CGRectGetMaxY(self.timeLabel.frame)+5, KscreenWidth-self.headImageView.frame.size.width-40*Height, 25*Height)];
        // 设置文字属性 要和label的一致
        NSDictionary *attrs1 = @{NSFontAttributeName : cell.replayLabel.font};
        CGSize maxSize = CGSizeMake( KscreenWidth-cell.headImageView.frame.size.width-40*Height, MAXFLOAT);
        
        // 计算文字占据的高度
        CGSize sizeaa = [[NSString stringWithFormat:@"  %@:%@",model.userName,model.replyContent] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs1 context:nil].size;
        _cellHeight=sizeaa.height;
        // 设置label尺寸
        cell.replayLabel.frame = CGRectMake(cell.sendNameLabel.frame.origin.x, CGRectGetMaxY(cell.timeLabel.frame)+5, sizeaa.width, sizeaa.height);
        cell.replayLabel.text=[NSString stringWithFormat:@"  %@:%@",model.userName,model.replyContent];
        [cell addSubview:cell.replayLabel];
        //    [self.replayLabel setBackgroundColor:[UIColor brownColor]];
        

    }
    
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
    GetContentForMeModel *model=self.commentArr[indexPath.row];
    if ([model.exist isEqualToNumber:@0]) {
        return 100*Height;
    }
    else{
        return 110*Height+_cellHeight;
    }
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
