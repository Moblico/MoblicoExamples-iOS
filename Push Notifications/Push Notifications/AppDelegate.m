//
//  AppDelegate.m
//  Push Notifications
//
//  Created by Cameron Knight on 6/10/13.
//  Copyright (c) 2013 moblico. All rights reserved.
//

#import "AppDelegate.h"

#import "PushNotificationsViewController.h"

#import <MoblicoSDK/MoblicoSDK.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Enter your Moblico API Key
	[MLCServiceManager setAPIKey:@"YOUR_API_KEY_HERE"];
	// Enable logging to print debug info
	//	[MLCServiceManager setLoggingEnabled:YES];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.viewController = [[PushNotificationsViewController alloc] initWithNibName:@"PushNotificationsViewController" bundle:nil];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
	self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
	
	// Register with Apple for notifications
	UIRemoteNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];

	// If the app was launched with a notification, pass the notification to the view controller
	self.viewController.pushNotification = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];

    return YES;
}

// Pass notifications that are received while the app is running to the view controller
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
	self.viewController.pushNotification = userInfo;
}

// Got deviceToken from Apple's Push Notification service.
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
	[self remoteRegisterDeviceToken:deviceToken];
}

- (void)remoteRegisterDeviceToken:(NSData *)deviceToken {
	// Send the device token to Moblico
	MLCUsersService *createAnonymousDeviceService = [MLCUsersService createAnonymousDeviceWithDeviceToken:deviceToken handler:^(MLCStatus *status, NSError *error, NSHTTPURLResponse *response) {
		if (response.statusCode == 200) {
			MLCUser *user = [MLCServiceManager sharedServiceManager].currentUser;
			NSLog(@"Registered Device Token: %@", deviceToken);
			MLCGroupsService *groupsService = [MLCGroupsService listGroups:^(NSArray *collection, NSError *error, NSHTTPURLResponse *response) {
				NSLog(@"groups: %@ error: %@ response: %@", collection, error, response);
				for (MLCGroup *group in collection) {
					if (YES||!group.belongs) {
						[[MLCGroupsService addUser:user toGroup:group handler:^(MLCStatus *status, NSError *error, NSHTTPURLResponse *response) {
							if (status && status.type == MLCStatusTypeSuccess) {
								NSLog(@"Added user: %@ to group: %@", user, group);
							}
							else {
								NSLog(@"Failed to add user: %@ to group: %@ with error: %@", user, group, error);
							}
						}] start];
					}
				}
			}];
			[groupsService start];
		}
		else {
			NSLog(@"Unable to register Device.\nstatus: %@ error: %@ response: %@", status, error, response);
		}

	}];
	[createAnonymousDeviceService start];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
	NSLog(@"Failed to get token, error: %@", error);
	if ([error.domain isEqualToString:NSCocoaErrorDomain] && error.code == 3010) {
		NSData *deviceToken = [@"SIMULATOR_TEST" dataUsingEncoding:NSUTF8StringEncoding];
		[self remoteRegisterDeviceToken:deviceToken];
	}
}

@end
