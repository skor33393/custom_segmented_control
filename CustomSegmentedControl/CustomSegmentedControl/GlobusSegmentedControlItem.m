//
//  GlobusSegmentedControlItem.m
//  CustomSegmentedControl
//
//  Created by Alexander Korenev on 22.08.16.
//  Copyright © 2016 Sphere. All rights reserved.
//

#import "GlobusSegmentedControlItem.h"

@interface GlobusSegmentedControlItem ()

@property (nullable, nonatomic, strong, readwrite) NSString *normalStateTitle;
@property (nullable, nonatomic, strong, readwrite) NSString *selectedStateTitle;

@end

@implementation GlobusSegmentedControlItem

- (instancetype)initWithNormalStateTitle:(NSString *)normalStateTitle
                      selectedStateTitle:(NSString *)selectedStateTitle {
    if (self = [super init]) {
        self.normalStateTitle = normalStateTitle;
        self.selectedStateTitle = selectedStateTitle;
    }
    
    return self;
}

@end
