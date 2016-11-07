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

- (void)awakeFromNib {
    
    [super awakeFromNib];

//    [self updatePlaceholder];
//    
//    [self updateDisplay];
}

- (void)initial {

    ///添加观察者
    [self addObserver:self forKeyPath:kFONT options:NSKeyValueObservingOptionNew context:nil];
    
    ///添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];

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

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self updatePlaceholder];
    
    if (self.maxCharacter) {
        
        [self updateDisplay];
        
    }
}

- (void)textDidChange:(NSNotification *)notification {

    self.placeHolderLabel.hidden = self.text.length > 0 ? true: false;

    if (self.maxCharacter == 0) return;
    
    if (self.maxCharacter <= self.text.length) {

        self.text = [self.text substringWithRange:NSMakeRange(0, self.maxCharacter)];
    }

    NSString *tips = [NSString stringWithFormat:@"您还可以输入%ld个文字",self.maxCharacter - self.text.length];
    
    self.displayLabel.text = tips;
}


- (UILabel *)createLabel:(CGRect)frame {

    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    
    [self addSubview:label];
    
    return label;
}

#pragma mark 观察者
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
    
    self.displayLabel.text = [NSString stringWithFormat:@"您还可以输入%ld个文字",self.maxCharacter];
    
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

#pragma mark 析构
- (void)dealloc {
    [self removeObserver:self forKeyPath:kFONT];
}

@end
