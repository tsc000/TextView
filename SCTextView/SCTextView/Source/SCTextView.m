//
//  SCTextView.m
//  SCTextView
//
//  Created by Mac on 16/5/5.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "SCTextView.h"

#define kFONT @"font"
#define MARGINX (5)
#define MARGINY (8)

@interface SCTextView()
<
    UITextViewDelegate
>
{
    ///输入的有效字符个数
    NSInteger _validCharacterCount;
    
    //新输入的字符串
    NSString *_inputString;
}

///占位文字
@property (nonatomic, strong) UILabel *placeHolderLabel;

///字数检查和显示
@property (nonatomic, strong) UILabel *displayLabel;

@end

@implementation SCTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initial];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self initial];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self updatePlaceholder];
    
    if (self.maxCharacter) {
        
        [self updateDisplay];
        
    }
}

- (void)initial {
    
    self.delegate = self;
    
    [self setupUI];
}

- (void)setupUI {

    self.placeHolderLabel = [self createLabel:CGRectZero];
    
    self.displayLabel = [self createLabel:CGRectZero];
    
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    
    self.placeHolderLabel.text = _placeHolder;
    
    [self updatePlaceholder];
    
}

#pragma mark -- UITextViewDelegate 监测字数改变

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {

    _inputString = text;
    
    [text enumerateSubstringsInRange:NSMakeRange(0, text.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {

        BOOL isEmoji = [self stringContainsEmoji:substring];

        if (isEmoji) {
            _validCharacterCount ++;
        }
        else {

            if (![substring isEqualToString:@" "] && ![substring isEqualToString:@"\n"]) {

                _validCharacterCount ++;
            }

        }

        NSLog(@"isEmoji       :%d",isEmoji);
        NSLog(@"substring     :%@",substring);

        NSLog(@"substringRange:%lu,length:%lu",(unsigned long)substringRange.location,substringRange.length);

        NSLog(@"enclosingRange:%lu,length:%lu \n\n",(unsigned long)enclosingRange.location,enclosingRange.length);
        
    }];
    
    return true;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    
//    [textView.text enumerateSubstringsInRange:NSMakeRange(0, textView.text.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
//        
//        BOOL isEmoji = [self stringContainsEmoji:substring];
//        
//        if (isEmoji) {
//            _validCharacterCount ++;
//        }
//        else {
//            
//            if (![substring isEqualToString:@" "] && ![substring isEqualToString:@"\n"]) {
//                
//                _validCharacterCount ++;
//            }
//            
//        }
//        
//        NSLog(@"isEmoji       :%d",isEmoji);
//        NSLog(@"substring     :%@",substring);
//        
//        NSLog(@"substringRange:%lu,length:%lu",(unsigned long)substringRange.location,substringRange.length);
//        
//        NSLog(@"enclosingRange:%lu,length:%lu \n\n",(unsigned long)enclosingRange.location,enclosingRange.length);
//        
//    }];
    
    UITextRange *ranges = [textView markedTextRange];
    
    NSLog(@"%ld-%@-%@-%@",textView.text.length,textView.text,ranges.start,ranges.end);
    
    self.placeHolderLabel.hidden = self.text.length > 0 ? true: false;
    
    //检测高亮文字输入
    UITextRange *range = [self markedTextRange];
    
    if (range) return;
    
    
    
    if (self.maxCharacter <= self.text.length) {
        
        self.text = [self.text substringWithRange:NSMakeRange(0, self.maxCharacter)];
    }

    [self updateDisplay];
}


- (UILabel *)createLabel:(CGRect)frame {

    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    
    [self addSubview:label];
    
    return label;
}

#pragma mark --  判断emoji
- (BOOL)stringContainsEmoji:(NSString *)string{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

#pragma mark --  观察者
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"font"]) {
        [self updatePlaceholder];
    }
}

- (void)updatePlaceholder {
    
    //占位文字字体和输入字体大小一致
    self.placeHolderLabel.font = self.font;
    
    NSDictionary *attribute = @{NSFontAttributeName:self.placeHolderLabel.font};
    
    CGSize size = CGSizeMake(self.frame.size.width - MARGINX, self.frame.size.height);
    
    CGSize retSize = [self.placeHolder boundingRectWithSize:size
                                               options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                            attributes:attribute
                                               context:nil].size;
    
    CGRect frame = self.placeHolderLabel.frame;
    
    frame.origin = CGPointMake(MARGINX + self.textContainerInset.left, self.textContainerInset.top);
    
    frame.size = retSize;
    
    self.placeHolderLabel.frame = frame;
}

- (void)updateDisplay {
    
    //字数检测标签和输入字体大小一致
    self.displayLabel.font = self.font;
    
    self.displayLabel.text = [NSString stringWithFormat:@"您还可以输入%ld个文字",self.maxCharacter - self.text.length];
    
    NSDictionary *attribute = @{NSFontAttributeName:self.displayLabel.font};
    
    CGSize size = CGSizeMake(self.frame.size.width - MARGINX, self.frame.size.height);
    
    CGSize retSize = [self.displayLabel.text boundingRectWithSize:size
                                                    options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                 attributes:attribute
                                                    context:nil].size;
    
    CGRect frame = self.displayLabel.frame;
    
    frame.origin = CGPointMake(self.frame.size.width - retSize.width - 10, self.frame.size.height - retSize.height - 10);
    
    frame.size = retSize;
    
    self.displayLabel.frame = frame;
}

@end
