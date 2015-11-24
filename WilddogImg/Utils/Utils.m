//
//  Utils.m
//  WDIntelligentBulb
//
//  Created by IMacLi on 15/8/10.
//  Copyright (c) 2015年 liwuyang. All rights reserved.
//

#import "Utils.h"

#import "MBProgressHUD.h"

@implementation Utils


+(void)showProgressHUdWithText:(NSString*)text showInView:(UIView *)view
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide=YES;
    [hud setLabelText:text];
    [hud show:YES];
    
}


+(void)hidenProgressHUdshowInView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

@end













































