//
//  UserListModel.h
//  LouYu
//
//  Created by barby on 2017/8/2.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

/*"userID": 83,
"userName": "罗聪",
"headImgUrl": "https://zheshang.patrol.qianchengwl.cn/uploads/20170526/2fcdbc1f0d9bcfdaed01bed116c0846f.jpg"
*/
@interface UserListModel : BaseModel
@property(nonatomic,strong)NSNumber *userID;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *headImgUrl;

@end
