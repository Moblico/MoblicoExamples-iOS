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

#import "MLCService.h"

@class MLCUser;

@interface MLCUsersService : MLCService
+ (id)verifyExistingUserWithUsername:(NSString *)username handler:(MLCServiceResourceCompletionHandler)handler;
+ (id)verifyExistingUserWithPhone:(NSString *)phone handler:(MLCServiceResourceCompletionHandler)handler;
+ (id)verifyExistingUserWithEmail:(NSString *)email handler:(MLCServiceResourceCompletionHandler)handler;
+ (id)createUser:(MLCUser *)user handler:(MLCServiceStatusCompletionHandler)handler;
+ (id)readUserWithUsername:(NSString *)username handler:(MLCServiceResourceCompletionHandler)handler;
+ (id)updateUser:(MLCUser *)user handler:(MLCServiceStatusCompletionHandler)handler;
//+ (id)destroyUser:(MLCUser *)user handler:(MLCServiceStatusCompletionHandler)handler;
+ (id)createDeviceWithDeviceId:(NSString *)deviceId forUser:(MLCUser *)user handler:(MLCServiceStatusCompletionHandler)handler;
+ (id)destroyDeviceWithDeviceId:(NSString *)deviceId forUser:(MLCUser *)user handler:(MLCServiceStatusCompletionHandler)handler;
@end
