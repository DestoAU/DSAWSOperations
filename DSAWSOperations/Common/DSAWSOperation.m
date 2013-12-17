//
//  DSAWSOperation.m
//  Kestrel
//
//  Created by Rob Amos on 3/10/2013.
//  Copyright (c) 2013 Desto. All rights reserved.
//

#import "DSAWSOperation.h"
#import <AWSiOSSDK/AmazonWebServiceClient.h>
#import "DSAWSOperationQueue.h"
#import "DSRegion.h"
#import "NSArray+DSArrayFlattening.h"

#pragma mark Private Methods

@interface DSAWSOperation ()

@property (nonatomic) BOOL checkImmediately;
@property (nonatomic) NSUInteger pollingAttempts;

// Default initialisation
- (id)initWithRequest:(id)request owner:(id)owner completion:(DSAWSOperationCompletionBlock)completion;
- (id)initWithRequest:(id)request owner:(id)owner shouldContinueWaiting:(DSAWSOperationShouldContinueWaitingBlock)shouldContinueWaiting completion:(DSAWSOperationCompletionBlock)completion;
- (id)initWithRequest:(id)request owner:(id)owner untilKeyPath:(NSString *)keyPath inArray:(NSArray *)values completion:(DSAWSOperationCompletionBlock)completion checkImmediately:(BOOL)checkImmediately;

- (void)poll;

@end

@interface DSAWSOperationQueue (Authentication)

- (AmazonCredentials *)amazonCredentialsForOperation:(DSAWSOperation *)op;
- (DSRegion *)regionForOperation:(DSAWSOperation *)op;

@end


@implementation DSAWSOperation

@synthesize internalCompletionBlock=_internalCompletionBlock, request=_request, executing=_executing, finished=_finished, response=_response, exception=_exception, owner=_owner, pollingAttempts=_pollingAttempts, checkImmediately=_checkImmediately, queue=_queue;

// Returning a pre-built request operation
+ (id)operationWithRequest:(id)request owner:(id)owner completion:(DSAWSOperationCompletionBlock)completion
{
    return [[self alloc] initWithRequest:request owner:owner completion:completion];
}

+ (id)waitOperationWithRequest:(id)request owner:(id)owner shouldContinueWaiting:(DSAWSOperationShouldContinueWaitingBlock)shouldContinueWaiting completion:(DSAWSOperationCompletionBlock)completion
{
    return [[self alloc] initWithRequest:request owner:owner shouldContinueWaiting:shouldContinueWaiting completion:completion];
}

+ (id)waitOperationWithRequest:(id)request owner:(id)owner untilKeyPath:(NSString *)keyPath inArray:(NSArray *)values completion:(DSAWSOperationCompletionBlock)completion checkImmediately:(BOOL)checkImmediately
{
    return [[self alloc] initWithRequest:request owner:owner untilKeyPath:keyPath inArray:values completion:completion checkImmediately:checkImmediately];
}


+ (id)waitOperationWithRequest:(id)request owner:(id)owner untilKeyPath:(NSString *)keyPath inArray:(NSArray *)values completion:(DSAWSOperationCompletionBlock)completion
{
    return [[self alloc] initWithRequest:request owner:owner untilKeyPath:keyPath inArray:values completion:completion checkImmediately:YES];
}

// Default initialisation
- (id)initWithRequest:(id)request owner:(id)owner completion:(DSAWSOperationCompletionBlock)completion
{
    if (self = [super init])
    {
        [self setRequest:request];
        [self setInternalCompletionBlock:completion];
        [self setOwner:owner];
        [self setQueuePriority:NSOperationQueuePriorityLow];

        // default to checking immediately
        [self setCheckImmediately:YES];

        // execution management
        [self setExecuting:NO];
        [self setFinished:NO];
    }
    return self;
}

- (void)setInternalCompletionBlock:(DSAWSOperationCompletionBlock)internalCompletionBlock
{
    _internalCompletionBlock = internalCompletionBlock;

    // set the completion block to call their completion block on the main queue
    // -- if they've provided one
    if (internalCompletionBlock != nil)
    {
        __block DSAWSOperation *blockSelf = self;
        [self setCompletionBlock:^
        {
            // only if we're not cancelled at this stage
            __block DSAWSOperationCompletionBlock internalBlock = internalCompletionBlock;
            if (![blockSelf isCancelled] && internalBlock != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^
                {
                    internalBlock(blockSelf.response, blockSelf.exception);
                });
            }
        }];
    } else
    {
        [self setCompletionBlock:nil];
    }
}

// Initialise a waiting request
- (id)initWithRequest:(id)request owner:(id)owner shouldContinueWaiting:(DSAWSOperationShouldContinueWaitingBlock)shouldContinueWaiting completion:(DSAWSOperationCompletionBlock)completion
{
    if (self = [self initWithRequest:request owner:owner completion:completion])
    {
        [self setShouldContinueWaiting:shouldContinueWaiting];
    }
    return self;
}

- (id)initWithRequest:(id)request owner:(id)owner untilKeyPath:(NSString *)keyPath inArray:(NSArray *)values completion:(DSAWSOperationCompletionBlock)completion checkImmediately:(BOOL)checkImmediately
{
    DSAWSOperationShouldContinueWaitingBlock shouldContinueWaiting = ^BOOL(id response, NSException *exception)
    {
        // we stop waiting on any exception
        if (exception != nil || response == nil)
            return NO;

        // see if we can find any matching rows on the keyPath
        @try
        {
            id value = [response valueForKeyPath:keyPath];

            // is the value an array?
            if ([value isKindOfClass:[NSArray class]])
            {
                // stop waiting when any of the matching objects is in the values list
                NSArray *valueList = [((NSArray *)value) ds_flattenedArray];
                for (id obj in valueList)
                {
                    // should not continue waiting
                    if ([values containsObject:obj])
                        return NO;
                }
                return YES; // keep waiting

            // otherwise, stop waiting when the returned value is in the list
            } else
            {
                return ![values containsObject:value];
            }
        }

        // can't find the keypath?
        @catch (NSException *e)
        {
            return NO;
        }
    };

    // initialise ourselves
    if (self = [self initWithRequest:request owner:owner shouldContinueWaiting:shouldContinueWaiting completion:completion])
        [self setCheckImmediately:checkImmediately];
    return self;
}

// We support concurrent operation
- (BOOL)isConcurrent
{
    return YES;
}

// By default everything is region free (just to be sure)
- (BOOL)isRegionFree
{
    return YES;
}

// no client by default
- (Class)clientClass
{
    return nil;
}

// also no selector by default
- (SEL)clientSelector
{
    return nil;
}

// wait 15 seconds between polling cycles by default
- (NSTimeInterval)pollingInterval
{
    return 15;
}

// try up to 8 times by default (so 2 minutes)
- (NSUInteger)pollingMaxAttempts
{
    return 40;
}

// ask the queue to provide the credentials
- (AmazonCredentials *)amazonCredentials
{
    DSAWSOperationQueue *queue = self.queue;
    NSAssert(queue != nil, @"You must run each DSAWSOperation on a DSAWSOperationQueue, or else override -amazonCredentials and -region.");

    return [queue amazonCredentialsForOperation:self];
}

// ask the queue to provide the region
- (DSRegion *)region
{
    DSAWSOperationQueue *queue = self.queue;
    NSAssert(queue != nil, @"You must run each DSAWSOperation on a DSAWSOperationQueue, or else override -amazonCredentials and -region.");

    return [queue regionForOperation:self];
}

#pragma mark - Execution

// Wrapper for non-concurrent operations
- (void)main
{
    [self start];
}

// Execute the operation!
- (void)start
{
    // firstly, have we been cancelled?
    if ([self isCancelled])
    {
        [self setFinished:YES];
        return;
    }

    // secondly, start executing
    [self setExecuting:YES];
    [self setPollingAttempts:0];

    // fire the first (and often only) poll
    if ([self checkImmediately])
        [self poll];
    else
    {
        // delayed first poll
        NSTimer *timer = [NSTimer timerWithTimeInterval:[self pollingInterval] target:self selector:@selector(poll) userInfo:nil repeats:NO];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addTimer:timer forMode:NSRunLoopCommonModes];
        [runLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:[self pollingInterval]]];
    }
}

// Grab everything from the server
- (void)poll
{
    Class clientClass = [self clientClass];
    SEL clientSelector = [self clientSelector];
    id request = self.request;
    AmazonCredentials *credentials = [self amazonCredentials];

    NSAssert(clientClass != nil, @"Client Class cannot be nil. Have you overridden -clientClass?");
    NSAssert(clientSelector != nil, @"Client Selector cannot be nil. Have you overridden -clientSelector?");
    NSAssert(request != nil, @"Request must be provided for all AWS Operations.");
    NSAssert(credentials != nil, @"Must have credentials for all AWS Operations.");

    // have we been cancelled since?
    if ([self isCancelled])
    {
        [self setFinished:YES];
        return;
    }

    @try
    {
        // so we want to capture the class and execute the operation
        AmazonWebServiceClient *client = [[clientClass alloc] initWithCredentials:credentials];

        // set the region if we're not regionless
        if (![self isRegionFree])
        {
            DSRegion *region = [self region];
            if (region != nil)
                [client setEndpoint:[region endpointForService:clientClass secure:YES]];
        }

        // ensure we can actually run this thing
        if (![client respondsToSelector:clientSelector])
        {
            [self setException:[NSException exceptionWithName:@"DSAWSClientSelectorNotFound"
                                                       reason:[NSString stringWithFormat:@"Client selector %@ not found on instance of class %@.", NSStringFromSelector(clientSelector), NSStringFromClass(clientClass)]
                                                     userInfo:nil]];
            [self setExecuting:NO];
            [self setFinished:YES];
        }

        // one last cancelled check before we fire
        if ([self isCancelled])
        {
            [self setExecuting:NO];
            [self setFinished:YES];
            return;
        }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

        // fire off the request to AWS
        NSLog(@"-[%@ %@] Executing operation.", NSStringFromClass(clientClass), NSStringFromSelector(clientSelector));
        [self setResponse:[client performSelector:clientSelector withObject:request]];

#pragma clang diagnostic pop

        // should we keep waiting?
        [self setPollingAttempts:(self.pollingAttempts + 1)];
        if (self.shouldContinueWaiting != nil && self.pollingAttempts < [self pollingMaxAttempts])
        {
            DSAWSOperationShouldContinueWaitingBlock shouldContinueWaiting = self.shouldContinueWaiting;
            if (shouldContinueWaiting(self.response, self.exception))
            {
                NSLog(@"-[%@ %@] Waiting.", NSStringFromClass(clientClass), NSStringFromSelector(clientSelector));

                // yes we should, poll again in the number of seconds
                NSTimer *timer = [NSTimer timerWithTimeInterval:[self pollingInterval] target:self selector:@selector(poll) userInfo:nil repeats:NO];
                NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
                [runLoop addTimer:timer forMode:NSRunLoopCommonModes];
                [runLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:[self pollingInterval]]];
                return;
            }
        }
        NSLog(@"-[%@ %@] Operation complete.", NSStringFromClass(clientClass), NSStringFromSelector(clientSelector));

        // all finished
        [self setExecuting:NO];
        [self setFinished:YES];

    }
    @catch (NSException *exception)
    {
        // save the exception
        NSLog(@"-[%@ %@]: Exception caught: %@", NSStringFromClass(clientClass), NSStringFromSelector(clientSelector), exception);
        NSLog(@"-[%@ %@] Operation complete.", NSStringFromClass(clientClass), NSStringFromSelector(clientSelector));
        [self setException:exception];
        [self setExecuting:NO];
        [self setFinished:YES];
    }
}

- (void)cancel
{
    NSLog(@"[%@] Cancelling Operation.", self);
    [super cancel];
}

@end
