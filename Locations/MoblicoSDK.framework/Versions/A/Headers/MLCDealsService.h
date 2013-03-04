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
@class MLCDeal;
@class MLCLocation;

@interface MLCDealsService : MLCService
+ (id)readDealWithDealId:(NSUInteger)dealId handler:(MLCServiceResourceCompletionHandler)handler;
+ (id)listDeals:(MLCServiceCollectionCompletionHandler)handler;
+ (id)listDealsForLocation:(MLCLocation *)location handler:(MLCServiceCollectionCompletionHandler)handler;
+ (id)listDealsForResource:(id<MLCEntityProtocol>)resource handler:(MLCServiceCollectionCompletionHandler)handler;
+ (id)redeemDeal:(MLCDeal *)deal withOfferCode:(NSString *)offerCode handler:(MLCServiceStatusCompletionHandler)handler;
@end
