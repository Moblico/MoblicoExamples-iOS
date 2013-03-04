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

#import "LocationDetailViewController.h"

@interface LocationDetailViewController ()
@property (strong, nonatomic) MLCLocationsService *service;

// Section 0
@property (weak, nonatomic) IBOutlet UITableViewCell *nameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *descriptionCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *typeCell;

// Section 1
@property (weak, nonatomic) IBOutlet UITableViewCell *address1Cell;
@property (weak, nonatomic) IBOutlet UITableViewCell *address2Cell;
@property (weak, nonatomic) IBOutlet UITableViewCell *cityCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *countyCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *stateOrProvinceCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *postalCodeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *countryCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *latitudeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *longitudeCell;

// Section 2
@property (weak, nonatomic) IBOutlet UITableViewCell *contactNameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *emailCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *phoneCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *urlCell;

@end

@implementation LocationDetailViewController

- (MLCLocationsService *)service {
	if (!_service) {
		self.service = [MLCLocationsService readLocationWithLocationId:self.location.locationId handler:^(MLCLocation *location, NSError *error, NSHTTPURLResponse *response) {
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
				self.location = location;
				[self updateUI];
			}			
		}];
	}
	return _service;
}

- (void)setDetailLabelText:(NSString *)text forCell:(UITableViewCell *)cell {
	if ([text length]) {
		cell.detailTextLabel.textColor = [UIColor darkTextColor];
		cell.detailTextLabel.text = text;
	}
	else {
		cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.5 alpha:0.5];
		cell.detailTextLabel.text = @"Not Available";
	}
}

- (void)updateUI {
	// Section 0
	[self setDetailLabelText:self.location.name forCell:self.nameCell];
	[self setDetailLabelText:self.location.description forCell:self.descriptionCell];
	[self setDetailLabelText:self.location.type forCell:self.typeCell];

	// Section 1
	[self setDetailLabelText:self.location.address1 forCell:self.address1Cell];
	[self setDetailLabelText:self.location.address2 forCell:self.address2Cell];
	[self setDetailLabelText:self.location.city forCell:self.cityCell];
	[self setDetailLabelText:self.location.county forCell:self.countyCell];
	[self setDetailLabelText:self.location.stateOrProvince forCell:self.stateOrProvinceCell];
	[self setDetailLabelText:self.location.postalCode forCell:self.postalCodeCell];
	[self setDetailLabelText:self.location.country forCell:self.countryCell];
	[self setDetailLabelText:[NSString stringWithFormat:@"%.8F", self.location.latitude] forCell:self.latitudeCell];
	[self setDetailLabelText:[NSString stringWithFormat:@"%.8F", self.location.longitude] forCell:self.longitudeCell];

	// Section 2
	[self setDetailLabelText:self.location.contactName forCell:self.contactNameCell];
	[self setDetailLabelText:self.location.email forCell:self.emailCell];
	[self setDetailLabelText:self.location.phone forCell:self.phoneCell];
	[self setDetailLabelText:[self.location.url absoluteString] forCell:self.urlCell];
}

- (void)refreshLocation {
	if ([UIRefreshControl class] != nil) [self.refreshControl beginRefreshing];
	[self.service start];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	if ([UIRefreshControl class] != nil) {
		self.refreshControl = [[UIRefreshControl alloc] init];
		[self.refreshControl addTarget:self action:@selector(refreshLocation) forControlEvents:UIControlEventValueChanged];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self updateUI];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	NSURL *openURL;
	
	if (cell == self.emailCell) {
		openURL = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", self.location.email]];
	}
	else if (cell == self.phoneCell) {
		openURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.location.phone]];
	}
	else if (cell == self.urlCell) {
		openURL = self.location.url;
	}
	
	if ([[UIApplication sharedApplication] canOpenURL:openURL]) {
		[[UIApplication sharedApplication] openURL:openURL];
	}
}

@end
