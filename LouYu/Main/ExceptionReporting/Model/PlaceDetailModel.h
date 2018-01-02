//
//  PlaceDetailModel.h
//  LouYu
//
//  Created by barby on 2017/8/3.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

@interface PlaceDetailModel : BaseModel
@property(nonatomic,strong)NSNumber *placeID;
@property(nonatomic,copy)NSString *placeName;
@end
