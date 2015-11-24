//
//  TestModel.h
//  WilddogImg
//
//  Created by IMacLi on 15/11/19.
//  Copyright © 2015年 liwuyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestModel : NSObject

@property(nonatomic, strong)NSString *title;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *imgUrl;


@property (nonatomic,strong) NSString *noteID;

/// 创建时间。
@property (nonatomic,assign) long long timestamp;

/// 最后更新时间。
@property (nonatomic,assign) long long lastUpdate;

- (instancetype)initWithDict:(NSDictionary *)dict;

- (NSDictionary *)toDict;

@end
