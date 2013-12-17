//
//  DSSimpleDBOperation.m
//  Kestrel
//
//  Created by Rob Amos on 16/12/2013.
//  Copyright (c) 2013 Desto. All rights reserved.
//

#import "DSSimpleDBOperation.h"
#import <AWSiOSSDK/SimpleDB/AmazonSimpleDBClient.h>

#pragma mark Private Methods

@interface DSSimpleDBOperation ()

@end

#pragma mark - Implementation

@implementation DSSimpleDBOperation

#pragma mark Operation Configuration

- (BOOL)isRegionFree
{
    return NO;
}

// An instance of the client used to execute this operation
- (Class)clientClass
{
    return [AmazonSimpleDBClient class];
}

- (SEL)clientSelector
{
    NSDictionary *mapping =
    @{
        @"SimpleDBBatchDeleteAttributesRequest":    @"batchDeleteAttributes:",
        @"SimpleDBBatchPutAttributesRequest":       @"batchPutAttributes:",
        @"SimpleDBCreateDomainRequest":             @"createDomain:",
        @"SimpleDBDeleteAttributesRequest":         @"deleteAttributes:",
        @"SimpleDBDeleteDomainRequest":             @"deleteDomain:",
        @"SimpleDBDomainMetadataRequest":           @"domainMetadata:",
        @"SimpleDBGetAttributesRequest":            @"getAttributes:",
        @"SimpleDBListDomainsRequest":              @"listDomains:",
        @"SimpleDBPutAttributesRequest":            @"putAttributes:",
        @"SimpleDBSelectRequest":                   @"select:"
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