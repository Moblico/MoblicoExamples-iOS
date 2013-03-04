//
//  MLCServiceProtocol.h
//  MoblicoSDK
//
//  Created by Cameron Knight on 2/5/13.
//  Copyright (c) 2013 Moblico Solutions LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MLCServiceProtocol <NSObject>
@required
- (void)start;
- (void)cancel;
@end
