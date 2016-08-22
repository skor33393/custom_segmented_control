//
//  ViewController.m
//  CustomSegmentedControl
//
//  Created by Alexander Korenev on 22.08.16.
//  Copyright © 2016 Sphere. All rights reserved.
//

#import "ViewController.h"
#import "GlobusSegmentedControl.h"
#import "GlobusSegmentedControlItem.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet GlobusSegmentedControl *segmentedControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *const items = [NSMutableArray array];
    for (NSUInteger i = 0; i < 3; i++) {
        NSString *const normalTitle = [NSString stringWithFormat:@"%@", @(i)];
        NSString *const selectedTitle = [NSString stringWithFormat:@"%@ дня", @(i)];
        GlobusSegmentedControlItem *const item = [[GlobusSegmentedControlItem alloc] initWithNormalStateTitle:normalTitle
                                                                                           selectedStateTitle:selectedTitle];
        [items addObject:item];
    }
    
    self.segmentedControl.items = items;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentedControlValueChanged:(id)sender {
    GlobusSegmentedControl *const gsc = (GlobusSegmentedControl *)sender;
    NSLog(@"%@ selected", @(gsc.selectedItemIndex));
}

- (IBAction)addItem:(id)sender {
    [self.segmentedControl addItem:[self testItem]];
}

- (IBAction)removeItem:(id)sender {
    [self.segmentedControl removeItemAtIndex:0];
}

- (IBAction)insertItem:(id)sender {
    if (self.segmentedControl.items.count >= 2) {
        [self.segmentedControl insertItem:[self testItem] atIndex:1];
    }
    else {
        [self.segmentedControl insertItem:[self testItem] atIndex:0];
    }
}

- (GlobusSegmentedControlItem *)testItem {
    return [[GlobusSegmentedControlItem alloc] initWithNormalStateTitle:@"Added" selectedStateTitle:@"Added item"];
}

@end
