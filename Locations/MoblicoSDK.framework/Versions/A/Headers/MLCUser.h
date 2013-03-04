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

@interface MLCUser : MLCEntity
@property (copy, nonatomic) NSString *username;
@property (nonatomic) BOOL optinEmail;
@property (nonatomic) BOOL optinPhone;
@property (copy, nonatomic) NSString *dateOfBirth;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *nickName;
@property (copy, nonatomic) NSString *locale;
@property (copy, nonatomic) NSString *address1;
@property (copy, nonatomic) NSString *address2;
@property (copy, nonatomic) NSString *lastName;
@property (copy, nonatomic) NSString *firstName;
@property (copy, nonatomic) NSString *country;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *contactPreference;
@property (copy, nonatomic) NSString *postalCode;
@property (copy, nonatomic) NSString *email;
@property (nonatomic) int age;
@property (copy, nonatomic) NSString *gender;
@property (copy, nonatomic) NSString *stateOrProvince;
@property (strong, nonatomic) NSDate *createDate;
@property (strong, nonatomic) NSDate *lastUpdateDate;
+ (id)userWithUsername:(NSString *)username;
@end
