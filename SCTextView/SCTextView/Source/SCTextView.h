//
//  SCTextView.h
//  SCTextView
//
//  Created by Mac on 16/5/5.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    WordCheckDefault,
    WordCheckNumber,
} WordCheck;

@interface SCTextView : UITextView

@property (nonatomic, copy) NSString *placeHolder;

@property (nonatomic, assign) NSInteger maxCharacter;

@property (nonatomic, assign) WordCheck type;

@end
