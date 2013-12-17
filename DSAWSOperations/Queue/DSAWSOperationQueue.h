//
//  DSAWSOperationQueue.h
//  Kestrel
//
//  Created by Rob Amos on 3/10/2013.
//  Copyright (c) 2013 Desto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSAWSOperationAuthenticationDelegate.h"

@interface DSAWSOperationQueue : NSOperationQueue

/**
 * Whether we have cancelled all operations.
**/
@property (nonatomic, getter=isCancelled) BOOL cancelled;

/**
 * The delegate to use to obtain authentication information.
**/
@property (nonatomic, strong) id<DSAWSOperationAuthenticationDelegate> delegate;

/**
 * Returns the shared DSAWSOperationQueue instance.
**/
+ (id)sharedInstance;

/**
 * Cancels the operation of the queue.
**/
- (void)cancel;


/**
 * Cancels all operations for the specified owner.
**/
- (void)cancelAllOperationsForOwner:(id)owner;

@end
