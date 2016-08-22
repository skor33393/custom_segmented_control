//
//  GlobusSegmentedControl.m
//  CustomSegmentedControl
//
//  Created by Alexander Korenev on 22.08.16.
//  Copyright © 2016 Sphere. All rights reserved.
//

#import "GlobusSegmentedControl.h"
#import "GlobusSegmentedControlItem.h"
#import "UIView+Constraints.h"
#import "UIButton+GlobusSegmentedControl.h"

@interface GlobusSegmentedControl ()

@property (nonatomic, copy) NSArray<UIButton *> *itemButtons;
// Я использую layoutGuides для равного расстояния между items, если нужно поддерживать версии до ios 9.0 нужно использовать обычные UIView с прозрачным бэкграундом
@property (nonatomic, copy) NSArray<UILayoutGuide *> *layoutGuides;

@property (nonatomic, strong) UIView *containerView;

@end

@implementation GlobusSegmentedControl {
    CALayer *_lineLayer;
}

@synthesize items = _items;

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupView];
}

#pragma mark - View setup

- (void)setupView {
    self.itemButtons = [self populateButtonsForItems:self.items];
    self.layoutGuides = [self populateGuidesForItemsWithCount:self.items.count];
    
    self.containerView = [[UIView alloc] init];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.containerView];
    
    [self clearBackgroundColors];
    
    _lineLayer = [CALayer layer];
    [self.containerView.layer addSublayer:_lineLayer];
    _lineLayer.backgroundColor = self.normalItemBackgroundColor.CGColor;
    
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
}

#pragma mark - Layout

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.itemButtons.count == 1) {
        UIButton *const btn = self.itemButtons.firstObject;
        
        [self addVerticalConstraintsForButton:btn inView:self.containerView];
        [self addAspectRationConstraintForButton:btn];
        
        [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[btn]|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:NSDictionaryOfVariableBindings(btn)]];
    }
    else {
        [self.itemButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addVerticalConstraintsForButton:btn inView:self.containerView];
            [self addAspectRationConstraintForButton:btn];
            
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
            UIButton *const leftBtn = self.itemButtons[idx];
            UIButton *const rightBtn = self.itemButtons[idx + 1];
            
            [leftBtn.trailingAnchor constraintEqualToAnchor:guide.leadingAnchor].active = YES;
            [guide.trailingAnchor constraintEqualToAnchor:rightBtn.leadingAnchor].active = YES;
            
            if (idx == 0) {
                [guide.widthAnchor constraintEqualToConstant:self.interItemSpacing].active = YES;
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
    
    CGFloat height = CGRectGetHeight(self.containerView.bounds);
    _lineLayer.frame = CGRectMake(height / 2.0, 0.0, self.items.count ? CGRectGetWidth(self.containerView.bounds) - height : 0.0, self.lineHeight);
    _lineLayer.position = CGPointMake(CGRectGetMidX(self.containerView.bounds), CGRectGetMidY(self.containerView.bounds));
}

#pragma mark - Public methods

#pragma mark - Insert, remove, add

- (void)insertItem:(GlobusSegmentedControlItem *)item
           atIndex:(NSUInteger)idx {
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.items];
    [items insertObject:item atIndex:idx];
    self.items = items;
}

- (void)removeItemAtIndex:(NSUInteger)idx {
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.items];
    [items removeObjectAtIndex:idx];
    self.items = items;
}

- (void)addItem:(GlobusSegmentedControlItem *)item {
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.items];
    [items addObject:item];
    self.items = items;
}

#pragma mark - Private methods

#pragma mark - Target-action

- (void)didTapButton:(UIButton *)btn {
    [self unselectButtons];
    [self clearBackgroundColors];

    btn.selected = YES;
    btn.backgroundColor = self.selectedItemBackgroundColor;
    
    NSUInteger newIdx = [self.itemButtons indexOfObject:btn];
    
    if (newIdx != self.selectedItemIndex) {
        self.selectedItemIndex = newIdx;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark - Helpers

- (void)updateItems {
    // Меняю buttons и выставляю constraints по новой, так как это упрощает логику и так как в данном контроле не может быть большое кол-во items, performance не страдает
    // Для того, чтобы была возможна анимация, необходимо производить манипуляции с текущими констрейнтами и вьюхами
    [self.itemButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
        [btn removeFromSuperview];
    }];
    
    self.itemButtons = [self populateButtonsForItems:self.items];
    self.layoutGuides = [self populateGuidesForItemsWithCount:self.items.count];
    
    [self clearBackgroundColors];
    [self unselectButtons];
    
    [self addLayoutElementsToContainerView];
    
    [self setNeedsUpdateConstraints];
}

- (void)unselectButtons {
    for (UIButton *btn in self.itemButtons) {
        btn.selected = NO;
    }
}

- (void)clearBackgroundColors {
    for (UIButton *btn in self.itemButtons) {
        btn.backgroundColor = self.normalItemBackgroundColor;
    }
}

- (void)addLayoutElementsToContainerView {
    for (UIButton *btn in self.itemButtons) {
        [self.containerView addSubview:btn];
    }
    
    for (UILayoutGuide *gd in self.layoutGuides) {
        [self.containerView addLayoutGuide:gd];
    }
}

- (void)addVerticalConstraintsForButton:(UIButton *)btn inView:(UIView *)view {
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[btn]|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:NSDictionaryOfVariableBindings(btn)]];
}

- (void)addAspectRationConstraintForButton:(UIButton *)btn {
    [btn addConstraint:[NSLayoutConstraint constraintWithItem:btn
                                                    attribute:NSLayoutAttributeWidth
                                                    relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                       toItem:btn
                                                    attribute:NSLayoutAttributeHeight
                                                   multiplier:1.0 constant:0.0]];
}

- (NSArray<UIButton *> *)populateButtonsForItems:(NSArray<GlobusSegmentedControlItem *> *)items {
    NSMutableArray *btnsArray = [NSMutableArray array];
    
    for (GlobusSegmentedControlItem *item in items) {
        UIButton *const btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:NSSelectorFromString(@"didTapButton:") forControlEvents:UIControlEventTouchUpInside];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0.0, self.leftContentInset, 0.0, self.rightContentInset);
        [btn setTitle:item.normalStateTitle forState:UIControlStateNormal];
        [btn setTitle:item.selectedStateTitle forState:UIControlStateSelected];
        [btn setTitleColor:self.normatTitleTextColor forState:UIControlStateNormal];
        [btn setTitleColor:self.selectedTitleTextColor forState:UIControlStateSelected];
        btn.backgroundColor = self.normalItemBackgroundColor;
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

#pragma mark - Setters

- (void)setItems:(NSArray<GlobusSegmentedControlItem *> *)items {
    _items = [items copy];
    
    [self updateItems];
}

//#pragma mark - Test
//
//- (NSArray<GlobusSegmentedControlItem *> *)items {
//    if (!_items) {
//        NSMutableArray *tmpItems = [NSMutableArray array];
//        for (NSUInteger i = 0; i < 3; i++) {
//            NSString *const normalTitle = [NSString stringWithFormat:@"%@", @(i)];
//            NSString *const selectedTitle = [NSString stringWithFormat:@"%@ дня", @(i)];
//            GlobusSegmentedControlItem *const item = [[GlobusSegmentedControlItem alloc] initWithNormalStateTitle:normalTitle
//                                                                                               selectedStateTitle:selectedTitle];
//            [tmpItems addObject:item];
//        }
//        
//        _items = [tmpItems copy];
//    }
//    
//    return _items;
//}

@end
