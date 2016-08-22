//
//  GlobusSegmentedControlItem.h
//  CustomSegmentedControl
//
//  Created by Alexander Korenev on 22.08.16.
//  Copyright © 2016 Sphere. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GlobusSegmentedControlItem : NSObject

@property (nullable, nonatomic, strong, readonly) NSString *normalStateTitle;
@property (nullable, nonatomic, strong, readonly) NSString *selectedStateTitle;

- (instancetype)initWithNormalStateTitle:(nullable NSString *)normalStateTitle
                      selectedStateTitle:(nullable NSString *)selectedStateTitle NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END