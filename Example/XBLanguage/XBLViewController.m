//
//  XBLViewController.m
//  XBLanguage
//
//  Created by eugenenguyen on 01/07/2015.
//  Copyright (c) 2014 eugenenguyen. All rights reserved.
//

#import "XBLViewController.h"
#import <XBLanguage.h>

@interface XBLViewController ()

@end

@implementation XBLViewController

- (void)viewDidLoad
{
    UILabel
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdate:) name:XBLanguageUpdatedLanguage object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didUpdate:(NSNotification *)notification
{
    NSLog(@"%@", notification.object);
}

@end
