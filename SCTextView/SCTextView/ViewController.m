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
    
//    SCTextView *textView = [[SCTextView alloc] init];

    SCTextView *textView = [SCTextView textView:@"说点什么呢..." Type:WordCheckDefault MaxCharacter:-1];
    
    textView.font = [UIFont systemFontOfSize:18];
    
    textView.frame = CGRectMake(0, 100, self.view.frame.size.width, 100);
    
    textView.center = self.view.center;
    
    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    textView.backgroundColor = [UIColor orangeColor];
    
//    textView.placeHolder = @"说点什么呢...";
//
//    textView.maxCharacter = 40;
//    
//    textView.type = WordCheckDefault;
    
    [self.view addSubview:textView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
