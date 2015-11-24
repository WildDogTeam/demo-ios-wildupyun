//
//  TestService.h
//  WilddogImg
//
//  Created by IMacLi on 15/11/19.
//  Copyright © 2015年 liwuyang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TestModel.h"

@interface TestService : NSObject

- (void)addNote:(TestModel *)note;

- (void)updateNote:(TestModel *)note;

- (void)deleteNoteWithID:(NSString *)noteID;

- (void)getAllNotes:(void (^)(NSArray *))complete;

- (void)getNotesWithPate:(int)page complete:(void (^)(NSArray *))complete;

@end
