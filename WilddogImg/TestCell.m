//
//  TestCell.m
//  WilddogImg
//
//  Created by IMacLi on 15/11/19.
//  Copyright © 2015年 liwuyang. All rights reserved.
//

#import "TestCell.h"
#import "TestModel.h"
#import "UIImageView+AFNetworking.h"
@implementation TestCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellValues:(TestModel *)note
{

    [self.mImgView setImageWithURL:[NSURL URLWithString:note.imgUrl] placeholderImage:[UIImage imageNamed:@"meinv4.jpg"]];
    self.mTitleLab.text = note.title;
    self.mContentLab.text = note.content;
    
}

@end
