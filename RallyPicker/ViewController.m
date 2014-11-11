//
//  ViewController.m
//  RallyPicker
//
//  Created by Cristian Monterroza on 11/10/14.
//  Copyright (c) 2014 wrkstrm. All rights reserved.
//

#import "ViewController.h"
#import "RHPicker.h"

@interface ViewController () <RHPickerDelegate>

@property(nonatomic, strong) RHPicker *picker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *items = @[@"BEFORE BED", @"AFTER WAKING UP", @"AFTER BRUSHING TEETH", @"BEFORE WORK", @"AFTER GETTING TO WORK"];
    self.picker = [[RHPicker alloc] initWithParentView:self.view
                                             withItems:items
                                         selectedColor:[UIColor redColor]
                                          defaultColor:[UIColor grayColor]];
    self.picker.delegate = self;
}

- (void)picker:(RHPicker *)picker didSelectItem:(NSString *)string {
    NSLog(@"Item Selected: %@", string);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
