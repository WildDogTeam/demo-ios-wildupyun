//
//  TestCell.h
//  WilddogImg
//
//  Created by IMacLi on 15/11/19.
//  Copyright © 2015年 liwuyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TestModel;

@interface TestCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mImgView;

@property (weak, nonatomic) IBOutlet UILabel *mTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *mContentLab;

- (void)setCellValues:(TestModel *)note;

@end
