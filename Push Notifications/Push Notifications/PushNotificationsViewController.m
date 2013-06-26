//
//  ViewController.m
//  Push Notifications
//
//  Created by Cameron Knight on 6/10/13.
//  Copyright (c) 2013 moblico. All rights reserved.
//

#import "PushNotificationsViewController.h"

@interface PushNotificationsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@end

@implementation PushNotificationsViewController

- (void)setPushNotification:(NSDictionary *)pushNotification {
	if (![_pushNotification isEqual:pushNotification]) {
		_pushNotification = pushNotification;
		[self updateTextLabel];
	}
}

- (void)updateTextLabel {
	NSDictionary * aps = self.pushNotification[@"aps"];
	
	if (aps) {
		[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
		NSString * alertText = nil;
		id alert = aps[@"alert"];
		
		if ([alert isKindOfClass:[NSString class]]) {
			alertText = alert;
		} else if ([alert isKindOfClass:[NSDictionary class]]) {
			alertText = alert[@"body"];
		}
		
		self.textLabel.alpha = 1.0;
		self.textLabel.text = alertText;
	}
	else {
		self.textLabel.alpha = 0.5;
		self.textLabel.text = @"No Push Notifications.";
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self updateTextLabel];
}

@end
