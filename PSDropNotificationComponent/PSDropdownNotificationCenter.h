//
//  PSDropNotification.h
//  QuickDropdownNotificationExample
//
//  Created by Tomasz Kwolek on 07.08.2013.
//  Copyright (c) 2013 Pastez 2013 www.pastez.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark PSDropdownNotificationApperiance

@interface PSDropdownNotificationApperiance : NSObject

@property (readwrite,nonatomic) CGFloat shadowOpacity;      // sets shadow under notification if 0 shadown is disabled
@property (readwrite,nonatomic) CGFloat verticalMargin;     // vertical marigin in px between content and notification bounds
@property (readwrite,nonatomic) CGFloat horizontalMargin;   // horizontal marigin in px between content and notification bounds
@property (readwrite,nonatomic) CGFloat imageWidth;         // total width of image in notification
@property (readwrite,nonatomic) CGFloat imageHSpacing;      // horizontal distance in pixels between image and title
@property (readwrite,nonatomic) CGFloat titleVSpacing;      // vertical distance between title and message
@property (strong,nonatomic) UIFont *titleFont;             // title font
@property (strong,nonatomic) UIFont *messageFont;           // message font
@property (strong,nonatomic) UIColor *backgroundColor;      // notification background color
@property (strong,nonatomic) UIImage *backgroundImage;      // notification background image
@property (strong,nonatomic) UIColor *titleColor;           // color of title text
@property (strong,nonatomic) UIColor *messageColor;         // color of message text
@property (strong,nonatomic) UIColor *bottomHLineColor;     // color of bootom horizontal line, if nil line will not appear

@end

#pragma mark PSDropdownNotificationData

@interface PSDropdownNotificationData : NSObject

@property (readwrite,nonatomic) int uniqueIndetifier;                       // notification unique indetifier, if notification is
                                                                            // visible notification with the same id will be not displayed
                                                                            // property is ignored if set to default value INT_MAX
@property (strong,nonatomic) NSString *title;                               // notification title
@property (strong,nonatomic) NSString *message;                             // notification message
@property (strong,nonatomic) UIImage *image;                                // notification image if nil, image will be ignored
@property (readwrite,nonatomic) CFTimeInterval displayDuration;             // duration of notification  life on screen
@property (strong,nonatomic) PSDropdownNotificationApperiance *apperiance;  // copy of default apperiance that can be overrided for notification

- (id)initWithTitle:(NSString*)title message:(NSString*)message;
- (id)initWithTitle:(NSString*)title message:(NSString*)message andImage:(UIImage*)image;

@end

#pragma mark PSDropdownNotificationCenter

typedef enum
{
    PSNotificationShowDirectionFromTop = 0,                 // new notifications appears from top
    PSNotificationShowDirectionFromBottom = 1               // new notifications appears from bottom
} PSNotificationShowDirection;

@interface PSDropdownNotificationCenter : NSObject

/**
 event name to use via NSNotificationCenter to show PSDropdownNotificationView
 object passed must be kind of PSDropdownNotificationData
 **/
extern NSString * const PSNotificationCenterEventShowNotification;

@property (readwrite,nonatomic) uint maxVisibleNotifications;                           // how meany notification can be visible at once on the screen
@property (readwrite,nonatomic) PSNotificationShowDirection notificationShowDirection;  // notification display animation style

+ (instancetype)sharedInstance;

+ (instancetype) alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
- (instancetype) init __attribute__((unavailable("init not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

// displays notification with provided data on screen
- (void)showNotification:(PSDropdownNotificationData*)notifiaction;

// returns default apperiance object
+ (PSDropdownNotificationApperiance*)apperiance;

@end
