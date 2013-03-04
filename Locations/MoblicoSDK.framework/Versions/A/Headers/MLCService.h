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

#import <Foundation/Foundation.h>
#import "MLCEntityProtocol.h"
#import "MLCServiceProtocol.h"
@class MLCStatus;

typedef NS_ENUM(NSUInteger, MLCServiceRequestMethod) {
	MLCServiceRequestMethodGET,
	MLCServiceRequestMethodPOST,
	MLCServiceRequestMethodPUT,
	MLCServiceRequestMethodDELETE
};

typedef void(^MLCServiceJSONCompletionHandler)(id jsonObject, NSError *error, NSHTTPURLResponse *response);
typedef void(^MLCServiceResourceCompletionHandler)(id<MLCEntityProtocol> resource, NSError *error, NSHTTPURLResponse *response);
typedef void(^MLCServiceCollectionCompletionHandler)(NSArray *array, NSError *error, NSHTTPURLResponse *response);
typedef void(^MLCServiceStatusCompletionHandler)(MLCStatus *status, NSError *error, NSHTTPURLResponse *response);

/** Base class for all Moblico service objects. */
@interface MLCService : NSObject <MLCServiceProtocol>
@end
