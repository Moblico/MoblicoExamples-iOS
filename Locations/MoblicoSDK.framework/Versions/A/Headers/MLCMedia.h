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

@interface MLCMedia : MLCEntity
@property (nonatomic) NSUInteger mediaId;
@property (strong, nonatomic) NSDate *createDate;
@property (strong, nonatomic) NSDate *lastUpdateDate;
@property (copy, nonatomic) NSString *mimeType;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *description;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSURL *imageUrl;
@property (copy, nonatomic) NSDictionary *attributes;
@property (nonatomic) NSUInteger priority;
@property (nonatomic) BOOL shouldCache;
@property (copy, nonatomic) NSString *thumbUrl;
@property (nonatomic) NSUInteger externalId;
@end
