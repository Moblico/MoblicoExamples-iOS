/*
 Copyright 2012 Moblico Solutions LLC
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this work except in compliance with the License.
 You may obtain a copy of the License in the LICENSE file, or at:
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "LocationsViewController.h"
#import "LocationDetailViewController.h"

@interface LocationsViewController ()

@property (strong, nonatomic) NSArray *locations; // Array of MLCLocation
@property (strong, nonatomic) MLCLocationsService *service;

@end

@implementation LocationsViewController

// Lazy load the service property
- (MLCLocationsService *)service {
	if (!_service) {
		self.service = [MLCLocationsService findLocationsWithSearchParameters:nil
																	  handler:^(NSArray *locations,
																				NSError *error,
																				NSHTTPURLResponse *response) {
			if ([UIRefreshControl class] != nil) [self.refreshControl endRefreshing];
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

- (void)refreshLocations {
	if ([UIRefreshControl class] != nil) [self.refreshControl beginRefreshing];
	[self.service start];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	if ([UIRefreshControl class] != nil) {
		self.refreshControl = [[UIRefreshControl alloc] init];
		[self.refreshControl addTarget:self action:@selector(refreshLocations) forControlEvents:UIControlEventValueChanged];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	// Start the service when the view appears
	[self refreshLocations];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	// Cancel the service when the view disappears
	[self.service cancel];
}

#pragma mark - Table View

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showLocationDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MLCLocation *location = self.locations[indexPath.row];
        [[segue destinationViewController] setLocation:location];
    }
}

@end
