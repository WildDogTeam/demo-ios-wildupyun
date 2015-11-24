//
//  TestModel.m
//  WilddogImg
//
//  Created by IMacLi on 15/11/19.
//  Copyright © 2015年 liwuyang. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    
    if (self = [super init]) {
        self.title = dict[@"title"];
        self.content = dict[@"content"];
        self.imgUrl = dict[@"imgUrl"];
        
        self.lastUpdate = [dict[@"lastUpdate"] longLongValue];
        self.timestamp = [dict[@"timestamp"] longLongValue];
        self.noteID = dict[@"noteID"];
    }
    return self;
    
}

- (NSDictionary *)toDict
{
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:self.title forKey:@"title"];
    [dict setObject:self.content forKey:@"content"];
    [dict setObject:self.imgUrl forKey:@"imgUrl"];
    
    [dict setObject:@(self.lastUpdate) forKey:@"lastUpdate"];
    [dict setObject:self.noteID forKey:@"noteID"];
    [dict setObject:@(self.timestamp) forKey:@"timestamp"];

    return [NSDictionary dictionaryWithObjectsAndKeys:dict,self.noteID,nil];
    
}

@end
