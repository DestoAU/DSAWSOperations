//
//  DSSNSOperation.m
//  Kestrel
//
//  Created by Rob Amos on 16/12/2013.
//  Copyright (c) 2013 Desto. All rights reserved.
//

#import "DSSNSOperation.h"
#import <AWSiOSSDK/SNS/AWSSNS.h>

#pragma mark Private Methods

@interface DSSNSOperation ()

@end

#pragma mark - Implementation

@implementation DSSNSOperation

#pragma mark Operation Configuration

- (BOOL)isRegionFree
{
    return NO;
}

// An instance of the client used to execute this operation
- (Class)clientClass
{
    return [AmazonSNSClient class];
}

- (SEL)clientSelector
{
    NSDictionary *mapping =
    @{
        @"SNSAddPermissionRequest":                       @"addPermission:",
        @"SNSConfirmSubscriptionRequest":                 @"confirmSubscription:",
        @"SNSCreatePlatformApplicationRequest":           @"createPlatformApplication:",
        @"SNSCreatePlatformEndpointRequest":              @"createPlatformEndpoint:",
        @"SNSCreateTopicRequest":                         @"createTopic:",
        @"SNSDeleteEndpointRequest":                      @"deleteEndpoint:",
        @"SNSDeletePlatformApplicationRequest":           @"deletePlatformApplication:",
        @"SNSDeleteTopicRequest":                         @"deleteTopic:",
        @"SNSGetEndpointAttributesRequest":               @"getEndpointAttributes:",
        @"SNSGetPlatformApplicationAttributesRequest":    @"getPlatformApplicationAttributes:",
        @"SNSGetSubscriptionAttributesRequest":           @"getSubscriptionAttributes:",
        @"SNSGetTopicAttributesRequest":                  @"getTopicAttributes:",
        @"SNSListEndpointsByPlatformApplicationRequest":  @"listEndpointsByPlatformApplication:",
        @"SNSListPlatformApplicationsRequest":            @"listPlatformApplications:",
        @"SNSListSubscriptionsByTopicRequest":            @"listSubscriptionsByTopic:",
        @"SNSListSubscriptionsRequest":                   @"listSubscriptions:",
        @"SNSListTopicsRequest":                          @"listTopics:",
        @"SNSPublishRequest":                             @"publish:",
        @"SNSRemovePermissionRequest":                    @"removePermission:",
        @"SNSSetEndpointAttributesRequest":               @"setEndpointAttributes:",
        @"SNSSetPlatformApplicationAttributesRequest":    @"setPlatformApplicationAttributes:",
        @"SNSSetSubscriptionAttributesRequest":           @"setSubscriptionAttributes:",
        @"SNSSetTopicAttributesRequest":                  @"setTopicAttributes:",
        @"SNSSubscribeRequest":                           @"subscribe:",
        @"SNSUnsubscribeRequest":                         @"unsubscribe:"
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
