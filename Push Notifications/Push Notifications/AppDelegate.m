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

@interface AppDelegate ()
- (NSString *)generateUniqueIdentifier;
- (void)verifyOrCreateUserWithUsername:(NSString *)username;
- (void)loginWithUser:(MLCUser *)user;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Enter your Moblico API Key
	[MLCServiceManager setAPIKey:@"1c1202b6-7a36-4451-ba32-fe57f9a6c8d4"];
	// Enable logging to print debug info
	//	[MLCServiceManager setLoggineEnabled:YES];
	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.viewController = [[PushNotificationsViewController alloc] initWithNibName:@"PushNotificationsViewController" bundle:nil];
	self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
	
	// Generate a unique identifier to use as a username
	NSString *username = [self generateUniqueIdentifier];
	// Verify that the user exists on the Moblico platform or automatically create a user
	[self verifyOrCreateUserWithUsername:username];

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
	// Get the currently logged in user
	MLCUser * user = [[MLCServiceManager sharedServiceManager] currentUser];
	// Send the device token to Moblico
	MLCUsersService *updateDeviceService = [MLCUsersService updateDeviceWithDeviceToken:deviceToken forUser:user handler:^(MLCStatus *status, NSError *error, NSHTTPURLResponse *response) {
		if (response.statusCode == 200) {
			NSLog(@"Registered Device Token: %@", deviceToken);
		}
		else {
			NSLog(@"Unable to register Device.\nstatus: %@ error: %@ response: %@", status, error, response);
		}
	}];
		
	[updateDeviceService start];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
	NSLog(@"Failed to get token, error: %@", error);
}

- (NSString *)generateUniqueIdentifier {
	// On iOS 6 use identifierForVerder
	if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
		return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
	}
	
	// Gernerate a UUID on iOS 5
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *deviceUUID = [defaults stringForKey:@"deviceUUID"];
	if (!deviceUUID) {
		deviceUUID = CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, CFUUIDCreate(kCFAllocatorDefault)));
		[defaults setObject:deviceUUID forKey:@"deviceUUID"];
	}
	
	return deviceUUID;
}

- (void)loginWithUser:(MLCUser *)user {
	// Pass the username to MLCServiceManager to create a user level authentication
	// Password is blank since we are using auto registration.
	[[MLCServiceManager sharedServiceManager] setUsername:user.username password:nil remember:NO];

	// Register with apple
	UIRemoteNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
}

- (void)verifyOrCreateUserWithUsername:(NSString *)username {
	// Create a transient user object to pass to the moblico platform
	MLCUser * user = [MLCUser userWithUsername:username];

	// This block of code will create a user, it will not execute until you call [createUserService start]
	MLCUsersService *createUserService = [MLCUsersService createUser:user handler:^(MLCStatus *status, NSError *error, NSHTTPURLResponse *response) {
		if (response.statusCode == 200) {
			// User was succesfully created
			NSLog(@"Created User: %@", user);
			[self loginWithUser:user];
		}
		else {
			// User was not created
			NSLog(@"Unable to create user.\nstatus: %@ error: %@ response: %@", status, error, response);
		}
	}];

	// This block of code determines if the user already exists, it will not execute until you call [verifyUserService start]
	MLCUsersService *verifyUserService = [MLCUsersService verifyExistingUserWithUsername:user.username handler:^(id<MLCEntityProtocol> resource, NSError *error, NSHTTPURLResponse *response) {
		if (response.statusCode == 200) {
			NSLog(@"User exists, registering device.");
			[self loginWithUser:user];
		}
		
		else if (response.statusCode == 404) {
			NSLog(@"User not found. Creating User");
			[createUserService start];
		}
		else {
			NSLog(@"Unable to verify user.\nresource: %@ error: %@ response: %@", resource, error, response);
		}
	}];
	
	// Execute
	[verifyUserService start];

}

@end
