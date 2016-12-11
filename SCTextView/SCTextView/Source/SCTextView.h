//
//  SCTextView.h
//  SCTextView
//
//  Created by Mac on 16/5/5.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    WordCheckDefault = 0,
    WordCheckNumber,
} WordCheck;

@interface SCTextView : UITextView

@property (nonatomic, copy) NSString *placeHolder;

@property (nonatomic, weak) UIColor *placeHolderColor;

@property (nonatomic, assign) NSInteger maxCharacter;

@property (nonatomic, assign) WordCheck type;

+ (instancetype)textView:(NSString *)placeHolder Type:(WordCheck)type MaxCharacter:(NSInteger)maxCharacter;

@end
