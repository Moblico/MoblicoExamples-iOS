//
//  GroupsViewController.m
//  Push Notifications
//
//  Created by Cameron Knight on 12/22/13.
//  Copyright (c) 2013 moblico. All rights reserved.
//

#import <MoblicoSDK/MoblicoSDK.h>
#import "GroupsViewController.h"

@interface GroupsViewController ()
@property (nonatomic, strong) NSArray *groups;
@property (nonatomic, strong) NSArray *userGroups;
@end

@implementation GroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Groups";
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshGroups)];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self refreshGroups];
}

- (void)refreshGroups {
	[[MLCGroupsService listGroups:^(NSArray *collection, NSError *error, NSHTTPURLResponse *response) {
		[self.tableView beginUpdates];
		self.groups = collection;
		[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
		[self.tableView endUpdates];
	}] start];

	MLCUser *user = [MLCServiceManager sharedServiceManager].currentUser;
	if (user) {
		[[MLCGroupsService listGroupsForUser:user handler:^(NSArray *collection, NSError *error, NSHTTPURLResponse *response) {
			[self.tableView beginUpdates];
			self.userGroups = collection;
			[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
			[self.tableView endUpdates];
		}] start];
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return self.groups.count;
	}
	if (section == 1) {
		return self.userGroups.count;
	}

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"GroupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

	MLCGroup *group;

	if (indexPath.section == 0) {
		group = self.groups[indexPath.row];
	}
	else if (indexPath.section == 1) {
		group = self.userGroups[indexPath.row];
	}

    // Configure the cell...
	cell.textLabel.text = group.name;
	cell.detailTextLabel.text = group.details;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return @"All Groups";
	}
	if (section == 1) {
		return @"User's Groups";
	}

	return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if (section == 0) {
		return @"Tap to add the current user to a group";
	}
	return nil;
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		return YES;
	}

	return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		MLCGroup *group = self.groups[indexPath.row];
		MLCUser *user = [MLCServiceManager sharedServiceManager].currentUser;
		if (user) {
			[[MLCGroupsService addUser:user toGroup:group handler:^(MLCStatus *status, NSError *error, NSHTTPURLResponse *response) {
				NSString *title = @"Success";
				NSString *message = @"Added current user to group";

				if (error) {
					title = @"Error";
					message = [error localizedDescription];
				}

				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
																message:message
															   delegate:nil
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil];
				if (self.view.window != nil) {
					[alert show];
				}

				[self refreshGroups];
			}] start];
		}
	}
}

@end
