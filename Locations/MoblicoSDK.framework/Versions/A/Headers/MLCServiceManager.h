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

typedef void(^MLCServiceManagerAuthenticationCompletionHandler)(NSURLRequest *authenticatedRequest, NSError *error, NSHTTPURLResponse *response);

/** MLCServiceManager keeps track of your Moblico API Key, and authenticates all service calls. 
 
 You can get an shared instance of MLCServiceManager by calling:
 
    [MLCServiceManager sharedServiceManager];
 
 */

@class MLCUser;

@interface MLCServiceManager : NSObject
/** The registered user's username. */
@property (readonly, copy) NSString *username;
/** The registered user's password. */
@property (readonly, copy) NSString *password;
@property (readonly) MLCUser *currentUser;
/** Shared instance of MLCServiceManager.
 @warning You must set the API Key before getting an instance of MLCServiceManager
 @exception MLCInvalidAPIKeyException You must set your API key before getting an instance of the ServiceManager.
 @see setAPIKey:
 */
+ (MLCServiceManager *)sharedServiceManager;

/** Set the API Key used for all service calls.
 @warning The API Key should only be set one. Calling setAPIKey more than once will raise an exception.
 @param apiKey The API Key provided by Moblico.
 @exception MLCInvalidAPIKeyException You can only set the API Key once.
 @see apiKey
 */
+ (void)setAPIKey:(NSString *)apiKey;

/** Get the current API Key.
 @return The API Key will be nil until setAPIKey is called.
 @see setAPIKey:
 */
+ (NSString *)apiKey;

/** Set the registered user's username and password
 @param username The registered user's username.
 @param password The registered user's password.
 */
- (void)setUsername:(NSString *)username password:(NSString *)password remember:(BOOL)rememberCredentials;

/** Returns an authenticated request.
 @param request An unauthenticated request.
 @return A request with the proper *Authenticate* header.
 */
- (void)authenticateRequest:(NSURLRequest *)request handler:(MLCServiceManagerAuthenticationCompletionHandler)handler;

/** Use the Moblico testing environment */
+ (void)setSSLDisabled:(BOOL)disabled;
+ (BOOL)isSSLDisabled;
+ (void)setTestingEnabled:(BOOL)testing;
+ (BOOL)isTestingEnabled;
+ (NSString *)host;
+ (NSString *)apiVersion;

@end
