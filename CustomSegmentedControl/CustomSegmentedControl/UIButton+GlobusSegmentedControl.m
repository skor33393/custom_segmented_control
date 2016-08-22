//
//  UIButton+GlobusSegmentedControl.m
//  CustomSegmentedControl
//
//  Created by Alexander Korenev on 22.08.16.
//  Copyright © 2016 Sphere. All rights reserved.
//

#import "UIButton+GlobusSegmentedControl.h"
#import <objc/runtime.h>

@implementation UIButton (GlobusSegmentedControl)

- (NSNumber *)gsc_index {
    return objc_getAssociatedObject(self, @selector(gsc_index));
}

- (void)setGsc_index:(NSNumber *)index {
    objc_setAssociatedObject(self, @selector(gsc_index), index, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
