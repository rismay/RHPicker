//
//  CustomUIPicker.h
//  RallyPicker
//
//  Created by Cristian Monterroza on 11/10/14.
//  Copyright (c) 2014 wrkstrm. All rights reserved.
//

@class RHPicker;

@protocol RHPickerDelegate <NSObject>
@optional
- (void)picker:(RHPicker *)picker didSelectItem:(NSString *)string;

@end

@interface RHPicker : UICollectionViewController

@property(nonatomic, strong, readwrite) NSArray *pickerItems;
@property(nonatomic, strong, readwrite) id <RHPickerDelegate> delegate;
@property(nonatomic, readwrite) NSUInteger currentIndex;
@property(nonatomic, strong, readwrite) UIColor *selectedColor;
@property(nonatomic, strong, readwrite) UIColor *defaultColor;

- (instancetype)initWithParentView:(UIView *)view
                         withItems:(NSArray *)items
                     selectedColor:(UIColor *)selectedColor
                      defaultColor:(UIColor *)defaultColor;

@end
