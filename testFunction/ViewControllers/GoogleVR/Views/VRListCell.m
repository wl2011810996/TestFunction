//
//  VideoCell.m
//  WMVideoPlayer
//
//  Created by zhengwenming on 16/1/17.
//  Copyright © 2016年 郑文明. All rights reserved.
//

#import "VRListCell.h"
#import "UIImageView+WebCache.h"

@implementation VRListCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setModel:(VRModel *)model{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLabel.text = @"测试测试测试";
    self.descriptionLabel.text = @"测试测试测试";

    [self.backgroundIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://vimg1.ws.126.net/image/snapshot/2017/9/O/R/VCU0GB7OR.jpg"]] placeholderImage:[UIImage imageNamed:@"logo.jpeg"]];
    self.countLabel.text = [NSString stringWithFormat:@"%d.%d万",1.0,2.0];
//    self.timeDurationLabel.text = [model.ptime substringWithRange:NSMakeRange(12, 4)];

}
@end
