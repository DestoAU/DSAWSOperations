//
//  DSSQSOperation.m
//  Kestrel
//
//  Created by Rob Amos on 16/12/2013.
//  Copyright (c) 2013 Desto. All rights reserved.
//

#import "DSSQSOperation.h"
#import <AWSiOSSDK/SQS/AmazonSQSClient.h>

#pragma mark Private Methods

@interface DSSQSOperation ()

@end

#pragma mark - Implementation

@implementation DSSQSOperation

#pragma mark Operation Configuration

- (BOOL)isRegionFree
{
    return NO;
}

// An instance of the client used to execute this operation
- (Class)clientClass
{
    return [AmazonSQSClient class];
}

- (SEL)clientSelector
{
    NSDictionary *mapping =
    @{
        @"SQSAddPermissionRequest":                     @"addPermission:",
        @"SQSChangeMessageVisibilityBatchRequest":      @"changeMessageVisibilityBatch:",
        @"SQSChangeMessageVisibilityRequest":           @"changeMessageVisibility:",
        @"SQSCreateQueueRequest":                       @"createQueue:",
        @"SQSDeleteMessageBatchRequest":                @"deleteMessageBatch:",
        @"SQSDeleteMessageRequest":                     @"deleteMessage:",
        @"SQSDeleteQueueRequest":                       @"deleteQueue:",
        @"SQSGetQueueAttributesRequest":                @"getQueueAttributes:",
        @"SQSGetQueueUrlRequest":                       @"getQueueUrl:",
        @"SQSListQueuesRequest":                        @"listQueues:",
        @"SQSReceiveMessageRequest":                    @"receiveMessage:",
        @"SQSRemovePermissionRequest":                  @"removePermission:",
        @"SQSSendMessageBatchRequest":                  @"sendMessageBatch:",
        @"SQSSendMessageRequest":                       @"sendMessage:",
        @"SQSSetQueueAttributesRequest":                @"setQueueAttributes:"
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