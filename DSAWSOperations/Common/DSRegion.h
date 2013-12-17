//
//  DSRegion.h
//  Kestrel
//
//  Created by Rob Amos on 29/08/2013.
//  Copyright (c) 2013 Desto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSRuntime/AWSRuntime.h>

@class EC2Region;

@interface DSRegion : NSObject <NSCoding>

/**
 * The name of the region. Typically used for display.
**/
@property (nonatomic, readonly) NSString *name;

/**
 * The region's shortname such as us-east-1.
**/
@property (nonatomic, readonly) NSString *shortname;

/**
 * The Amazon Region identifier
**/
@property (nonatomic) AmazonRegion amazonRegion;


/**
 * Retrieves the service endpoint for the given AWS client class in the current region.
 *
 * @param   serviceClass                The AWS client class. e.g. [AmazonEc2Client class]
 * @param   secure                      YES if the endpoint should be HTTPS, NO otherwise.
 * @returns                             The endpoint URL as a string (for use with the AWS clients' -setEndpoint: call.
**/
- (NSString *)endpointForService:(__unsafe_unretained Class)serviceClass secure:(BOOL)secure;

/**
 * Creates a region from the given EC2Region object.
 *
 * @param   ec2Region                   An EC2Region object, typically returned in an EC2DescribeRegionsResponse.
 * @returns                             Configured DSRegion based on the EC2Region.
**/
+ (DSRegion *)regionForEC2Region:(EC2Region *)ec2Region;

/**
 * Creates a region from the given AmazonRegion constant.
 *
 * @param   amazonRegion                An AmazonRegion constant.
 * @returns                             Configured DSRegion based on the AmazonRegion.
**/
+ (DSRegion *)regionForAmazonRegion:(AmazonRegion)amazonRegion;


/** @name Comparisons **/

/**
 * Checks whether the receiver is equal to the specified DSRegion.
 *
 * @param   aRegion         Another DSRegion object to compare against.
 * @returns                 YES if they represent the same region, NO otherwise.
**/
- (BOOL)isEqualToRegion:(DSRegion *)aRegion;

@end
