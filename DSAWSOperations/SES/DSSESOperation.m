//
//  DSSESOperation.m
//  Kestrel
//
//  Created by Rob Amos on 16/12/2013.
//  Copyright (c) 2013 Desto. All rights reserved.
//

#import "DSSESOperation.h"
#import <AWSiOSSDK/SES/AWSSES.h>

#pragma mark Private Methods

@interface DSSESOperation ()

@end

#pragma mark - Implementation

@implementation DSSESOperation

#pragma mark Operation Configuration

- (BOOL)isRegionFree
{
    return NO;
}

// An instance of the client used to execute this operation
- (Class)clientClass
{
    return [AmazonSESClient class];
}

- (SEL)clientSelector
{
    NSDictionary *mapping =
    @{
        @"SESDeleteIdentityRequest":                        @"deleteIdentity:",
        @"SESDeleteVerifiedEmailAddressRequest":            @"deleteVerifiedEmailAddress:",
        @"SESGetIdentityDkimAttributesRequest":             @"getIdentityDkimAttributes:",
        @"SESGetIdentityNotificationAttributesRequest":     @"getIdentityNotificationAttributes:",
        @"SESGetIdentityVerificationAttributesRequest":     @"getIdentityVerificationAttributes:",
        @"SESGetSendQuotaRequest":                          @"getSendQuota:",
        @"SESGetSendStatisticsRequest":                     @"getSendStatistics:",
        @"SESListIdentitiesRequest":                        @"listIdentities:",
        @"SESListVerifiedEmailAddressesRequest":            @"listVerifiedEmailAddresses:",
        @"SESSendEmailRequest":                             @"sendEmail:",
        @"SESSendRawEmailRequest":                          @"sendRawEmail:",
        @"SESSetIdentityDkimEnabledRequest":                @"setIdentityDkimEnabled:",
        @"SESSetIdentityFeedbackForwardingEnabledRequest":  @"setIdentityFeedbackForwardingEnabled:",
        @"SESSetIdentityNotificationTopicRequest":          @"setIdentityNotificationTopic:",
        @"SESVerifyDomainDkimRequest":                      @"verifyDomainDkim:",
        @"SESVerifyDomainIdentityRequest":                  @"verifyDomainIdentity:",
        @"SESVerifyEmailAddressRequest":                    @"verifyEmailAddress:",
        @"SESVerifyEmailIdentityRequest":                   @"verifyEmailIdentity:"
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