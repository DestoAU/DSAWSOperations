//
//  DSSTSOperation.m
//  Kestrel
//
//  Created by Rob Amos on 16/12/2013.
//  Copyright (c) 2013 Desto. All rights reserved.
//

#import "DSSTSOperation.h"
#import <AWSSecurityTokenService/AWSSecurityTokenService.h>

#pragma mark Private Methods

@interface DSSTSOperation ()

@end

#pragma mark - Implementation

@implementation DSSTSOperation

#pragma mark Operation Configuration

- (BOOL)isRegionFree
{
    return NO;
}

// An instance of the client used to execute this operation
- (Class)clientClass
{
    return [AmazonSecurityTokenServiceClient class];
}

- (SEL)clientSelector
{
    NSDictionary *mapping =
    @{
        @"SecurityTokenServiceAssumeRoleRequest":                   @"assumeRole:",
        @"SecurityTokenServiceAssumeRoleWithSAMLRequest":           @"assumeRoleWithSAML:",
        @"SecurityTokenServiceAssumeRoleWithWebIdentityRequest":    @"assumeRoleWithWebIdentity:",
        @"SecurityTokenServiceDecodeAuthorizationMessageRequest":   @"decodeAuthorizationMessage:",
        @"SecurityTokenServiceGetFederationTokenRequest":           @"getFederationToken:",
        @"SecurityTokenServiceGetSessionTokenRequest":              @"getSessionToken:"
    };
    
    if (self.request == nil)
        return nil;
    
    else
    {
        NSString *className = NSStringFromClass([self.request class]);
        NSString *selectorName = [mapping objectForKey:className];
        if (selectorName != nil)
            return NSSelectorFromString(selectorName);
        
        // default
        return nil;
    }
}

@end