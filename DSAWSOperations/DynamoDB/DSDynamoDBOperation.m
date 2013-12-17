//
//  DSDDBOperation.m
//  Kestrel
//
//  Created by Rob Amos on 16/12/2013.
//  Copyright (c) 2013 Desto. All rights reserved.
//

#import "DSDynamoDBOperation.h"
#import <AWSiOSSDK/DynamoDB/AWSDynamoDB.h>

#pragma mark Private Methods

@interface DSDynamoDBOperation ()

@end

#pragma mark - Implementation

@implementation DSDynamoDBOperation

#pragma mark Operation Configuration

- (BOOL)isRegionFree
{
    return NO;
}

// An instance of the client used to execute this operation
- (Class)clientClass
{
    return [AmazonDynamoDBClient class];
}

- (SEL)clientSelector
{
    NSDictionary *mapping =
    @{
        @"DynamoDBBatchGetItemRequest":     @"batchGetItem:",
        @"DynamoDBBatchWriteItemRequest":   @"batchWriteItem:",
        @"DynamoDBCreateTableRequest":      @"createTable:",
        @"DynamoDBDeleteItemRequest":       @"deleteItem:",
        @"DynamoDBDeleteTableRequest":      @"deleteTable:",
        @"DynamoDBDescribeTableRequest":    @"describeTable:",
        @"DynamoDBGetItemRequest":          @"getItem:",
        @"DynamoDBListTablesRequest":       @"listTables:",
        @"DynamoDBPutItemRequest":          @"putItem:",
        @"DynamoDBQueryRequest":            @"query:",
        @"DynamoDBScanRequest":             @"scan:",
        @"DynamoDBUpdateItemRequest":       @"updateItem:",
        @"DynamoDBUpdateTableRequest":      @"updateTable:",
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