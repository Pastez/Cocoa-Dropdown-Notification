Cocoa Dropdown Notification
===========================

Eeasy to use component to display notification for user.

## Installation

1. Add QuartzCore framework into your project
2. Copy PSDropNotificationComponent directory into your project

## Example of usage

Simplest way is:

```objective-c
PSDropdownNotificationData *data = [[PSDropdownNotificationData alloc] initWithTitle:@"Title" message:@"Message"];
[[PSDropdownNotificationCenter sharedInstance] showNotification:data];
```

Also you can use NSNotificationCenter

```objective-c
//in app delegate create sharedInstance of PSDropdownNotificationCenter
[PSDropdownNotificationCenter sharedInstance];

//then create PSDropdownNotificationData
PSDropdownNotificationData *data = [[PSDropdownNotificationData alloc] initWithTitle:@"Title" message:@"Message"];
                                                                         
//and finally post notification
[[NSNotificationCenter defaultCenter] postNotificationName:PSNotificationCenterEventShowNotification object:data];
```

### Data properties

* int uniqueIndetifier
	
	notification unique indetifier, if notification is visible notification with the same id will be not displayed property is ignored if set to default value INT_MAX

* NSString *title

	notification title

* NSString *message

	notification message

* UIImage *image

	notification image if nil, image will be ignored

* CFTimeInterval displayDuration

	duration of notification life on screen

* PSDropdownNotificationApperiance *apperiance

	copy of default apperiance that can be overrided for notification


## Apperiance

You can change apperiance of invidual notification by accesing apperiance property in PSDropdownNotificationData

```objective-c
data.apperiance.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
data.apperiance.messageColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
data.apperiance.verticalMargin = 7.0;
data.apperiance.titleColor = [UIColor whiteColor];
```

or change global settings by accesing [PSDropdownNotificationCenter apperiance]

```objective-c
PSDropdownNotificationCenter.apperiance.bottomHLineColor = nil;
PSDropdownNotificationCenter.apperiance.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:26.0f];
PSDropdownNotificationCenter.apperiance.titleVSpacing = 8.0;
PSDropdownNotificationCenter.apperiance.messageColor = [UIColor whiteColor];
```

### Apperiance properties

* CGFloat shadowOpacity

  sets shadow under notification if 0 shadown is disabled

* CGFloat verticalMargin
	
	vertical marigin in px between content and notification bounds

* CGFloat horizontalMargin
	
	horizontal marigin in px between content and notification bounds

* CGFloat imageWidth
	
	total width of image in notification

* CGFloat imageHSpacing
	
	horizontal distance in pixels between image and title

* CGFloat titleVSpacing
	
	vertical distance between title and message

* UIFont *titleFont
	
	title font

* UIFont *messageFont
	
	message font

* UIColor *backgroundColor
	
	notification background color

* UIImage *backgroundImage

	notification background image

* UIColor *titleColor
	
	color of title text

* UIColor *messageColor
	
	color of message text

* UIColor *bottomHLineColor
	
	color of bottom horizontal line, if nil line will not appear
