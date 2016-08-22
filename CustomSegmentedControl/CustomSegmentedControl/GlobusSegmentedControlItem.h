//
//  GlobusSegmentedControlItem.h
//  CustomSegmentedControl
//
//  Created by Alexander Korenev on 22.08.16.
//  Copyright © 2016 Sphere. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// Для показа необходимой информации контролу нужны лишь 2 строки. Для более гибкого решения можно использовать протокол, который будет требовать 2 метода возвращающие строки.

@interface GlobusSegmentedControlItem : NSObject

@property (nullable, nonatomic, strong, readonly) NSString *normalStateTitle;
@property (nullable, nonatomic, strong, readonly) NSString *selectedStateTitle;

- (instancetype)initWithNormalStateTitle:(nullable NSString *)normalStateTitle
                      selectedStateTitle:(nullable NSString *)selectedStateTitle NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END