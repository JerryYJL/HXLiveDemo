//
//  FriendTableViewCell.m
//  HXLiveDemo
//
//  Created by Apple on 16/8/22.
//  Copyright © 2016年 JunLiu. All rights reserved.
//

#import "FriendTableViewCell.h"

@implementation FriendTableViewCell



-(UILabel *)userNameLabel{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.height - 2*12 + 2*12, 19, 160, 22)];
        _userNameLabel.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:self.userNameLabel];
    }
    return _userNameLabel;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.lineView];
    }
    return _lineView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
