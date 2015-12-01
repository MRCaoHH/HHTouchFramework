//
//  HHFrameworkAPI.m
//  HHTouchFramework
//
//  Created by caohuihui on 15/11/30.
//  Copyright © 2015年 caohuihui. All rights reserved.
//

#import "HHFrameworkAPI.h"
#import "HHMainViewController.h"
#import "HHOtheViewController.h"


@implementation HHFrameworkAPI

+(id)getMainViewController
{
    HHMainViewController * mainView = [[HHMainViewController alloc]init];
    return mainView;
}

+(id)getOtheViewController
{
    HHOtheViewController * otheView = [[HHOtheViewController alloc]init];
    return otheView;
}

@end
