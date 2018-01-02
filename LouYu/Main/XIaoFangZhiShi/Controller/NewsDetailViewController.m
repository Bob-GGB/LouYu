//
//  NewsDetailViewController.m
//  LouYu
//
//  Created by barby on 2017/7/27.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "NewsDetailTableViewCell.h"
#import "NewsDetailTwoTableViewCell.h"
#import "articleDetailModel.h"
#import "ContentListModel.h"
#import "FootButtonView.h"
#import "UITableViewCell+FSAutoCountHeight.h"
#import "ShareCollectionViewCell.h"
#import "ShareView.h"
#import <UMSocialCore/UMSocialCore.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
/** 屏幕的SIZE */
#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size
/** define:屏幕的宽高比 */
#define CURRENT_SIZE(_size) _size / 375.0 * SCREEN_SIZE.width

NSInteger btnTag=2;
@interface NewsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic,strong)NSNumber *tokenStr;
//服务器返回的数据存到这个字典里
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;
@property(nonatomic,strong)UITableView *newsTableView;
@property(nonatomic,strong)NSMutableArray *titleArr;
@property(nonatomic,strong)NSMutableArray *newsArr;
@property(nonatomic,strong)ContentListModel *model;
@property(nonatomic,strong)articleDetailModel *detailModel;
@property(nonatomic,strong)NSNumber *userID;

/** 分享 */
@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) ShareView * shareView;
@property (nonatomic, strong) ShareCollectionViewCell * shareCell;
@property (nonatomic, strong) NSArray * shareIconAry;
@property (nonatomic, strong) NSArray * shareNameAry;
@end

@implementation NewsDetailViewController

//-(void)viewWillAppear:(BOOL)animated{
//    
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];
     [AtuoFillScreenUtils autoLayoutFillScreen:self.view];
    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self setrightBarButtonItemWithImageName:@"btn_gengduo.png" andTitle:nil];
    [self getToken];
    
    [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/article/getArticleDetail"];
    
    self.shareIconAry = @[@"微信ico",@"朋友圈icon",@"QQicon",@"组-6"];
    self.shareNameAry=@[@"微信",@"朋友圈",@"QQ",@"QQ空间"];
    self.newsTableView.estimatedRowHeight = 0;
    self.newsTableView.estimatedSectionHeaderHeight = 0;
    self.newsTableView.estimatedSectionFooterHeight = 0;
    
    }


-(void)getToken{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[defaults dictionaryForKey:@"UserInfoDic"];
    //取到userInfo
    NSDictionary *userDic=dic[@"content"][@"userInfo"];
    self.tokenStr=userDic[@"token"];
    self.userID=userDic[@"userID"];
    
}

/**********************上传json到服务器请求数********************************/
-(void)PostDataToSeverWithUrl:(NSString *)Url{
    

        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:self.articleID forKey:@"articleID"];
[HttpRequest POST:Url getToken:self.tokenStr paramentDict:dictionary success:^(id responseObj) {
    
            //请求成功返回数据；需要转化成字典（即json格式数据）
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
    
//                    NSLog(@"dict:%@",dict);

    if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
       [ClearCache showHUDWithText:@"该账号已在其他设备登录，请重新登录"];
        LoginViewController *logInCV=[[LoginViewController alloc] init];
        [self presentViewController:logInCV animated:YES completion:nil];
    }
       else{
            self.InfoDictionary =[NSMutableDictionary dictionaryWithDictionary:dict[@"content"][@"articleDetail"]];
    
            // NSLog(@"详细信息：%@",self.InfoDictionary);
            articleDetailModel *detailModel=[[articleDetailModel alloc] initWithDict:self.InfoDictionary];
           
         
            [self.titleArr addObject:detailModel];
            NSArray *cheskArray=dict[@"content"][@"articleDetail"][@"contentList"];
            for (NSDictionary *obj in cheskArray) {
                  ContentListModel *contentModel  =[[ContentListModel alloc] initWithDict:obj];
                [self.newsArr addObject:contentModel];
                
            }
    [self.view addSubview:self.newsTableView];
    [self.newsTableView reloadData];
    }
} failure:^(NSError *error) {
    NSLog(@"%@",error);
}];
    
}


#pragma mark 导航栏右侧分享按钮
-(void)rightBarButtonDidPress:(UIButton *)sender{
    [ClearCache showHUDWithText:@"该功能还在探索中"];
    //[self initShareView]; // 分享功能先关闭，等H5页面有了之后再打开
   }


/** 初始化分享界面 */
- (void) initShareView{
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.5;
    
    UITapGestureRecognizer *tapIt = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(tapOnBgView:)];
    [self.bgView addGestureRecognizer:tapIt];
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
    
    self.shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, SCREEN_SIZE.height-CURRENT_SIZE(110), SCREEN_SIZE.width, CURRENT_SIZE(110))];
    self.shareView.backgroundColor = [UIColor whiteColor];
    
    self.shareView.collection.delegate = self;
    self.shareView.collection.dataSource = self;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.shareView];
    
}

- (void)tapOnBgView:(UITapGestureRecognizer *)recognizer {
    
    [self.shareView removeFromSuperview];
    self.bgView.hidden = YES;
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //    判断有没有安装微信和qq:
    if ( ![QQApiInterface isQQInstalled]||![WXApi isWXAppInstalled]) {
        
        [ClearCache showHUDWithText:@"客户端版本过低或未安装"];
    
       
    }
    else{

      //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =_detailModel.photo;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_detailModel.title descr:_detailModel.title thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = @"http://www.qianchengwl.cn/";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        
    }];
    }
}

-(UITableView *)newsTableView{
    if (_newsTableView ==nil) {
        
        _newsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64*Height) style:UITableViewStyleGrouped];
        _newsTableView.showsVerticalScrollIndicator = NO;
        
        [_newsTableView setBackgroundColor:[UIColor whiteColor]];
        _newsTableView.dataSource = self;
        _newsTableView.delegate = self;
        _newsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
    }
    
    return _newsTableView;
}

-(NSMutableArray *)titleArr{

    if (_titleArr==nil) {
        _titleArr =[NSMutableArray array];
    }
    return _titleArr;
}

-(NSMutableArray *)newsArr{

    if (_newsArr==nil) {
        _newsArr=[NSMutableArray array];
    }
    return _newsArr;
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
        return self.titleArr.count;
    }
    else if (section==1) {
        
        return self.newsArr.count;
        
    }
    else return 0;
    
    
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section==0) {
       
        static NSString *newsListID=@"newsListID";
        NewsDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:newsListID];
        if (cell==nil) {
            cell=[[NewsDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:newsListID];
        }
         self.detailModel=self.titleArr[indexPath.row];
       
        [cell bindDataWithModel:self.detailModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
   else if(indexPath.section==1)
   {
    static NSString *newsListDetailID=@"newsListDetailID";
    NewsDetailTwoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:newsListDetailID];
    if (cell==nil) {
        cell=[[NewsDetailTwoTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:newsListDetailID];
    }
      self.model =self.newsArr[indexPath.row];
      
       [cell sendDataWithContentListModel:self.model];
       cell.selectionStyle = UITableViewCellSelectionStyleNone;

       
    return cell;
   }
    return nil;
    
}

//返回表头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}
//返回单元格行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 285*Height;
    }
    else if (indexPath.section==1){
    
        //自动计算cell的高度
    CGFloat heights=[NewsDetailTwoTableViewCell FSCellHeightForTableView:tableView indexPath:indexPath cellContentViewWidth:0 bottomOffset:0];
        
        if ([self.model.photo isEqualToString:@""]) {
            return  heights*Height-250*Height;
        }
        return heights*Height;
       
    }
    return 0;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==1) {
        FootButtonView *footButton=[[FootButtonView alloc] initWithArticleID:self.articleID andUserID:self.userID];
        [footButton setFrame:CGRectMake(0, 0, KscreenWidth, 80*Height)];
        
        
        __weak typeof(self)weakSelf = self;
        [footButton setSendController:^(UIViewController *controller) {
        
            [weakSelf.navigationController pushViewController:controller animated:NO];
           
            
            
        }];
        //分享
    [footButton setShareBlock:^{
        [ClearCache showHUDWithText:@"该功能还在探索中"];
        //[self initShareView]; // 分享功能先关闭，等H5页面有了之后再打开
                                    }];
        
         __weak FootButtonView *weakBtn = footButton;
        
     
        if ([self.detailModel.light isEqualToNumber:@1]) {
//            footButton.isSelect=YES;
            [footButton.footButton setImage:[UIImage imageNamed:@"矢量智能对象_25"] forState:UIControlStateNormal];
        }
        else{
//            footButton.isSelect=NO;
            [footButton.footButton setImage:[UIImage imageNamed:@"btn_shoucang.png"] forState:UIControlStateNormal];
        }
        
        
    
        [footButton setCollectBlock:^(BOOL choice){
            
            
            if (choice) {
                if ([self.detailModel.light isEqualToNumber:@1]) {
                    
                     [weakBtn.footButton setImage:[UIImage imageNamed:@"btn_shoucang.png"] forState:UIControlStateNormal];
//        NSLog(@"1 ligth=%@:1choice:%@",self.detailModel.light,choice?@"YES":@"NO");
 [self cancelCollectionToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/user/cancelCollection"];
                
                }
                else{
                   [weakBtn.footButton setImage:[UIImage imageNamed:@"矢量智能对象_25"] forState:UIControlStateNormal];
//                   NSLog(@"0 ligth=%@:1choice:%@",self.detailModel.light,choice?@"YES":@"NO");
                    [self postCollcetionToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/user/collection"];
                                   }
                choice =!choice;
            }
            else{
                
                if ([self.detailModel.light isEqualToNumber:@0]) {
//                    NSLog(@"0ligth=%@:0choice:%@",self.detailModel.light,choice?@"YES":@"NO");
                    [weakBtn.footButton setImage:[UIImage imageNamed:@"btn_shoucang.png"] forState:UIControlStateNormal];
                    [self cancelCollectionToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/user/cancelCollection"];
                    
                }
                else{
                    
                    [weakBtn.footButton setImage:[UIImage imageNamed:@"矢量智能对象_25"] forState:UIControlStateNormal];
//                    NSLog(@"1ligth=%@: 0choice:%@",self.detailModel.light,choice?@"YES":@"NO");
                    [self postCollcetionToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/user/collection"];
                    choice =!choice;
                }
                
                    //                choice =!choice;
                }
        
        }];
        
   
        
        
        
        

        
        return footButton;
    }

    return nil;
}


#pragma -mark 收藏新闻请求服务器
-(void)postCollcetionToSeverWithUrl:(NSString *)Url{

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.articleID forKey:@"articleID"];
    
    [HttpRequest POST:Url getToken:self.tokenStr paramentDict:dictionary success:^(id responseObj) {
        
        //请求成功返回数据；需要转化成字典（即json格式数据）
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"dict:%@",dict);
        
        if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
            [ClearCache showHUDWithText:@"该账号已在其他设备登录，请重新登录"];
            LoginViewController *logInCV=[[LoginViewController alloc] init];
            [self presentViewController:logInCV animated:YES completion:nil];
        }
        
        else{
            if ([dict[@"code"] isEqualToNumber:@1]) {
              
                [ClearCache showHUDWithText:@"收藏成功"];
            }
            else{
             [ClearCache showHUDWithText:@"收藏失败"];
            }
            
        }

        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];


}

#pragma -mark 取消收藏请求服务器

-(void)cancelCollectionToSeverWithUrl:(NSString *)url{


    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.articleID forKey:@"articleID"];
    
    [HttpRequest POST:url getToken:self.tokenStr paramentDict:dictionary success:^(id responseObj) {
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
                
                [ClearCache showHUDWithText:@"取消收藏成功"];
            
            }
//            else{
//                [ClearCache showHUDWithText:@"操作失败"];
//            }
            
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    


}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1) {
        return 80*Height;
    }
    else
        return 0.1f;

}


//反选  点击的时候灰色 返回来的时候 又变回白色
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark -------------------- UICollectionViewDataSource --------------------

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.shareIconAry.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    
    self.shareCell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    //    [cell sizeToFit];
    
    self.shareCell.icon.image = [UIImage imageNamed:self.shareIconAry[indexPath.row]];
    
    self.shareCell.nameLabel.text=self.shareNameAry[indexPath.row];
    
    return self.shareCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    
    switch (indexPath.row) {
        case 0:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
            
            break;
        case 1:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
            
            break;
        case 2:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_QQ];
            
            break;
        case 3:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_Qzone];
            
            break;
            
        default:
            break;
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
