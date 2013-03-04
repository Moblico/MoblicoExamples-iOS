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

#import "MLCEntity.h"

@interface MLCLocation : MLCEntity
@property (nonatomic) NSUInteger locationId;
@property (strong, nonatomic) NSDate *createDate;
@property (strong, nonatomic) NSDate *lastUpdateDate;
@property (copy, nonatomic) NSString *type;
@property (nonatomic) BOOL active;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *description;
@property (copy, nonatomic) NSString *address1;
@property (copy, nonatomic) NSString *address2;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *county;
@property (copy, nonatomic) NSString *stateOrProvince;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *postalCode;
@property (copy, nonatomic) NSString *country;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) double distance;
@property (strong, nonatomic) NSURL *url;
@property (copy, nonatomic) NSString *contactName;
@property (nonatomic) NSUInteger externalId;
@property (copy, nonatomic) NSString *locate;
@property (copy, nonatomic) NSDictionary *attributes;
@end
