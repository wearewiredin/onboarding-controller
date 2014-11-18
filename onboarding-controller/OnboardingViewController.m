//
//  OnboardingViewController.m
//  onboarding-controller
//
//  Created by Joshua Howland on 11/17/14.
//  Copyright (c) 2014 Wired In LLC. All rights reserved.
//

#import "OnboardingViewController.h"
#import "OnboardingViewData.h"

#import <FLKAutoLayout/UIView+FLKAutoLayout.h>

static CGFloat textContainerViewHeight = 206;
static CGFloat textContainerBottomMargin = 40;
static CGFloat labelMargin = 20;
static CGFloat maxFont = 22;

@interface OnboardingViewController ()

@property (nonatomic, strong) OnboardingViewData *data;

@property (nonatomic, strong) UIView *textContainerView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation OnboardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.textContainerView = [UIView new];
    self.textContainerView.backgroundColor = self.data.containerColor;
    [self.view addSubview:self.textContainerView];
    
    [self.textContainerView alignBottomEdgeWithView:self.view predicate:@"0.0"];
    [self.textContainerView alignLeadingEdgeWithView:self.view predicate:@"0.0"];
    [self.textContainerView alignTrailingEdgeWithView:self.view predicate:@"0.0"];
    [self.textContainerView constrainHeight:[@(textContainerViewHeight) stringValue]];

    self.label = [UILabel new];
    self.label.font = [self largestPossibleFont:self.data.text];
    self.label.text = self.data.text;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.adjustsFontSizeToFitWidth = NO;
    self.label.numberOfLines = 0;
    self.label.textColor = self.data.textColor;
    [self.view addSubview:self.label];
    
    [self.label alignTopEdgeWithView:self.textContainerView predicate:@"0.0"];
    [self.label alignLeadingEdgeWithView:self.textContainerView predicate:@"0.0"];
    [self.label alignTrailingEdgeWithView:self.textContainerView predicate:@"0.0"];
    [self.label alignBaselineWithView:self.textContainerView predicate:[@(-textContainerBottomMargin) stringValue]];
    
    self.imageView = [UIImageView new];
    if (self.data.image) {
        [self.imageView setImage:self.data.image];
    }
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    
    [self.imageView alignLeadingEdgeWithView:self.view predicate:@"0.0"];
    [self.imageView alignTrailingEdgeWithView:self.view predicate:@"0.0"];
    [self.imageView alignTopEdgeWithView:self.view predicate:@"0.0"];
    [self.imageView alignAttribute:NSLayoutAttributeBottom toAttribute:NSLayoutAttributeTop ofView:self.textContainerView predicate:@"0.0"];
    
}

- (void)updateWithData:(OnboardingViewData *)data {
    _data = data;
    self.textContainerView.backgroundColor = data.containerColor;
    
    self.label.textColor = data.textColor;
    self.label.font = [self largestPossibleFont:data.text];
    self.label.text = data.text;
    
    [self.imageView setImage:data.image];
}

- (UIFont *)largestPossibleFont:(NSString *)text {

    CGFloat maxHeight = textContainerViewHeight - textContainerBottomMargin - labelMargin;
    CGFloat maxWidth = self.view.frame.size.width - (labelMargin * 2);
    
    CGFloat fontSize = maxFont;
    UIFont *font;
    while (fontSize > 0.0)
    {
        font = [UIFont fontWithName:@"Avenir-Book" size:fontSize];
        
        CGRect textRect = [text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:NULL];
        
        if (textRect.size.height <= maxHeight) {
            break;
        }
        
        fontSize -= 1.0;
    }
    
    return font;
    
}


@end
