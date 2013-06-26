#Getting Locations using the Moblico SDK for iOS

This article outlines how to start a project, pull down a list of Locations using the Moblico SDK, and display them to the screen.

## Prerequisets

Before you can begin:

1. Login to the Dev Portal: [moblico.net/developer](https://moblico.net/developer)
2. Retrieve your API Key for future use.

	_For more information review the [Dev Portal tutorials][devPortalTutorials]._
3. Switch to the Admin Portal: [moblico.net/admin](https://moblico.net/admin)
4. Navigate to the Locations module, and add a few Locations to get started.

	_For more information review the [Admin Portal tutorials][adminPortalTutorials]._


## Begin

1. Create a new Xcode Project, or open an existing project (_This example uses storyboards_).
2. Add MoblicoSDK and Security frameworks.

	_For more information see the [Getting Started Guide](http://developer.moblico.com/sdks/ios/docs/)_
3. Configure the MLCServiceManager during `-application:didFinishLaunchingWithOptions:`

		- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
			// Enter your Moblico API key here
			[MLCServiceManager setAPIKey:@"YOUR_API_KEY_HERE"];
			return YES;
		}


4. Create a new UITableViewController subclass.
5. Add properties for the Locations, and the Service

		@interface LocationsViewController ()
		@property (strong, nonatomic) NSArray *locations; // Array of MLCLocation
		@property (strong, nonatomic) MLCLocationsService *service;
		@end
		
6. Use lazy loading to initialize `self.service`.

		- (MLCLocationsService *)service {
			if (!_service) {
				self.service = [MLCLocationsService findLocationsWithSearchParameters:nil
																			  handler:^(NSArray *locations,
																						NSError *error,
																						NSHTTPURLResponse *response) {
					if (error) {
						UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
																			message:[error localizedDescription]
																		   delegate:nil
																  cancelButtonTitle:NSLocalizedString(@"OK", nil)
																  otherButtonTitles:nil];
						// Only show the alert if this view is still on screen
						if (self.view.window != nil) {
							[alertView show];
						}
					}
					else {
						self.locations = locations;
						[self.tableView reloadData];
					}
				}];
			}
			return _service;
		}

7. Start the service when the view appears; cancel the service when the view disappears.

		- (void)viewWillAppear:(BOOL)animated {
			[super viewWillAppear:animated];
			[self.service start];
		}
		
		- (void)viewWillDisappear:(BOOL)animated {
			[super viewWillDisappear:animated];
			[self.service cancel];
		}

8. Configure the tableView delegate methods using `self.locations`.

		- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
			return 1;
		}

		- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
			return self.locations.count;
		}

		- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
		    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
			MLCLocation *location = self.locations[indexPath.row];
			cell.textLabel.text = [location name];
		    return cell;
		}


## Download

Download the Locations example source code: [Locations.zip](http://developer.moblico.com/sdks/ios/samplecode/Locations.zip)

[devPortalTutorials]: http://developer.moblico.com/tutorials.php#playlist=PLjpfC9HFMZgU3bIvvS6wE0uIJUhCtQqZN
[adminPortalTutorials]: http://developer.moblico.com/tutorials.php#playlist=PLjpfC9HFMZgV\_lqfNFVcy4pZkKVSIFp0f