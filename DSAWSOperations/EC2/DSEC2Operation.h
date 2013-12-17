//
//  DSEC2GenericOperation.h
//  Kestrel
//
//  Created by Rob Amos on 3/10/2013.
//  Copyright (c) 2013 Desto. All rights reserved.
//

#import "DSAWSOperation.h"

@class EC2Instance;

@interface DSEC2Operation : DSAWSOperation

/**
 * Wait until the specified instance reaches a running state.
 *
 * Calls the completion block once the instance is running, or if the instance can never become available.
 *
 * @param   instance                An EC2Instance to monitor for changes in status. We keep waiting as long as the instance is pending.
 * @param   owner                   The object that owns this request for grouping and easy cancellation.
 * @returns                         Configured DSEC2Operation. You'll need to schedule it in an NSOperationQueue, typically DSAWSOperationQueue.
**/
+ (DSEC2Operation *)waitOperationUntilInstanceRunning:(EC2Instance *)instance owner:(id)owner completion:(DSAWSOperationCompletionBlock)completion;

/**
 * Wait until the specified instance reaches a stopped state.
 *
 * Calls the completion block once the instance is stopped, or if the instance can never become stopped.
 *
 * @param   instance                An EC2Instance to monitor for changes in status. We keep waiting until the instance is stopped.
 * @param   owner                   The object that owns this request for grouping and easy cancellation.
 * @returns                         Configured DSEC2Operation. You'll need to schedule it in an NSOperationQueue, typically DSAWSOperationQueue.
**/
+ (DSEC2Operation *)waitOperationUntilInstanceStopped:(EC2Instance *)instance owner:(id)owner completion:(DSAWSOperationCompletionBlock)completion;

/**
 * Wait until the specified instance reaches a terminated state.
 *
 * Calls the completion block once the instance is terminated, or if the instance can never become terminated.
 *
 * @param   instance                An EC2Instance to monitor for changes in status. We keep waiting until the instance is terminated.
 * @param   owner                   The object that owns this request for grouping and easy cancellation.
 * @returns                         Configured DSEC2Operation. You'll need to schedule it in an NSOperationQueue, typically DSAWSOperationQueue.
 **/
+ (DSEC2Operation *)waitOperationUntilInstanceTerminated:(EC2Instance *)instance owner:(id)owner completion:(DSAWSOperationCompletionBlock)completion;

@end
