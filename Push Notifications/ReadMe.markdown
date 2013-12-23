# Push Notifications Example (with Groups)

Moblico uses a user based authentication scheme. In order to send push notifications to a device, you must first assign the device to a user. Push Notifications can also be sent to all user in a group. The SDK provides services for creating users registering devices, and adding users to groups. Additionally, you can use the SDK to automatically create a user when registering a device.

This article outlines how to develop an iOS app to receive push notifications, and manage groups with the Moblico SDK for iOS. Review step 1 of the [Moblico Push Notifications Guide][PushGuide] for information or setting up your account with Push Notifications.

## Beginning with the Moblico SDK

1. Create a new Xcode Project, or open an existing project _(This example uses the Single View Application template)_.
2. Add MoblicoSDK and Security frameworks.

	_For more information see the [Getting Started Guide](http://developer.moblico.com/sdks/ios/docs/)_
3. Configure the MLCServiceManager during `- application:didFinishLaunchingWithOptions:`

		- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
			// Enter your Moblico API key here
			[MLCServiceManager setAPIKey:@"YOUR_API_KEY_HERE"];
			…
			return YES;
		}

## Register Device

This example uses the `- [MLCUsersService createAnonymousDeviceWithDeviceToken:handler:]` method to automatically generate an anonymous user and assign the Apple Push Notification device token to that user.

Follow these steps to register your device with Moblico:

1. Register with Apple to receive push notifications

		// Register with Apple for notifications
		UIRemoteNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
		[[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];

2. Handle receiving the device token from Apple.

		// Got deviceToken from Apple's Push Notification service.
		- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
		
			// Send the device token to Moblico
			MLCUsersService *createAnonymousDeviceService = [MLCUsersService createAnonymousDeviceWithDeviceToken:deviceToken handler:^(MLCStatus *status, NSError *error, NSHTTPURLResponse *response) {
				if (response.statusCode == 200) {
					NSLog(@"Registered Device Token: %@", deviceToken);
				}
				else {
					NSLog(@"Unable to register Device.\nstatus: %@ error: %@ response: %@", status, error, response);
				}
			}];
			[createAnonymousDeviceService start];
		}

3. You should now see your user in the Moblico Admin portal.

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

## Managing Groups

To see a list of all of the existing groups call `- [MLCGroupsService listGroups:]`

	MLCGroupsService *service = [MLCGroupsService listGroups:^(NSArray *collection, NSError *error, NSHTTPURLResponse *response) {
		[self.tableView beginUpdates];
		self.groups = collection;
		[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
		[self.tableView endUpdates];
	}];
	
	[service start];

To see the current user's groups call `- [MLCGroupsService listGroupsForUser:handler:]`

	MLCUser *user = [MLCServiceManager sharedServiceManager].currentUser;
	if (user) {
		MLCGroupsService *service = [MLCGroupsService listGroupsForUser:user handler:^(NSArray *collection, NSError *error, NSHTTPURLResponse *response) {
			[self.tableView beginUpdates];
			self.userGroups = collection;
			[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
			[self.tableView endUpdates];
		}];
		[service start];
	}

To add the current user to a (`MLCGroup`) group call `- [MLCGroupsService addUser:toGroup:handler:]`

		MLCGroup *group = self.groups[indexPath.row];
		MLCUser *user = [MLCServiceManager sharedServiceManager].currentUser;
		if (user) {
			MLCGroupsService *service = [MLCGroupsService addUser:user toGroup:group handler:^(MLCStatus *status, NSError *error, NSHTTPURLResponse *response) {
				if (status && status.type == MLCStatusTypeSuccess) {
					NSLog(@"Added user: %@ to group: %@", user, group);
				}
				else {
					NSLog(@"Failed to add user: %@ to group: %@ with error: %@", user, group, error);
				}
			}];
			[service start];
		}


## Download

Download the Push Notifications example source code: [PushNotifications.zip](http://developer.moblico.com/sdks/ios/samplecode/PushNotifications.zip)

[PushGuide]: http://developer.moblico.com/guides/Push_Notifications