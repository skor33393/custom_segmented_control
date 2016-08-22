//
//  GlobusSegmentedControl.m
//  CustomSegmentedControl
//
//  Created by Alexander Korenev on 22.08.16.
//  Copyright © 2016 Sphere. All rights reserved.
//

#import "GlobusSegmentedControl.h"
#import "GlobusSegmentedControlItem.h"

@interface GlobusSegmentedControl ()

@property (nonatomic, strong) NSArray<GlobusSegmentedControlItem *> *items;
@property (nonatomic, strong) NSArray<UIButton *> *itemButtons;
@property (nonatomic, strong) NSArray<UILayoutGuide *> *layoutGuides;

@property (nonatomic, strong) UIView *containerView;

@end

@implementation GlobusSegmentedControl

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupView];
    }
    
    return self;
}

#pragma mark - View setup

- (void)setupView {
    self.itemButtons = [self populateButtonsForItems:self.items];
    self.layoutGuides = [self populateGuidesForItemsWithCount:self.items.count];
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.containerView.backgroundColor = [UIColor greenColor];
    [self addSubview:self.containerView];
    
    self.backgroundColor = [UIColor redColor];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0 constant:0.0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[container]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:@{@"container": self.containerView}]];
    
    if (self.itemButtons.count == 1) {
        UIButton *const btn = self.itemButtons.firstObject;
        [self.containerView addSubview:btn];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[btn]|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:NSDictionaryOfVariableBindings(btn)]];
        [btn addConstraint:[NSLayoutConstraint constraintWithItem:btn
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:btn
                                                                attribute:NSLayoutAttributeHeight
                                                               multiplier:1.0 constant:0.0]];
    }
    else {
        [self.itemButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
            GlobusSegmentedControlItem *const item = self.items[idx];
            btn.translatesAutoresizingMaskIntoConstraints = NO;
            [btn setTitle:item.normalStateTitle forState:UIControlStateNormal];
            [btn setTitle:item.selectedStateTitle forState:UIControlStateSelected];
            btn.backgroundColor = [UIColor orangeColor];
            
            [self.containerView addSubview:btn];
            [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[btn]|"
                                                                                       options:0
                                                                                       metrics:nil
                                                                                         views:NSDictionaryOfVariableBindings(btn)]];
            [btn addConstraint:[NSLayoutConstraint constraintWithItem:btn
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                               toItem:btn
                                                            attribute:NSLayoutAttributeHeight
                                                           multiplier:1.0 constant:0.0]];
            if (idx == 0) {
                [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[btn]"
                                                                                           options:0
                                                                                           metrics:nil
                                                                                             views:NSDictionaryOfVariableBindings(btn)]];
            }
            else if (idx == self.itemButtons.count - 1) {
                [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[btn]|"
                                                                                           options:0
                                                                                           metrics:nil
                                                                                             views:NSDictionaryOfVariableBindings(btn)]];
            }
            
        }];
        
        
        [self.layoutGuides enumerateObjectsUsingBlock:^(UILayoutGuide * _Nonnull guide, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.containerView addLayoutGuide:guide];
        }];
        
        [self.layoutGuides enumerateObjectsUsingBlock:^(UILayoutGuide * _Nonnull guide, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *const leftBtn = self.itemButtons[idx];
            UIButton *const rightBtn = self.itemButtons[idx + 1];
            
            [leftBtn.trailingAnchor constraintEqualToAnchor:guide.leadingAnchor].active = YES;
            [guide.trailingAnchor constraintEqualToAnchor:rightBtn.leadingAnchor].active = YES;
            
            if (idx == 0) {
                [guide.widthAnchor constraintEqualToConstant:10.0].active = YES;
                return ;
            }
            
            UILayoutGuide *const prevGuide = self.layoutGuides[idx - 1];
            [prevGuide.widthAnchor constraintEqualToAnchor:guide.widthAnchor].active = YES;
            
            
        }];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat cornerRadius = CGRectGetHeight(self.containerView.bounds) / 2.0f;
    for (UIButton *btn in self.itemButtons) {
        btn.layer.cornerRadius = cornerRadius;
    }
}

#pragma mark - Helpers

- (NSArray<UIButton *> *)populateButtonsForItems:(NSArray<GlobusSegmentedControlItem *> *)items {
    NSMutableArray *btnsArray = [NSMutableArray array];
    
    for (GlobusSegmentedControlItem *item in items) {
        UIButton *const btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:item.normalStateTitle forState:UIControlStateNormal];
        [btn setTitle:item.selectedStateTitle forState:UIControlStateNormal];
        [btnsArray addObject:btn];
    }
    
    return [btnsArray copy];
}

- (NSArray<UILayoutGuide *> *)populateGuidesForItemsWithCount:(NSUInteger)count {
    if (count < 2) {
        return nil;
    }
    
    NSMutableArray *lgsArray = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < count - 1; i++) {
        UILayoutGuide *const guide = [[UILayoutGuide alloc] init];
        [lgsArray addObject:guide];
    }
    
    return [lgsArray copy];
}

#pragma mark - Lazy initialization

- (NSArray<GlobusSegmentedControlItem *> *)items {
    if (!_items) {
        NSMutableArray *tmpItems = [NSMutableArray array];
        for (NSUInteger i = 0; i < 2; i++) {
            NSString *const normalTitle = [NSString stringWithFormat:@"%@", @(i)];
            NSString *const selectedTitle = [NSString stringWithFormat:@"%@ дня", @(i)];
            GlobusSegmentedControlItem *const item = [[GlobusSegmentedControlItem alloc] initWithNormalStateTitle:normalTitle
                                                                                               selectedStateTitle:selectedTitle];
            [tmpItems addObject:item];
        }
        
        _items = [tmpItems copy];
    }
    
    return _items;
}

//- (NSArray<UIButton *> *)itemButtons {
//    if (!_itemButtons) {
//        _itemButtons = [NSArray array];
//    }
//    
//    return _itemButtons;
//}
//
//- (NSArray<UILayoutGuide *> *)layoutGuides {
//    if (!_layoutGuides) {
//        _layoutGuides = [NSArray array];
//    }
//    
//    return _layoutGuides;
//}

@end
