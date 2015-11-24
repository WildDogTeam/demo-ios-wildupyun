//
//  TestService.m
//  WilddogImg
//
//  Created by IMacLi on 15/11/19.
//  Copyright © 2015年 liwuyang. All rights reserved.
//

#import "TestService.h"
#import <Wilddog/Wilddog.h>

#define kDefaultLimitPerPage 8



@interface TestService ()

@property (nonatomic,strong) NSNumber *lastUpdatetimeOnPrevPage;

@end

@implementation TestService
{
    Wilddog *_wilddog;
}

- (instancetype)init
{
    if (self = [super init]) {
        [[Wilddog defaultConfig] setPersistenceEnabled:YES];
        /*
         填入野狗云应用URL
         */
        _wilddog = [[Wilddog alloc] initWithUrl:@""];
        _lastUpdatetimeOnPrevPage = [NSNumber numberWithLong:0];
    }
    
    return self;
}

- (void)addNote:(TestModel *)note
{

    [_wilddog updateChildValues:[note toDict]];
    
}

- (void)updateNote:(TestModel *)note
{
    [_wilddog updateChildValues:[note toDict]];
}

- (void)deleteNoteWithID:(NSString *)noteID
{
    [[_wilddog childByAppendingPath:noteID] removeValue];
}

- (void)getAllNotes:(void (^)(NSArray *))complete
{
    WQuery *query = [_wilddog queryOrderedByChild:@"lastUpdate"];
    [query observeSingleEventOfType:WEventTypeValue withBlock:^(WDataSnapshot *snapshot) {
        if (snapshot) {
            NSMutableArray *noteList = [NSMutableArray new];
            [snapshot.value enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                TestModel *model = [[TestModel alloc] initWithDict:obj];
                [noteList addObject:model];
            }];
            if (complete) {
                complete(noteList);
            }
        }
    }];
}

- (void)getNotesWithPate:(int)page complete:(void (^)(NSArray *))complete
{
    
    BOOL isFirstPath = page == 0; //
    
    NSString *orderKey = @"lastUpdate";
    WQuery *query = [_wilddog queryOrderedByChild:orderKey];
    
    
    query = [query queryStartingAtValue:_lastUpdatetimeOnPrevPage];
    query = [query queryLimitedToFirst:kDefaultLimitPerPage + (isFirstPath ? 0 : 1)]; //queryStartingAtValue 是大于等于上次页最后一个的值，所以要 kDefaultLimitPerPage ＋ 1个，然后去掉这个上一页最后一个。
    [query observeSingleEventOfType:WEventTypeValue withBlock:^(WDataSnapshot *snapshot) {
        
        if (snapshot) {
            NSMutableArray *noteList = [NSMutableArray new];
            WDataSnapshot *child = nil;
            NSEnumerator *enumerator = snapshot.children;
            
            while (child = [enumerator nextObject]) {
                
                TestModel *model = [[TestModel alloc] initWithDict:[child value]];
                if ([self.lastUpdatetimeOnPrevPage longLongValue] == model.lastUpdate) {
                    continue; //去掉重复的一个
                }
                NSLog(@"model.lastUpdate %lld",model.lastUpdate);
                [noteList addObject:model];
            }
            
            if (noteList.count > 0) {
                self.lastUpdatetimeOnPrevPage = @([(TestModel *)noteList.lastObject lastUpdate]);
            }
            
            if (complete) {
                complete(noteList);
            }
        }
        
    } withCancelBlock:^(NSError *error) {
        
        
    }
     
     ];
    
}


@end
