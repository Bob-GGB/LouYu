//
//  XiaoFangViewController.m
//  LouYu
//
//  Created by barby on 2017/7/24.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "XiaoFangViewController.h"
#import "ImagesScrollView.h"
#import "NewTableViewCell.h"
#import "ButtonView.h"
#import "NewsModel.h"
#import "TypeModel.h"
#import "NewsDetailViewController.h"
@interface XiaoFangViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *XiaoFangTableView;
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,strong)NSMutableArray *newsArr;
@property(nonatomic,strong)NSMutableArray *typeArr;
@property(nonatomic,strong)NSNumber *tokenStr;
//服务器返回的数据存到这个字典里
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;

@end

@implementation XiaoFangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [AtuoFillScreenUtils autoLayoutFillScreen:self.view];
    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"消防知识"];
    // [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self getToken];
    [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/article/getTypeList"];
   
    
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
        
                 //NSLog(@"self.InfoDictionary :%@",self.InfoDictionary);
                //取到articleList
                NSArray *arr= self.InfoDictionary[@"content"][@"articleList"];
        
                for (NSDictionary *obj in arr) {
                    NewsModel *newSModel=[[NewsModel alloc] initWithDict:obj];
                    [self.newsArr addObject:newSModel];
        
                }
                //取到articleList
                NSArray *arr1= self.InfoDictionary[@"content"][@"typeList"];
                for (NSDictionary *obj in arr1) {
                    TypeModel *typeModel=[[TypeModel alloc] initWithDict:obj];
                    [self.typeArr addObject:typeModel];
                    //NSLog(@"self.typeModel:%@",self.typeModel.typeID);
                    
                }
                
                [self.view addSubview:self.XiaoFangTableView];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}





-(UITableView *)XiaoFangTableView{
    if (_XiaoFangTableView==nil) {
        
        _XiaoFangTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64*Height) style:UITableViewStyleGrouped];
        _XiaoFangTableView.showsVerticalScrollIndicator = NO;
        
        [_XiaoFangTableView setBackgroundColor:[UIColor whiteColor]];
        _XiaoFangTableView.dataSource = self;
        _XiaoFangTableView.delegate = self;
        //_XiaoFangTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _XiaoFangTableView.sectionFooterHeight=1.0f;
    

    }
    return _XiaoFangTableView;

}
-(NSArray *)dataArr{
    if (_dataArr==nil) {
  
        _dataArr =@[@"p1",@"p2",@"p3"];
    }

    return _dataArr;

}
-(NSArray *)newsArr{
    if (_newsArr ==nil) {
        _newsArr=[NSMutableArray array];
    }
    return _newsArr;

}
-(NSMutableArray *)typeArr{
    if (_typeArr==nil) {
        _typeArr=[NSMutableArray array];
    }
    return _typeArr;
}
#pragma mark - 数据源方法
//设置组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//设置每一组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    
    else
    return self.newsArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        
        static NSString *xiaoFangID=@"xiaoFangID";
        ButtonView*cell=[tableView dequeueReusableCellWithIdentifier:xiaoFangID];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell==nil) {
            cell=[[ButtonView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:xiaoFangID];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            __weak typeof(self)weakSelf = self;
            [cell setSendController:^(UIViewController *controller) {
                
                controller.hidesBottomBarWhenPushed=YES;
                [weakSelf.navigationController pushViewController:controller animated:NO];
                //controller.hidesBottomBarWhenPushed=NO;
                
                
            }];

        }
        if (self.typeArr.count !=0) {
            TypeModel *typeModel=self.typeArr[indexPath.row];
            cell.typeIDNum=typeModel.typeID;
            cell.typeNameStr=typeModel.typeName;

        }
                //NSLog(@"cell.typeIDNum%@",cell.typeIDNum);
        
        return cell;
    }
    if (indexPath.section==1) {
        
        static NSString *xinWenID=@"xinWenID";
        NewTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:xinWenID];
        if (cell==nil) {
            cell=[[NewTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:xinWenID];
        }
        //先取到对象
        indexArticleListModel *model=self.newsArr[indexPath.row];
        [cell bindDataWithModel:model];
        
        return cell;

    }
    return nil;
    
}

//返回表头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 145;
    }
    if (section==1) {
        return 25;
    }
    else return 0.1f;
}
//返回表头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        // 只需初始化就可以实现效果
        if (self.dataArr.count !=0) {
            ImagesScrollView * loopScrollImageView =[[ImagesScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 145) images:self.dataArr];
            return loopScrollImageView;
        }
       
        else
            return nil;
    }
    if (section==1) {
        
        UIView *HeadImageView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,5, 60, 15)];
        [imageView setImage:[UIImage imageNamed:@"redianxinwen.png"]];
        [HeadImageView addSubview:imageView];
        
        return HeadImageView ;

    }
    return nil;
    
}
//返回单元格行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 115*Height;
        
    }
    else if(indexPath.section==1)
    {
        return 104*Height;
    }
    else
        return 0;
}

//反选  点击的时候灰色 返回来的时候 又变回白色
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewsModel *model=self.newsArr[indexPath.row];
    NewsDetailViewController *NewsDetailViewCV=[[NewsDetailViewController alloc] init];
    NewsDetailViewCV.articleID=model.articleID;
    [NewsDetailViewCV setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:NewsDetailViewCV animated:NO];

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
