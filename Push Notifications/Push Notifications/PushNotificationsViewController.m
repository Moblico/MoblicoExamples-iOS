//
//  ViewController.m
//  Push Notifications
//
//  Created by Cameron Knight on 6/10/13.
//  Copyright (c) 2013 moblico. All rights reserved.
//

#import "PushNotificationsViewController.h"
#import "GroupsViewController.h"

@interface PushNotificationsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@end

@implementation PushNotificationsViewController

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
- (UIRectEdge)edgesForExtendedLayout {
	return UIRectEdgeNone;
}
#endif

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

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"Push Notifications";
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Groups" style:UIBarButtonItemStyleBordered target:self action:@selector(showGroups)];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self updateTextLabel];
}

- (void)showGroups {
	GroupsViewController *viewController = [[GroupsViewController alloc] initWithNibName:@"GroupsViewController" bundle:nil];
	[self.navigationController pushViewController:viewController animated:YES];
}

@end
