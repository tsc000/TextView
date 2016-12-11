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
    ///输入的有效字符个数,用于计算显示的个数
    NSInteger _validCharacterLength;
    
    ///上次保存的字符串
    NSString *_lastText;
    
    ///新输入的包含emoji的字符串
    NSMutableString *_containEmojiString;
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
    
    self.type = WordCheckDefault;
    
    self.font = [UIFont systemFontOfSize:14];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
    _containEmojiString = [NSMutableString string];
    
    [self setupUI];
}

- (void)setupUI {

    self.placeHolderLabel = [self createLabel:CGRectZero];
    
    self.displayLabel = [self createLabel:CGRectZero];
    
}

+ (instancetype)textView:(NSString *)placeHolder Type:(WordCheck)type MaxCharacter:(NSInteger)maxCharacter {

    return [[self alloc] initWithPlaceHolder:placeHolder Type:type MaxCharacter:maxCharacter];
}

- (instancetype)initWithPlaceHolder:(NSString *)placeHolder Type:(WordCheck)type MaxCharacter:(NSInteger)maxCharacter {
    
    if (self = [self initWithFrame:CGRectZero]) {
        
        self.maxCharacter = maxCharacter;
        
        self.placeHolder = placeHolder;
        
        self.type = type;
    }
    
    return self;
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    
    self.placeHolderLabel.text = _placeHolder;
    
    [self updatePlaceholder];
    
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor {

    _placeHolderColor = placeHolderColor;
    
    self.placeHolderLabel.textColor = _placeHolderColor;
}

- (void)setMaxCharacter:(NSInteger)maxCharacter {

    _maxCharacter = maxCharacter;
    
    self.displayLabel.hidden = _maxCharacter <= 0 ? true : false;
}

#pragma mark -- UITextViewDelegate 监测字数改变

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {

    return true;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    self.placeHolderLabel.hidden = textView.text.length > 0 ? true: false;
   
    UITextRange *range = [self markedTextRange];
    
    //检测高亮文字输入，有高亮文字不计算个数
    if (range ) return;

    NSInteger count = [self caculateValidCharacter:self.text];
    
    if (self.maxCharacter <= 0) return;
    
    if (self.maxCharacter < count) {
        
        NSUInteger loaction = self.selectedRange.location;
    
        self.text = _lastText;
        
        self.selectedRange = NSMakeRange(loaction - 1 , 0);
    }
    else {
        _lastText = self.text;
    }

    [self updateDisplay];
}

#pragma mark --  判断有效字符(可能包含emoji)个数
- (NSInteger)caculateValidCharacter:(NSString *)text {

    __block NSInteger count = 0;
    
    [text enumerateSubstringsInRange:NSMakeRange(0, text.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
        count ++;
    }];
    
    return count;
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
    
    if (self.maxCharacter <= 0) return;
    
    //字数检测标签和输入字体大小一致
    self.displayLabel.font = self.font;
    
    NSInteger count = [self caculateValidCharacter:self.text];
    
    switch (_type) {
        case WordCheckDefault:
            
            self.displayLabel.text = [NSString stringWithFormat:@"您还可以输入%ld个文字",self.maxCharacter - count <= 0? 0:self.maxCharacter - count];
            
            break;
            
        case WordCheckNumber:
            
            self.displayLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.maxCharacter - count <= 0? 0:self.maxCharacter - count,self.maxCharacter];
            
            break;
        default:
            break;
    }
    
    
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
