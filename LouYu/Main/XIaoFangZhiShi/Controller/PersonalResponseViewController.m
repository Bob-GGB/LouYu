//
//  PersonalResponseViewController.m
//  LouYu
//
//  Created by barby on 2017/8/30.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "PersonalResponseViewController.h"
#import "NoDataView.h"
#import "CommentTextViewAndButtonView.h"
#import "CommentsTableViewCell.h"
#import "UITableViewCell+FSAutoCountHeight.h"
@interface PersonalResponseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *NewsTableView;
@property(nonatomic,strong)NSMutableArray *commentArr;
@property(nonatomic,strong) NoDataView *nodataView;
@property(nonatomic,strong)NSNumber *tokenStr;
@property(nonatomic,strong)NSString *contents;
@property (nonatomic,strong) CommentTextViewAndButtonView *commentView ;
//服务器返回的数据存到这个字典里
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;

@end

@implementation PersonalResponseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setUserInteractionEnabled:YES];
    
    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
//    [self.view setBackgroundColor:KRGB(240, 240, 240, 1.0)];
    [self setTitle:@"个人回复"];
    // [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self addNoticeForKeyboard];
    [self setUpHeadView];
    
    [self getToken];
    [self GetCommentFromSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/article/getReply"];
 self.commentView=[[CommentTextViewAndButtonView alloc] initWithFrame:CGRectMake(0, KscreenHeight-128, KscreenWidth,64*Height)];
    [self.view addSubview:self.commentView];
    
    __weak typeof(self)weakSelf=self;
    [self.commentView setSendCommentBoclk:^(NSString *content){
        weakSelf.contents=content;
        
        if (weakSelf.contents==NULL) {
            [ClearCache showHUDWithText:@"请输入你的评论"];
        }
        else
        {
            [weakSelf sendCommentsToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/article/publishComments"];
        }
        [weakSelf.commentView.commentField resignFirstResponder];
        
        
        
    }];
    
    self.NewsTableView.estimatedRowHeight = 0;
    self.NewsTableView.estimatedSectionHeaderHeight = 0;
    self.NewsTableView.estimatedSectionFooterHeight = 0;
    
}
#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = kbHeight-64;
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
        //        self.commentView.frame=CGRectMake(0, KscreenHeight-128, KscreenWidth,64*Height);
        //        NSLog(@"%@",NSStringFromCGRect(self.commentView.frame));
    }];
    
    
    
}



-(void)setUpHeadView{
    
//    NSLog(@"_cellHieght:%f",_cellHieght);
    UIView *headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, _cellHieght)];
    [headView setBackgroundColor:[UIColor whiteColor]];
    CommentsTableViewCell *commentsView=[[CommentsTableViewCell alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, _cellHieght)];
    [commentsView setBackgroundColor:[UIColor whiteColor]];
    [headView addSubview:commentsView];
    [self.view addSubview:headView];
    [commentsView.headImageView sd_setImageWithURL:[NSURL URLWithString:self.headUrl]];
    commentsView.nameLabel.text=self.nameStr;
    commentsView.timeLabel.text=self.timeStr;
    commentsView.countLabel.text=[NSString stringWithFormat:@"%@",self.praiseNum];
    commentsView.commentLabel.text=self.contentStr;
    if ([self.pastNum isEqualToNumber:@1]) {
        [commentsView.supportBtn setImage:[UIImage imageNamed:@"矢量智能对象_59"] forState:UIControlStateNormal];
    }
    else{
        [commentsView.supportBtn setImage:[UIImage imageNamed:@"矢量智能对象_60"] forState:UIControlStateNormal];
    }

    
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
-(void)GetCommentFromSeverWithUrl:(NSString *)Url{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.articleID forKey:@"articleID"];
    [dictionary setObject:self.contentID forKey:@"contentID"];
    
    [HttpRequest POST:Url getToken:self.tokenStr paramentDict:dictionary success:^(id responseObj) {
        
        //请求成功返回数据；需要转化成字典（即json格式数据）
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
        
//                          NSLog(@"dict:%@",dict);
        if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
            [ClearCache showHUDWithText:@"该账号已在其他设备登录，请重新登录"];
            LoginViewController *logInCV=[[LoginViewController alloc] init];
            [self presentViewController:logInCV animated:YES completion:nil];
        }
        //
        else{
            
            if ([dict[@"code"] isEqualToNumber:@(-2)]) {
                
                [self.NewsTableView removeFromSuperview];
                self.nodataView =[[NoDataView alloc] init];
                [self.view addSubview:self.nodataView];
            }
            else{
                
                [self.nodataView removeFromSuperview];
                [self.NewsTableView removeFromSuperview];
                self.InfoDictionary =[NSMutableDictionary dictionaryWithDictionary:dict];
                
                
                NSArray *arr= self.InfoDictionary[@"content"][@"replyList"];
                
                [self.commentArr removeAllObjects];
                for (NSDictionary *obj in arr) {
                    ReplyListModel *Model=[[ReplyListModel alloc] initWithDict:obj];
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




-(void)sendCommentsToSeverWithUrl:(NSString *)Url{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.articleID forKey:@"articleID"];
    [dictionary setObject:self.contentID forKey:@"contentID"];
    [dictionary setObject:self.userID forKey:@"sendUserID"];
    [dictionary setObject:self.contents forKey:@"content"];
    
    [HttpRequest POST:Url getToken:self.tokenStr paramentDict:dictionary success:^(id responseObj) {
        //请求成功返回数据；需要转化成字典（即json格式数据）
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
        
//        NSLog(@"dict:%@",dict);
        if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
            [ClearCache showHUDWithText:@"该账号已在其他设备登录，请重新登录"];
            LoginViewController *logInCV=[[LoginViewController alloc] init];
            [self presentViewController:logInCV animated:YES completion:nil];
        }
        //
        else{
            
            if ([dict[@"code"] isEqualToNumber:@1]) {
                [self viewDidLoad];
            }
            
            if ([dict[@"code"] isEqualToNumber:@(-2)]) {
                
                [self.NewsTableView removeFromSuperview];
                self.nodataView =[[NoDataView alloc] init];
                [self.view addSubview:self.nodataView];
            }
            else{
                
                [self.nodataView removeFromSuperview];
                [self.NewsTableView removeFromSuperview];
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
       [_NewsTableView setBackgroundColor:KRGB(240, 240, 240, 1.0)];
        _NewsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _cellHieght*Height, KscreenWidth, KscreenHeight-128*Height-_cellHieght*Height) style:UITableViewStyleGrouped];
        _NewsTableView.showsVerticalScrollIndicator = NO;
        _NewsTableView.dataSource = self;
        _NewsTableView.delegate = self;

//        _NewsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
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
    
    
    
    static NSString *CommentsID=@"CommentsID";
    CommentsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CommentsID];
//         CommentsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[CommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CommentsID];
    }
     [cell setBackgroundColor:[UIColor clearColor]];
    
    //    先取到对象
    ReplyListModel *model=self.commentArr[indexPath.row];
    [cell bindDataWithContentListModel:model];    
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
    CGFloat heightSs=[CommentsTableViewCell FSCellHeightForTableView:tableView indexPath:indexPath cellContentViewWidth:0 bottomOffset:0];
//    NSLog(@"heightSs:%f",heightSs+10);
    return heightSs+5;
    
}

//反选  点击的时候灰色 返回来的时候 又变回白色
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    CollectionListModel *model=self.newsArr[indexPath.row];
    //    NewsDetailViewController *newsDetailCV=[[NewsDetailViewController alloc] init];
    //    newsDetailCV.articleID=model.articleID;
    //    newsDetailCV.hidesBottomBarWhenPushed=YES;
    //    [self.navigationController pushViewController:newsDetailCV animated:YES];
    
    
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
