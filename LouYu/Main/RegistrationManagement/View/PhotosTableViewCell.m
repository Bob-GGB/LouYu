//
//  PhotosTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/7/28.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "PhotosTableViewCell.h"

#define Start_X          12.0f      // 第一个图片的X坐标
#define Start_Y          20.0f     // 第一个图片的Y坐标
#define Width_Space      10.0f      // 2个图片之间的横间距

#define Button_Height   120.0f    // 高
#define Button_Width    110.0f    // 宽

@implementation PhotosTableViewCell


//-(void)bindDataWithModel:(RecordDetailModel *)model{
//    for (int i=0; i<model.photo.count; i++) {
//        
//              self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(Button_Width + Width_Space) +Start_X,CGRectGetMaxY(self.photoLabel.frame)+10,Button_Width , Button_Height)];
//        self.photoImageView.tag = i;//这句话不写等于废了
//        // [self.WarnImageView setBackgroundColor:[UIColor redColor]];
//        [self.photoImageView sd_setImageWithURL:model.photo[i]];
//        [self addSubview:self.photoImageView];
//    }
//
//
//}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpAllView];
    }
    return self;
    
}

-(void)setUpAllView{
    
    self.photoLabel =[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 150, 20)];
    [self.photoLabel setTextColor:KRGB(51, 51, 51, 1.0)];
    [self.photoLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [self.photoLabel setText:@"张贴照片"];
    [self addSubview:self.photoLabel];
    
    
    
}





- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
