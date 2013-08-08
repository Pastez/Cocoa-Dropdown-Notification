//
//  PSDropNotification.m
//  QuickDropdownNotificationExample
//
//  Created by Tomasz Kwolek on 07.08.2013.
//  Copyright (c) 2013 Pastez 2013 www.pastez.com. All rights reserved.
//

#import "PSDropdownNotificationCenter.h"
#import "PSDropdownNotificationView.h"

#define DEFAULT_DISPLAY_DURATION    7.0f

#pragma mark PSDropdownNotificationData

@class PSDropdownNotificationCenter;

@implementation PSDropdownNotificationData

- (id)initWithTitle:(NSString *)title message:(NSString *)message
{
    self = [self initWithTitle:title message:message andImage:nil];
    return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message andImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.title              = title;
        self.message            = message;
        self.image              = image;
        self.displayDuration    = DEFAULT_DISPLAY_DURATION;
        self.apperiance         = [[PSDropdownNotificationCenter apperiance] copy];
    }
    return self;
}

@end

#pragma mark PSDropdownNotificationApperiance

@implementation PSDropdownNotificationApperiance

- (id)init
{
    self = [super init];
    if (self) {
        //apply default values
        self.shadowOpacity              = 0.5f;
        self.verticalMargin             = 5.0f;
        self.horizontalMargin           = 5.0f;
        self.imageWidth                 = 40.0f;
        self.imageHSpacing              = 2.0f;
        self.titleVSpacing              = 3.0f;
        self.titleFont                  = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0f];
        self.messageFont                = [UIFont fontWithName:@"HelveticaNeue" size:11.0f];
        self.backgroundColor            = [UIColor darkGrayColor];
        self.backgroundImage            = nil;
        self.titleColor                 = [UIColor whiteColor];
        self.messageColor               = [UIColor lightGrayColor];
        self.bottomHLineColor           = [UIColor colorWithWhite:0.15 alpha:1.0];
    }
    return self;
}

- (id)copy
{
    PSDropdownNotificationApperiance *apperianceCopy = [[PSDropdownNotificationApperiance alloc] init];
    apperianceCopy.shadowOpacity        = self.shadowOpacity;
    apperianceCopy.verticalMargin       = self.verticalMargin;
    apperianceCopy.horizontalMargin     = self.horizontalMargin;
    apperianceCopy.imageWidth           = self.imageWidth;
    apperianceCopy.imageHSpacing        = self.imageHSpacing;
    apperianceCopy.titleVSpacing        = self.titleVSpacing;
    apperianceCopy.titleFont            = self.titleFont;
    apperianceCopy.messageFont          = self.messageFont;
    apperianceCopy.backgroundColor      = self.backgroundColor;
    apperianceCopy.backgroundImage      = self.backgroundImage;
    apperianceCopy.titleColor           = self.titleColor;
    apperianceCopy.messageColor         = self.messageColor;
    apperianceCopy.bottomHLineColor     = self.bottomHLineColor;
    return apperianceCopy;
}

@end

#define DEFAULT_VIEW_HEIGHT     50.0f
#define DEFAULT_MAX_VISIBLE_NOTIFICATIONS UINT_MAX
#define DEFAULT_NOTIFICATION_SHOW_DIRECTION PSNotificationShowDirectionFromTop
#define EASE_DISTANCE 50

#pragma mark PSDropdownNotificationCenter

@interface PSDropdownNotificationCenter()
{
    float notificationDy;
}

@property (assign,nonatomic) UIWindow* applicationWindow;
@property (strong,nonatomic) NSMutableArray *visibleNotifications;
@property (strong,nonatomic) NSMutableDictionary *timers;

@end

@implementation PSDropdownNotificationCenter

NSString * const PSNotificationCenterEventShowNotification = @"psEventShowNotification";

#pragma mark initialization

+ (PSDropdownNotificationCenter*)sharedInstance {
    static dispatch_once_t onceToken;
    static PSDropdownNotificationCenter *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super alloc] initUniqueInstance];
    });
    return sharedInstance;
}

- (PSDropdownNotificationCenter*)initUniqueInstance {
    self = [super init];
    if (self) {
        notificationDy = 0;
        self.visibleNotifications = [NSMutableArray array];
        
        self.maxVisibleNotifications = DEFAULT_MAX_VISIBLE_NOTIFICATIONS;
        self.notificationShowDirection = DEFAULT_NOTIFICATION_SHOW_DIRECTION;
        self.applicationWindow = [[[UIApplication sharedApplication] delegate] window];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowNotificationEvent:) name:PSNotificationCenterEventShowNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark notifications

- (void)onShowNotificationEvent:(NSNotification*)notification
{
    if ([notification.object isKindOfClass:[PSDropdownNotificationData class]]) {
        [self showNotification:notification.object];
    }else
    {
        NSLog(@"Object passed in notification is not kind of PSDropdownNotificationData");
    }
}

- (void)showNotification:(PSDropdownNotificationData*)notificationData
{
    if (_visibleNotifications.count >= _maxVisibleNotifications) {
        [self hideNotification:_visibleNotifications[0]];
    }
    
    CGRect notificationFrame = CGRectMake(0, 0, 320, DEFAULT_VIEW_HEIGHT);
    PSDropdownNotificationView *notification = [[PSDropdownNotificationView alloc] initWithFrame:notificationFrame
                                                                             andNotificationData:notificationData];
    [_visibleNotifications addObject:notification];
    CGRect destinationFrame = notification.frame;
    
    //add status bar height
    if (![UIApplication sharedApplication].statusBarHidden) {
        destinationFrame.origin.y += [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    
    CGRect startFrame = destinationFrame;
    
    if (_notificationShowDirection == PSNotificationShowDirectionFromTop)
    {
        startFrame.origin.y -= CGRectGetHeight(notification.frame);
    }
    else
    {
        destinationFrame.origin.y += notificationDy;
        startFrame.origin.y = destinationFrame.origin.y + EASE_DISTANCE;
    }
    notificationDy += CGRectGetHeight(notification.frame);
    notification.frame = startFrame;
    

    if (_visibleNotifications.count == 0) {
        [_applicationWindow addSubview:notification];
    }
    else
    {
        [_applicationWindow insertSubview:notification aboveSubview:_visibleNotifications[_visibleNotifications.count-1]];
    }
    
    //show notification
    [notification show];
    [UIView animateWithDuration:0.4 animations:^{
        
        notification.frame = destinationFrame;
        
        if (_notificationShowDirection == PSNotificationShowDirectionFromTop) {
            for (PSDropdownNotificationView *oldNotification in _visibleNotifications) {
                if (oldNotification != notification) {
                    CGRect newFrame = oldNotification.frame;
                    newFrame.origin.y += CGRectGetHeight(destinationFrame);
                    oldNotification.frame = newFrame;
                }
            }
        }
        
    } completion:^(BOOL finished) {
        //
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideNotification:)];
    notification.gestureRecognizers = @[tapGesture];
    
    if (!_timers) {
        self.timers = [NSMutableDictionary dictionary];
    }
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:notificationData.displayDuration
                                                      target:self
                                                    selector:@selector(hideNotification:)
                                                    userInfo:notification
                                                     repeats:NO];
    notification.timer = timer;
}

- (void)hideNotification:(id)sender
{
    PSDropdownNotificationView *notificationView;
    if ([sender isKindOfClass:[NSTimer class]]) {
        NSTimer *timer = (NSTimer*)sender;
        notificationView = timer.userInfo;
    }
    else if([sender isKindOfClass:[UITapGestureRecognizer class]])
    {
        notificationView = (PSDropdownNotificationView*)((UIGestureRecognizer*)sender).view;
    }
    else if([sender isKindOfClass:[PSDropdownNotificationView class]])
    {
        notificationView = (PSDropdownNotificationView*)sender;
    }
    
    int idx = [_visibleNotifications indexOfObject:notificationView];
    float height = CGRectGetHeight(notificationView.frame);
    notificationDy -= height;
    [_visibleNotifications removeObject:notificationView];
    [notificationView hide];
    
    [UIView animateWithDuration:0.4 animations:^{
        
        
        if (_notificationShowDirection == PSNotificationShowDirectionFromTop)
        {
            for (int i = 0; i < idx; i++) {
                PSDropdownNotificationView *upNotification = _visibleNotifications[ i ];
                CGRect newUpFrame = upNotification.frame;
                newUpFrame.origin.y -= height;
                upNotification.frame = newUpFrame;
            }
        }else
        {
            for (int i = _visibleNotifications.count-1; i >= idx; i--) {
                PSDropdownNotificationView *upNotification = _visibleNotifications[ i ];
                CGRect newUpFrame = upNotification.frame;
                newUpFrame.origin.y -= height;
                upNotification.frame = newUpFrame;
            }
        }
        
        
        CGRect newFrame = notificationView.frame;
        if (_notificationShowDirection == PSNotificationShowDirectionFromTop) {
            newFrame.origin.y -= height;
        }
        else if(_notificationShowDirection == PSNotificationShowDirectionFromBottom)
        {
            newFrame.origin.y -= height;
        }
        notificationView.frame = newFrame;
        
    } completion:^(BOOL finished) {
        
    }];
}


+ (PSDropdownNotificationApperiance*)apperiance
{
    static dispatch_once_t onceToken;
    static PSDropdownNotificationApperiance *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PSDropdownNotificationApperiance alloc] init];
    });
    return sharedInstance;
}

@end
