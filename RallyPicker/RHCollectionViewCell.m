//
//  UICollectionViewCell+CustomUIPicker.m
//  RallyPicker
//
//  Created by Cristian Monterroza on 11/10/14.
//  Copyright (c) 2014 wrkstrm. All rights reserved.
//

#import "RHCollectionViewCell.h"

@interface RHCollectionViewCell ()

@property (nonatomic) CGFloat fontSize;
@property (nonatomic, strong) NSString *itemString;

@property (nonatomic, strong) NSMutableParagraphStyle *style;
@property (nonatomic, strong) UIFontDescriptor *descriptor;
@property (nonatomic, strong) UIFont *font;

@property (nonatomic) CGAffineTransform identityTransform;

@property (nonatomic, getter=isCurrentlySelected) BOOL currentlySelected;

@end

@implementation RHCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        _identityTransform = self.transform;
    }
    return self;
}

- (void)prepareForItem:(NSString *)string
              fontSize:(CGFloat)fontSize
         selectedColor:(UIColor *)selectedColor
          defaultColor:(UIColor *)defaultColor {
    self.selectedColor = selectedColor;
    self.defaultColor = defaultColor;
    self.itemString = string;
    
    CGFloat cellWidth = CGRectGetWidth(self.frame);
    CGFloat cellHeight = CGRectGetHeight(self.frame);
    
    self.itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                               cellWidth,
                                                               cellHeight)];
    [self addSubview:self.itemLabel];
    self.itemLabel.center = CGPointMake(cellWidth / 2, cellHeight / 2);
    
    self.style = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
    self.style.alignment = NSTextAlignmentCenter;
    self.descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle: UIFontTextStyleHeadline];
    self.font = [UIFont fontWithDescriptor:self.descriptor size:self.fontSize];
    
    [self setText];
    __weak UILabel *weakLabel = self.itemLabel;
    @weakify(self);
    [[self.rac_prepareForReuseSignal takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self);
        [weakLabel removeFromSuperview];
        self.transform = self.identityTransform;
    }];
}

- (void)setColorToSelected:(BOOL)selected {
    if (self.isCurrentlySelected != selected) {
        self.currentlySelected = selected;
        [self setText];
        if (self.isCurrentlySelected) {
            [self shimmerFor:1.0];
        } else {
            [self stopShimmering];
        }
    }
}

- (void)setText {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.itemString
                                                                             attributes:@{NSParagraphStyleAttributeName:self.style,
                                                                                          NSFontAttributeName:self.font,
                                                                                          NSForegroundColorAttributeName:self.isCurrentlySelected ? self.selectedColor : self.defaultColor}];
    self.itemLabel.attributedText = text;
}

- (void)scaleToRatio:(CGFloat)ratio {
    self.transform = CGAffineTransformScale(self.identityTransform, ratio, ratio);
}


- (void)shimmerFor:(NSTimeInterval)timeInterval {
    [self startShimmeringAtInterval:timeInterval];
    WSM_DISPATCH_AFTER(timeInterval, {
        [self stopShimmering];
    });
}

- (void)startShimmeringAtInterval:(NSTimeInterval)duration {
    id light = (id)[UIColor colorWithWhite:0 alpha:0.25].CGColor;
    id dark  = (id)[UIColor blackColor].CGColor;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = @[dark, light, dark];
    gradient.frame = CGRectMake(-self.bounds.size.width, 0, 3*self.bounds.size.width, self.bounds.size.height);
    gradient.startPoint = CGPointMake(0.0, 0.5);
    gradient.endPoint   = CGPointMake(1.0, 0.525); // slightly slanted forward
    gradient.locations  = @[@0.4, @0.5, @0.6];
    self.layer.mask = gradient;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
    animation.fromValue = @[@0.0, @0.1, @0.2];
    animation.toValue   = @[@0.8, @0.9, @1.0];
    
    animation.duration = 1.0;
    animation.repeatCount = HUGE_VALF;
    [gradient addAnimation:animation forKey:@"shimmer"];
}

- (void)stopShimmering {
    self.layer.mask = nil;
}

@end
