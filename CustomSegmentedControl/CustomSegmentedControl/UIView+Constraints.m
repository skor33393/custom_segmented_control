//
//  UIView+Constraints.m
//  CustomSegmentedControl
//
//  Created by Alexander Korenev on 23.08.16.
//  Copyright © 2016 Sphere. All rights reserved.
//

#import "UIView+Constraints.h"

@implementation UIView (Constraints)

- (void)removeAllConstraints {
    UIView *superview = self.superview;
    while (superview != nil) {
        for (NSLayoutConstraint *c in superview.constraints) {
            if (c.firstItem == self || c.secondItem == self) {
                [superview removeConstraint:c];
            }
        }
        superview = superview.superview;
    }
    
    [self removeConstraints:self.constraints];
    self.translatesAutoresizingMaskIntoConstraints = YES;
}

@end
