# Push Notifications Example

This article outlines how to develop an iOS app to receive push notifications with the Moblico SDK for iOS. Review step 1 of the [Moblico Push Notifications Guide][PushGuide] for information or setting up your account with Push Notifications.

## Beginning with the Moblico SDK

1. Create a new Xcode Project, or open an existing project _(This example uses the Single View Application template)_.
2. Add MoblicoSDK and Security frameworks.

	_For more information see the [Getting Started Guide](http://developer.moblico.com/sdks/ios/docs/)_
3. Configure the MLCServiceManager during `-application:didFinishLaunchingWithOptions:`

		- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
			// Enter your Moblico API key here
			[MLCServiceManager setAPIKey:@"YOUR_API_KEY_HERE"];
			…
			return YES;
		}

## Register Device

Moblico uses a user based authentication scheme. In order to send push notifications to a device, you must first assign the device to a user.

This example will automatically generate a user, but you might want to provide login/registration forms in your app.

Follow these steps to register your device with Moblico:

1. Generate a unique identifier to use as a username

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

2. Verify if the user exists on the Moblico platform or automatically create the user

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

3. Pass the user's authentication credentials to MLCServiceManager, and register with Apple to receive push notifications

		- (void)loginWithUser:(MLCUser *)user {
		  // Pass the username to MLCServiceManager to create a user level authentication
		  // Password is blank since we are using auto registration.
		  [[MLCServiceManager sharedServiceManager] setUsername:user.username password:nil remember:NO];
		
		  // Register with apple
		  UIRemoteNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
		  [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
		}

4. Handle receiving the device token from apple.

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

5. You should now see your user in the Moblico Admin portal.

	*See step 2 of the [Moblico Push Notifications Guide][PushGuide] for more information.*


## Receive Push Notifications

Push notifications can enter your app in one of two ways.

1. Your app is launched by the push notification. ``- application:didFinishLaunchingWithOptions:`` will be called with the push notification in the launchOptions dictionary. 

		- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
			NSDictionary *pushNotification = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
			…
			return YES;
		}

2. Your app is already running when the push notification is running. ``- application:didReceiveRemoteNotification:`` will be called with the push notification as the userInfo dictionary. 

		- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
			NSDictionary *pushNotification = userInfo;
			…
		}

*For more information on sending Push Notifications see step 3 of the [Moblico Push Notifications Guide][PushGuide].*

## Download

Download the Push Notifications example source code: [PushNotifications.zip](http://developer.moblico.com/sdks/ios/samplecode/PushNotifications.zip)

[PushGuide]: http://developer.moblico.com/guides/Push_Notifications