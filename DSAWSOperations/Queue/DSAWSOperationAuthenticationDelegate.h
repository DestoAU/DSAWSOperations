//
//  DSAWSOperationAuthenticationDelegate.h
//  Kestrel
//
//  Created by Rob Amos on 17/12/2013.
//  Copyright (c) 2013 Desto. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AmazonCredentials, DSRegion, DSAWSOperation;

@protocol DSAWSOperationAuthenticationDelegate <NSObject>

/**
 * The Amazon Credentials to use.
 *
 * @param   op                  The operation requiring credentials.
 * @returns                     You should return a configured AmazonCredentials object.
**/
- (AmazonCredentials *)amazonCredentialsForOperation:(DSAWSOperation *)op;

/**
 * The region to use.
 *
 * This delegate method may not be called if the operation is considered to be "region free",
 * that is, it does not require a region to function (such as IAM, Route53, etc).
 *
 * @param   op                  The operation requiring region information.
 * @returns                     You should return a configured DSRegion object.
**/
- (DSRegion *)regionForOperation:(DSAWSOperation *)op;

@end
