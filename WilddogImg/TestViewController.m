//
//  TestViewController.m
//  WilddogImg
//
//  Created by IMacLi on 15/11/19.
//  Copyright © 2015年 liwuyang. All rights reserved.
//

#import "TestViewController.h"
#import "TestModel.h"
#import "TestService.h"
#import "TestCell.h"
#import "SVPullToRefresh.h"
#import <Wilddog/Wilddog.h>
@interface TestViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end

@implementation TestViewController
{
    TestService *_testService;
    NSMutableArray *_testList;
    int _currentPage;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        _testList = [NSMutableArray new];
        _testService = [[TestService alloc] init];

        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadNotes];
    
    [self.mTableView addInfiniteScrollingWithActionHandler:^{
       
        [_testService getNotesWithPate:_currentPage  complete:^(NSArray *array) {

            [_testList addObjectsFromArray:array];
            [_mTableView reloadData];
            [self.mTableView.infiniteScrollingView stopAnimating];
            _currentPage++;
            self.mTableView.showsInfiniteScrolling = array.count > 0;
            
            
        }];
        
    }];

    
}

- (void)loadNotes
{
    
    [_testService getNotesWithPate:_currentPage complete:^(NSArray *array) {
        [_testList addObjectsFromArray:array];
        [_mTableView reloadData];
    }];

}



#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _testList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TestCell";
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TestCell" owner:self options:nil] lastObject];
        
    }
    
    
    TestModel *note = [_testList objectAtIndex:indexPath.row];
    [cell setCellValues:note];
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.f;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
