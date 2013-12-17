//
//  DSAWSGenericOperation.h
//  Kestrel
//
//  Created by Rob Amos on 3/10/2013.
//  Copyright (c) 2013 Desto. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DSAWSOperationCompletionBlock)(id response, NSException *exception);
typedef BOOL(^DSAWSOperationShouldContinueWaitingBlock)(id response, NSException *exception);


@class AmazonCredentials, DSRegion, DSAWSOperationQueue;

@interface DSAWSOperation : NSOperation

/**
 * The request that will be sent to the AWS APIs.
**/
@property (nonatomic, strong) id request;

/**
 * The response from the AWS APIs. This will be nil if an exception has occured.
 **/
@property (nonatomic, strong) id response;

/**
 * Any exception that was caught. Typically this would be an instance of AmazonServiceException
 * or AmazonClientException depending on the type of error.
**/
@property (nonatomic, strong) NSException *exception;

/**
 * The owner of this operation. Typically this is the controller or object that has initiated the request.
 *
 * When your view controller is about to disappear, or your object will be dealloc'd you should call
 * [[DSAWSOperationQueue sharedInstance] cancelAllOperationsWithOwner:obj] to have the matching operations
 * cancelled.
**/
@property (nonatomic, weak) id owner;

/**
 * The internal completion block (so named to avoid conflicts with the default completionBlock property).
 *
 * You typically provide this on initiation but you can change it as required. This completion block
 * is always called on the main thread.
 *
 * It accepts two arguments: the response from the AWS SDK (which may be nil), an an instance of NSException, if one occured.
**/
@property (nonatomic, strong) DSAWSOperationCompletionBlock internalCompletionBlock;

/**
 * The block used to determine if the operation has completed or should continue waiting. The operation will wait
 * automatically as long as this block returns YES. Up to the number maximum number of polling attempts.
 *
 * It accepts two arguments: the response from the AWS SDK (which may be nil) and an instance of NSException, if one occured.
 **/
@property (nonatomic, strong) DSAWSOperationShouldContinueWaitingBlock shouldContinueWaiting;

/**
 * A reference to the NSOperationQueue subclass that we are residing on. Used for authentication.
**/
@property (nonatomic, weak) DSAWSOperationQueue *queue;

/**
 * Creates a pre-configured operation.
 *
 * @param   request                 The pre-configured AWS SDK request.
 * @param   owner                   The object that is the owner of this operation.
 * @param   completion              The block to execute on completion. This block is executed on the main queue and receives
 *                                  two arguments: the response from the AWS SDK (which may be nil) and an NSException, if one occured.
 * @returns                         Configured DSAWSOperation. You will need to add it to the queue manually for it to be executed.
**/
+ (id)operationWithRequest:(id)request owner:(id)owner completion:(DSAWSOperationCompletionBlock)completion;

/**
 * Creates a pre-configured wait operation.
 *
 * @param   request                 The pre-configured AWS SDK request.
 * @param   owner                   The object that is the owner of this operation.
 * @param   shouldContinueWaiting   The block to execute to decide if we should continue waiting. This block is executed on the background
 *                                  thread where the operation is executing. It receives two arguments: the response from the AWS SDK
 *                                  (which may be nil) and an NSException, if one occured. It should return YES if the operation should
 *                                  continue to wait, or NO to end execution and call the completion block.
 * @param   completion              The block to execute on completion. This block is executed on the main queue and receives
 *                                  two arguments: the response from the AWS SDK (which may be nil) and an NSException, if one occured.
 * @returns                         Configured DSAWSOperation. You will need to add it to the queue manually for it to be executed.
**/
+ (id)waitOperationWithRequest:(id)request owner:(id)owner shouldContinueWaiting:(DSAWSOperationShouldContinueWaitingBlock)shouldContinueWaiting completion:(DSAWSOperationCompletionBlock)completion;

/**
 * Creates a pre-configured wait operation looking for a specific keypath to be set to a list of values.
 *
 * @param   request                 The pre-configured AWS SDK request.
 * @param   owner                   The object that is the owner of this operation.
 * @param   keyPath                 The key path to check against the response. The values found at this keypath will be checked against
 *                                  the values parameter. If any of them are found in there the operation will stop waiting and call the
 *                                  completion block.
 * @param   values                  An NSArray of values, typically strings or numbers. If any of the objects found at keyPath is one of
 *                                  the values in this array the operation will stop waiting.
 * @param   completion              The block to execute on completion. This block is executed on the main queue and receives
 *                                  two arguments: the response from the AWS SDK (which may be nil) and an NSException, if one occured.
 * @returns                         Configured DSAWSOperation which will start polling immediately. You will need to add it to the queue manually for it to be executed.
**/
+ (id)waitOperationWithRequest:(id)request owner:(id)owner untilKeyPath:(NSString *)keyPath inArray:(NSArray *)values completion:(DSAWSOperationCompletionBlock)completion;

/**
 * Creates a pre-configured wait operation looking for a specific keypath to be set to a list of values.
 *
 * @param   request                 The pre-configured AWS SDK request.
 * @param   owner                   The object that is the owner of this operation.
 * @param   keyPath                 The key path to check against the response. The values found at this keypath will be checked against
 *                                  the values parameter. If any of them are found in there the operation will stop waiting and call the
 *                                  completion block.
 * @param   values                  An NSArray of values, typically strings or numbers. If any of the objects found at keyPath is one of
 *                                  the values in this array the operation will stop waiting.
 * @param   completion              The block to execute on completion. This block is executed on the main queue and receives
 *                                  two arguments: the response from the AWS SDK (which may be nil) and an NSException, if one occured.
 * @param   checkImmediately        Whether to start polling immediately. If you've just changed something in AWS you will probably want
 *                                  to skip the immediate polling cycle as nothing will have happened yet.
 * @returns                         Configured DSAWSOperation. You will need to add it to the queue manually for it to be executed.
**/
+ (id)waitOperationWithRequest:(id)request owner:(id)owner untilKeyPath:(NSString *)keyPath inArray:(NSArray *)values completion:(DSAWSOperationCompletionBlock)completion checkImmediately:(BOOL)checkImmediately;

/**
 * Whether the current operation is region-less, that is, it can execute in a global context.
 *
 * @returns     YES when the operation is not bound to a region, NO otherwise.
**/
- (BOOL)isRegionFree;

/**
 * The AmazonWebServicesClient subclass to use to execute this request.
 *
 * When overriding, return the appropriate subclass for your operation. This client class will be
 * instantiated and used to execute the request.
**/
- (Class)clientClass;

/**
 * The selector on the AmazonWebServicesClient used to execute this request.
 *
 * When overriding, this method should return the selector to be used on the client returned
 * by -client.
**/
- (SEL)clientSelector;

/**
 * The credentials to use to execute this request. Defaults to requesting the credentials from the queue's authentication delegate.
 *
 * Override it if necessary.
**/
- (AmazonCredentials *)amazonCredentials;

/**
 * The Region to execute the request in. Defaults to requesting the region from the queue's authentication delegate.
 *
 * Override if necessary.
**/
- (DSRegion *)region;

/**
 * The number of seconds to wait (for wait operations) between polling attempts.
 *
 * Defaults to 15 seconds. Override if necessary.
**/
- (NSTimeInterval)pollingInterval;

/**
 * The maximum number of polling attempts to try.
 *
 * Defaults to 40. So 10 minutes with a 15 second polling interval.
**/
- (NSUInteger)pollingMaxAttempts;


/** @name Execution Management **/

/**
 * Whether the operation is currently executing.
**/
@property (nonatomic, getter=isExecuting) BOOL executing;

/**
 * Whether the operation is finished.
**/
@property (nonatomic, getter=isFinished) BOOL finished;

@end
