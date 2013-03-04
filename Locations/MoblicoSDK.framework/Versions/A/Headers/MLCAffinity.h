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

@interface MLCAffinity : MLCEntity
@property (nonatomic) NSUInteger affinityId;
@property (strong, nonatomic) NSDate *createDate;
@property (strong, nonatomic) NSDate *lastUpdateDate;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *description;
@property (copy, nonatomic) NSString *optional;
@property (nonatomic) int points;
@property (nonatomic) int userLimit;
@property (nonatomic) NSUInteger affinityActionId;
@property (nonatomic) NSUInteger pointTypeId;
@property (nonatomic) NSUInteger rewardId;
@property (nonatomic) NSUInteger eventId;
@property (nonatomic) NSUInteger locationId;
@property (nonatomic) NSUInteger questionAnswerId;
@property (nonatomic) NSUInteger groupId;
@end
