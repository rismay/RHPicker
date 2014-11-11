//
//  UICollectionViewCell+CustomUIPicker.h
//  RallyPicker
//
//  Created by Cristian Monterroza on 11/10/14.
//  Copyright (c) 2014 wrkstrm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *itemLabel;
@property (nonatomic, strong) UIColor *defaultColor, *selectedColor;

- (void)prepareForItem:(NSString *)string
              fontSize:(CGFloat)fontSize
         selectedColor:(UIColor *)selectedColor
          defaultColor:(UIColor *)defaultColor;

- (void)setColorToSelected:(BOOL)selected;

- (void)scaleToRatio:(CGFloat)ratio;

- (void)pulseView:(BOOL)pulse;

- (void)pulseView:(BOOL)pulse withDelay:(CGFloat)delay;

@end
