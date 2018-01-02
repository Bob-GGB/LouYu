//
//  TestQuestionViewController.m
//  LouYu
//
//  Created by barby on 2017/8/7.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "TestQuestionViewController.h"

#import "QuestionListModel.h"
#import <MJExtension/MJExtension.h>

#import "MyExamTopView.h"
#import "MyExamBoomView.h"

#import "SingleSelectView.h"

#import "GxqAlertView.h"



// RGB颜色值
#define ZmjColor(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]

@interface TestQuestionViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionViewFlowLayout *collectionViewLayout;

@property (strong, nonatomic) UICollectionView           *collectionView;

@property (strong, nonatomic) MyExamTopView              *myExamTopView;

@property (strong, nonatomic) MyExamBoomView             *myExamBoomView;

@property (strong, nonatomic) NSMutableArray             *dataSource;

@property (strong, nonatomic) NSMutableArray             *resultArray;

@property (strong, nonatomic) NSMutableArray             *indexPathArray;

@property (assign, nonatomic) NSInteger                   currentSelectIndex;
@property(strong,nonatomic)   NSMutableArray              *selectQuestionArr;
@property(nonatomic,strong)NSNumber                       *tokenStr;

@property(nonatomic,strong)NSMutableArray                 *textArr;

@end

@implementation TestQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBarButtonItemWithImageName:nil andTitle:nil];
    [self setTitle:self.typeNameStr];
    // [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initView];
    
    [self initDatas];
    [self getToken];

   }


- (void)initView {
    
    [self.view addSubview:self.myExamTopView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.myExamBoomView];
    
    __weak typeof(self) weakSelf = self;
    
    _myExamBoomView.subjectBlock = ^(NSInteger btnTag) {
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        
        
        switch (btnTag) {
                
            case 0:
                
                [strongSelf collectionViewScrollToItem:NO btnTag:btnTag];
                break;
            case 1:
                
                [strongSelf collectionViewScrollToItem:YES btnTag:btnTag];
                
                
               strongSelf.myExamTopView.subjectTypeLabel.text = @"(答错一题扣10分 选择题)";
                
                strongSelf.myExamTopView.subjectNumLabel.text = [NSString stringWithFormat:@"%ld/%ld",strongSelf.currentSelectIndex+1, (unsigned long)strongSelf.dataSource.count];
                
                
                
                if (_currentSelectIndex==9) {
                    
//                    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF == %@", @""];
//                    
//                    NSArray *resu = [weakSelf.resultArray filteredArrayUsingPredicate:predicate1];
//                    NSLog(@"%ld",resu.count);
//                    if (resu.count!=0) {
                    
                        [strongSelf.myExamBoomView removeFromSuperview];
                        [weakSelf creatSubmitButton];
//                    }
                    
                    
                }
                
                
                break;
                
            default:
                break;
        }
    };
}

-(void)creatSubmitButton{

    UIButton *submitButton=[UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame =CGRectMake(KscreenWidth/4, KscreenHeight-200, KscreenWidth/2, 30);
    [submitButton setImage:[UIImage imageNamed:@"btn_tijiao.png"] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(SubmitButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    

}


-(void)SubmitButtonDidPress:(UIButton *)sender{
//                        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF == %@", @""];
//    
//                        NSArray *resu = [self.resultArray filteredArrayUsingPredicate:predicate1];
//                        NSLog(@"%ld",resu.count);
//                        if (resu.count==0) {
//                            
//                            NSLog(@"你还有未选题目");
//                        }
//                        else{
    
    
   // NSLog(@"strongSelf.resultArray:%@",self.resultArray);
    
    

    [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/test/submitAnwser"];
    
    
//                        }
   

}

- (void)initDatas {
    
    [self dataSource];
    [self resultArray];
    [self indexPathArray];
    [self selectQuestionArr];
    
    _dataSource = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""].mutableCopy;
    
    for (int i = 0; i < _dataSource.count; i++) {
        
        [_resultArray addObject:@[]];
        [_indexPathArray addObject:@[]];
        [_selectQuestionArr addObject:@[]];
    }
    
    _myExamTopView.subjectTypeLabel.text = @"(答错一题扣10分 选择题)";
    _myExamTopView.subjectNumLabel.text = [NSString stringWithFormat:@"1/%ld",(unsigned long)_dataSource.count];
}

// 设置单元格的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataSource.count;
}

// 设置段数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    if (cell) {
        
        for (UIView *view in cell.contentView.subviews) {
            
            if (view) {
                
                [view removeFromSuperview];
            }
        }
    }
    
        
        SingleSelectView *singleView = [[SingleSelectView alloc]initWithTypeId:self.typeIDNum];
    
       singleView.frame = cell.contentView.bounds;
        [cell.contentView addSubview:singleView];
    
        if ([_resultArray[indexPath.item] isKindOfClass:[NSString class]] && [_indexPathArray[indexPath.item] isKindOfClass:[NSIndexPath class]]) {
            
//            [_resultArray removeAllObjects];
//            [_indexPathArray removeAllObjects];
            singleView.seleIndexStr  = _resultArray[indexPath.item];
            
            singleView.seleIndexPath = _indexPathArray[indexPath.item];
           
        }
        __weak typeof(self) weakSelf = self;
        
        singleView.SingleSelectBlock = ^(NSIndexPath *seleIndexPath, NSInteger btnTag,NSNumber *questionId) {
            
            __strong typeof(weakSelf)strongSelf = weakSelf;
            
            [strongSelf.resultArray replaceObjectAtIndex:indexPath.item withObject:[NSString stringWithFormat:@"%ld",(long)btnTag]];
            [strongSelf.indexPathArray replaceObjectAtIndex:indexPath.item withObject:seleIndexPath];
            
            [strongSelf.selectQuestionArr replaceObjectAtIndex:indexPath.item withObject:questionId];
            
            [strongSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.item inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            
            
           
            
                    };

    return cell;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [self scrollViewEndScrolling:scrollView.contentOffset];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollViewEndScrolling:scrollView.contentOffset];
}

// 设置单元格大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 单元格默认大小：50*50
    // 第一个参数：设置单元格的宽
    // 第二个参数：设置单元格的高
    return CGSizeMake(KscreenWidth, KscreenHeight - 64);
}

// cell与cell之间的间隔，边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //上左下右
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// 设置垂直最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

// 设置水平最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

// 设置标题头大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    // 第一个参数：只有当水平滑动时有效
    // 第二个参数：只有当垂直滑动时有效
    return CGSizeMake(0, 0);
}

- (void)scrollViewEndScrolling:(CGPoint)contentOffset {
    
   
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int currentPage=scrollView.contentOffset.x/scrollView.frame.size.width;
     _myExamTopView.subjectNumLabel.text = [NSString stringWithFormat:@"%d/%ld",currentPage+1,(unsigned long)_dataSource.count];
}
- (void)collectionViewScrollToItem:(BOOL)bl btnTag:(NSInteger)btnTag {
    
    if (bl)  _currentSelectIndex ++;
   
    
    else     _currentSelectIndex --;
    
    
    
    
     //NSLog(@"_currentSelectIndex:%ld",_currentSelectIndex);
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentSelectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    if (_currentSelectIndex == _dataSource.count - 1  || _currentSelectIndex == 0) {
        
        UIButton *button  = (UIButton *)[_myExamBoomView viewWithTag:btnTag];
            button.enabled = NO;
       
        NSArray *subArray = _myExamBoomView.subviews;
        
        for (UIButton *subbutton  in subArray) {
            
            if ([subbutton isKindOfClass:[UIButton class]]) {
                if (subbutton != button) {
                    subbutton.enabled = YES;
                    
                }
            }
        }
    }
    
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionViewLayout                          = [[UICollectionViewFlowLayout alloc] init]; // 自定义的布局对象
        _collectionView                                = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, KscreenWidth, KscreenHeight - 64) collectionViewLayout:_collectionViewLayout];
        _collectionViewLayout.scrollDirection          = UICollectionViewScrollDirectionHorizontal;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces                        = NO;
        _collectionView.pagingEnabled                  = YES;
        _collectionView.dataSource                     = self;
        _collectionView.delegate                       = self;
        _collectionView.scrollsToTop                   = NO;
        _collectionView.backgroundColor                = [UIColor whiteColor];
        // 注册cell
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        [_collectionView setScrollEnabled:NO];
    }
    return _collectionView;
}

- (MyExamTopView *)myExamTopView {
    if (!_myExamTopView) {
        _myExamTopView = [[MyExamTopView alloc]init];
    }
    return _myExamTopView;
}

- (MyExamBoomView *)myExamBoomView {
    if (!_myExamBoomView) {
        _myExamBoomView = [[MyExamBoomView alloc]init];
    }
    return _myExamBoomView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (NSMutableArray *)resultArray {
    if (!_resultArray) {
        _resultArray = [[NSMutableArray alloc]init];
    }
    return _resultArray;
}

- (NSMutableArray *)indexPathArray {
    if (!_indexPathArray) {
        _indexPathArray = [[NSMutableArray alloc]init];
    }
    return _indexPathArray;
}

- (NSMutableArray *)selectQuestionArr {
    if (!_selectQuestionArr) {
        _selectQuestionArr = [[NSMutableArray alloc]init];
    }
    return _selectQuestionArr;
}


-(NSMutableArray *)textArr{
    if (!_textArr) {
        _textArr =[NSMutableArray array];
    }
    return _textArr;

}






-(void)getToken{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[defaults dictionaryForKey:@"UserInfoDic"];
    //取到userInfo
    NSDictionary *userDic=dic[@"content"][@"userInfo"];
    self.tokenStr=userDic[@"token"];
    
}
//
/**********************上传json到服务器请求数********************************/
-(void)PostDataToSeverWithUrl:(NSString *)Url{
    

    NSMutableArray *arr=[NSMutableArray array];
    for (int i=0; i<self.selectQuestionArr.count; i++) {//self.selectQuestionArr里面有10个不同的数据
        NSMutableDictionary *dataDic=[NSMutableDictionary dictionary];
        [dataDic setValue:self.selectQuestionArr[i] forKey:@"questionID"];
        [arr addObject:dataDic];
        //NSLog(@"%@",arr);
    }
    for (int i=0; i<self.resultArray.count; i++){//resultArray里面有10个不同的数据
        NSMutableDictionary *Dic=[NSMutableDictionary dictionary];
        [Dic setValue:self.resultArray[i] forKey:@"optionID"];
        [arr addObject:Dic];
    }
    // NSLog(@"zong:%@",arr);
    NSMutableArray *array1=[NSMutableArray array];
    for (int i = 0; i < arr.count/2; i++) {
        
        NSNumber *a = [[arr objectAtIndex:i] valueForKey:@"questionID"];
        
        NSNumber *aa = [[arr objectAtIndex:i+10] valueForKey:@"optionID"];
        
        NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:a,@"questionID",aa,@"optionID", nil];
        [array1 addObject:aDic];
        
    }
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:self.typeIDNum forKey:@"typeID"];
        [dictionary setValue:array1 forKey:@"test"];
    
    [HttpRequest POST:Url getToken:self.tokenStr paramentDict:dictionary success:^(id responseObj) {
                //请求成功返回数据；需要转化成字典（即json格式数据）
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
        if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
            [ClearCache showHUDWithText:@"该账号已在其他设备登录，请重新登录" ];
            LoginViewController *logInCV=[[LoginViewController alloc] init];
            [self presentViewController:logInCV animated:YES completion:nil];
        }
        //                NSLog(@"dict:%@",dict);
        else{
        
            [self showAlertController:@"提示" andMessage:@"确认提交答案吗？" andScoreStr:dict[@"content"][@"score"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}



- (void) showAlertController:(NSString *)title andMessage:(NSString *)msg andScoreStr:(NSString *) scoreStr{
    
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    //设置按钮
    UIAlertAction *action = [UIAlertAction
                             actionWithTitle:@"确定"
                             style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                 [GxqAlertView showWithTipText:[NSString stringWithFormat:@"本次成绩为%@",scoreStr] second:5 rightText:@"返回" RightBlock:^{
                                     [self.navigationController popViewControllerAnimated:YES];
                                     
                                 } TimeOver:^{
                                     [self.navigationController popViewControllerAnimated:YES];
                                 }];
                                 
                             }];
    UIAlertAction *action1 = [UIAlertAction
                              actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                              handler:nil];
    
    [controller addAction:action];
    [controller addAction:action1];
    
    
    [self presentViewController:controller animated:YES completion:nil];
}



-(void)leftBarButtonDidPress:(UIButton *)sender{
    
    
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
