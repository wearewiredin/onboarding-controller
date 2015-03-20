//
//  OnboardingViewController.m
//  onboarding-controller
//
//  Created by Joshua Howland on 11/17/14.
//  Copyright (c) 2014 Wired In LLC. All rights reserved.
//

#import "OnboardingViewController.h"
#import "OnboardingViewData.h"

#import "AlignedImageView.h"
#import "UIView+FLKAutoLayout.h"

static CGFloat textContainerViewHeight = 206;
static CGFloat textContainerBottomMargin = 40;
static CGFloat labelMargin = 20;
static CGFloat maxFont = 22;

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface OnboardingViewController () <UITextFieldDelegate>

@property (nonatomic, strong) OnboardingViewData *data;

@property (nonatomic, strong) UIView *textContainerView;
@property (nonatomic, strong) AlignedImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) NSLayoutConstraint *rightButtonHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *leftButtonHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *fieldHeightConstraint;

@property (nonatomic, assign) BOOL keyboardShown;
@property (nonatomic, assign) CGFloat keyboardOverlap;

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

    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Book" size:18];
    [self.rightButton setTitleColor:UIColorFromRGB(0xb41e23) forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"go"] forState:UIControlStateNormal];
    self.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 130, 0, 0);
    self.rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 50);
    self.rightButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    if (self.data) {
        switch (self.data.type) {
            case ViewTypeInfoLast:
                [self.rightButton addTarget:self action:@selector(skip:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case ViewTypeSignupLast:
                [self.rightButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
                break;
            default:
                break;
        }
    }
    [self.view addSubview:self.rightButton];
    
    [self.rightButton alignTrailingEdgeWithView:self.view predicate:@"0.0"];
    [self.rightButton alignBottomEdgeWithView:self.view predicate:@"-10.0"];
    self.rightButtonHeightConstraint = [self.rightButton constrainHeight:@"44"].firstObject;
    [self.rightButton constrainWidth:@"190"];
    
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Book" size:18];
    [self.leftButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    self.leftButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.leftButton addTarget:self action:@selector(skip:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.leftButton];
    
    [self.leftButton alignLeadingEdgeWithView:self.view predicate:@"0.0"];
    [self.leftButton alignBottomEdgeWithView:self.view predicate:@"-10.0"];
    self.leftButtonHeightConstraint = [self.leftButton constrainHeight:@"44"].firstObject;
    [self.leftButton constrainWidth:@"170"];

    self.emailField = [UITextField new];
    self.emailField.placeholder = @"your@email.com";
    self.emailField.font = [UIFont fontWithName:@"Avenir-Book" size:15];
    self.emailField.textAlignment = NSTextAlignmentCenter;
    self.emailField.layer.borderColor = UIColorFromRGB(0x666666).CGColor;
    self.emailField.layer.borderWidth = 1;
    self.emailField.layer.cornerRadius = 10;
    [self.view addSubview:self.emailField];
    
    [self.emailField alignLeadingEdgeWithView:self.view predicate:@"15"];
    [self.emailField alignTrailingEdgeWithView:self.view predicate:@"-15"];
    [self.emailField alignAttribute:NSLayoutAttributeBottom toAttribute:NSLayoutAttributeTop ofView:self.rightButton predicate:@"-5"];
    self.fieldHeightConstraint = [self.emailField constrainHeight:@"44"].firstObject;
    
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
    [self.label alignAttribute:NSLayoutAttributeBottom toAttribute:NSLayoutAttributeTop ofView:self.emailField predicate:@"-5.0"];
    
    self.imageView = [[AlignedImageView alloc] initWithImage:self.data.image];
    self.imageView.contentMode = UIViewContentModeBottom;
    [self.view addSubview:self.imageView];
    
    [self.imageView alignLeadingEdgeWithView:self.view predicate:@"0.0"];
    [self.imageView alignTrailingEdgeWithView:self.view predicate:@"0.0"];
    [self.imageView alignTopEdgeWithView:self.view predicate:@"0.0"];
    [self.imageView alignAttribute:NSLayoutAttributeBottom toAttribute:NSLayoutAttributeTop ofView:self.textContainerView predicate:@"0.0"];
    
    [self updateButtons];
    [self registerForKeyboardNotifications];
}

- (void)dealloc {
    [self removeObserveKeyboard];
}

- (void)updateWithData:(OnboardingViewData *)data {
    _data = data;
    self.textContainerView.backgroundColor = data.containerColor;
    
    self.label.textColor = data.textColor;
    self.label.font = [self largestPossibleFont:data.text];
    self.label.text = data.text;

    [self updateButtons];
    [self.imageView setImage:data.image];
}

- (void)updateButtons {
    switch (self.data.type) {
        case ViewTypeInfo:
            self.rightButton.hidden = YES;
            self.leftButton.hidden = YES;
            self.leftButtonHeightConstraint.constant = 0;
            self.rightButtonHeightConstraint.constant = 0;
            self.fieldHeightConstraint.constant = 0;
            break;
        case ViewTypeInfoLast:
            [self.rightButton setTitle:@"Let's Go" forState:UIControlStateNormal];
            self.rightButton.hidden = NO;
            self.leftButton.hidden = YES;
            self.leftButtonHeightConstraint.constant = 44;
            self.rightButtonHeightConstraint.constant = 44;
            self.fieldHeightConstraint.constant = 44;
            break;
        case ViewTypeSignupLast:
            [self.rightButton setTitle:@"Sign Up" forState:UIControlStateNormal];
            self.rightButton.hidden = NO;
            [self.leftButton setTitle:@"Maybe later" forState:UIControlStateNormal];
            self.leftButton.hidden = NO;
            self.leftButtonHeightConstraint.constant = 44;
            self.rightButtonHeightConstraint.constant = 44;
            self.fieldHeightConstraint.constant = 44;
            break;
    }
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self validateEmailWithString:self.emailField.text]) {
        [self submit:textField];
    } else {
        [self emailInvalid];
        return NO;
    }
    return YES;
}

- (void)submit:(id)sender {

    if (![self validateEmailWithString:self.emailField.text]) {
        [self emailInvalid];
        return;
    }
    
    [self.delegate viewController:self didSelectSubscribeEmail:self.emailField.text];
}

- (void)skip:(id)sender {
    [self.delegate viewControllerDidSelectSkip:self];
}

- (void)emailInvalid {

    NSString *title = @"Please enter a valid email address.";
    NSString *okay = @"Okay";
    
    if ([self isiOS8OrAbove]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:okay style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self.emailField becomeFirstResponder];
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title
                                                             message:nil
                                                            delegate:nil
                                                   cancelButtonTitle:okay
                                                   otherButtonTitles: nil];
        [alertView show];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (BOOL)isiOS8OrAbove {
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"8.0"
                                                                       options: NSNumericSearch];
    return (order == NSOrderedSame || order == NSOrderedDescending);
}

#pragma mark - Keyboard handling

- (void)registerForKeyboardNotifications {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)removeObserveKeyboard {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    if(self.keyboardShown)
        return;
    
    self.keyboardShown = YES;
    
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [self.view convertRect:[aValue CGRectValue] fromView:nil];
    
    // Get the keyboard's animation details
    NSTimeInterval animationDuration;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    UIViewAnimationCurve animationCurve;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    
    // Determine how much overlap exists between tableView and the keyboard
    CGRect frame = self.view.frame;
    CGFloat bottomCoordinate = frame.origin.y + frame.size.height;

    [self setKeyboardOverlap:bottomCoordinate - keyboardRect.origin.y];
    if([self keyboardOverlap] < 0) {
        [self setKeyboardOverlap:0];
    }
    
    if([self keyboardOverlap] != 0)
    {
        
        NSTimeInterval delay = 0;
        if(keyboardRect.size.height)
        {
            delay = (1 - [self keyboardOverlap]/keyboardRect.size.height)*animationDuration;
            animationDuration = animationDuration * [self keyboardOverlap]/keyboardRect.size.height;
        }
        
        [UIView animateWithDuration:animationDuration animations:^{
            self.view.frame = CGRectOffset(self.view.frame, 0, -self.keyboardOverlap);
        } completion:^(BOOL finished) {
            
        }];
        
    }
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    if(![self keyboardShown])
        return;
    
    [self setKeyboardShown:NO];
    
    if([self keyboardOverlap] == 0) {
        return;
    }
    
    // Get the size & animation details of the keyboard
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [self.view convertRect:[aValue CGRectValue] fromView:nil];
    
    NSTimeInterval animationDuration;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    UIViewAnimationCurve animationCurve;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    
    
    if(keyboardRect.size.height) {
        animationDuration = animationDuration * [self keyboardOverlap]/keyboardRect.size.height;
    }
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.view.frame = CGRectOffset(self.view.frame, 0, self.keyboardOverlap);
    }];
    
}

- (BOOL)validateEmailWithString:(NSString*)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


@end
