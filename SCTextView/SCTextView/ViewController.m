//
//  ViewController.m
//  SCTextView
//
//  Created by tsc on 16/11/7.
//  Copyright © 2016年 DMS. All rights reserved.
//

#import "ViewController.h"
#import "SCTextView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SCTextView *textView = [[SCTextView alloc] init];
    
    textView.font = [UIFont systemFontOfSize:18];
    
    textView.frame = CGRectMake(0, 100, self.view.frame.size.width, 100);
    
//    textView.textColor = [UIColor lightGrayColor];
    
    textView.center = self.view.center;
    
    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    textView.placeHolder = @"说点什么呢...";
    
    textView.backgroundColor = [UIColor orangeColor];
    
    textView.maxCharacter = 40;
    
    [self.view addSubview:textView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
