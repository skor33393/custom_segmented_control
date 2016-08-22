//
//  GlobusSegmentedControl.h
//  CustomSegmentedControl
//
//  Created by Alexander Korenev on 22.08.16.
//  Copyright © 2016 Sphere. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GlobusSegmentedControlItem;

NS_ASSUME_NONNULL_BEGIN

@interface GlobusSegmentedControl : UIControl

@property (nonatomic, copy) NSArray<GlobusSegmentedControlItem *> *items;

@property (nonatomic, strong) IBInspectable UIColor *normatTitleTextColor;
@property (nonatomic, strong) IBInspectable UIColor *selectedTitleTextColor;
@property (nonatomic, strong) IBInspectable UIColor *normalItemBackgroundColor;
@property (nonatomic, strong) IBInspectable UIColor *selectedItemBackgroundColor;

@property (nonatomic) IBInspectable CGFloat lineHeight;

@property (nonatomic) IBInspectable CGFloat interItemSpacing;

@property (nonatomic) IBInspectable CGFloat leftContentInset;
@property (nonatomic) IBInspectable CGFloat rightContentInset;

@property (nonatomic) NSUInteger selectedItemIndex;

- (void)insertItem:(GlobusSegmentedControlItem *)item
           atIndex:(NSUInteger)idx;

- (void)removeItemAtIndex:(NSUInteger)idx;

- (void)addItem:(GlobusSegmentedControlItem *)item;

@end

NS_ASSUME_NONNULL_END