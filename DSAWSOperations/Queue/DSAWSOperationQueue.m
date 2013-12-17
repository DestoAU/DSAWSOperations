//
//  DSAWSOperationQueue.m
//  Kestrel
//
//  Created by Rob Amos on 3/10/2013.
//  Copyright (c) 2013 Desto. All rights reserved.
//

#import "DSAWSOperationQueue.h"
#import "DSAWSOperation.h"

#pragma mark Private Methods

@interface DSAWSOperationQueue ()

- (AmazonCredentials *)amazonCredentialsForOperation:(DSAWSOperation *)op;
- (DSRegion *)regionForOperation:(DSAWSOperation *)op;

@end

#pragma mark - Implementation

@implementation DSAWSOperationQueue

@synthesize cancelled=_cancelled, delegate=_delegate;

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    static DSAWSOperationQueue *awsQueue;
    dispatch_once(&onceToken, ^
    {
        awsQueue = [[DSAWSOperationQueue alloc] init];
    });
    return awsQueue;
}

// Initialisation
- (id)init
{
    if (self = [super init])
    {
        // we're not cancelled when we start
        [self setCancelled:NO];
        
        // nor suspended
        [self setSuspended:NO];
    }
    return self;
}

#pragma mark - Adding operations

- (void)addOperation:(NSOperation *)op
{
    if ([op isKindOfClass:[DSAWSOperation class]])
        [((DSAWSOperation *)op) setQueue:self];
    [super addOperation:op];
}

- (void)addOperations:(NSArray *)ops waitUntilFinished:(BOOL)wait
{
    for (NSOperation *op in ops)
    {
        if ([op isKindOfClass:[DSAWSOperation class]])
            [((DSAWSOperation *)op) setQueue:self];
    }
    [super addOperations:ops waitUntilFinished:wait];
}

#pragma mark - Execution Management

- (void)cancel
{
    [self setCancelled:YES];
    [self cancelAllOperations];
}

- (void)cancelAllOperationsForOwner:(id)owner
{
    if (owner == nil || [self operationCount] == 0)
        return;
    
    for (NSOperation *op in self.operations)
    {
        if ([op isKindOfClass:[DSAWSOperation class]])
        {
            DSAWSOperation *awsOp = (DSAWSOperation *)op;
            if (awsOp.owner != nil && [awsOp.owner isEqual:owner])
                [awsOp cancel];
        }
    }
}

#pragma mark - Authentication Management

- (AmazonCredentials *)amazonCredentialsForOperation:(DSAWSOperation *)op
{
    id<DSAWSOperationAuthenticationDelegate> delegate = self.delegate;
    if (delegate != nil && [delegate respondsToSelector:@selector(amazonCredentialsForOperation:)])
        return [delegate amazonCredentialsForOperation:op];
    return nil;
}

- (DSRegion *)regionForOperation:(DSAWSOperation *)op
{
    id<DSAWSOperationAuthenticationDelegate> delegate = self.delegate;
    if (delegate != nil && [delegate respondsToSelector:@selector(regionForOperation:)])
        return [delegate regionForOperation:op];
    return nil;
}

@end
