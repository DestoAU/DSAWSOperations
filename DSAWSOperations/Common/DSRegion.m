//
//  DSRegion.m
//  Kestrel
//
//  Created by Rob Amos on 29/08/2013.
//  Copyright (c) 2013 Desto. All rights reserved.
//

#import "DSRegion.h"
#import <objc/runtime.h>

#import <AWSiOSSDK/AutoScaling/AmazonAutoScalingClient.h>
#import <AWSiOSSDK/EC2/AmazonEC2Client.h>
#import <AWSiOSSDK/CloudWatch/AmazonCloudWatchClient.h>
#import <AWSiOSSDK/DynamoDB/AmazonDynamoDBClient.h>
#import <AWSiOSSDK/ElasticLoadBalancing/AmazonElasticLoadBalancingClient.h>
#import <AWSiOSSDK/SimpleDB/AmazonSimpleDBClient.h>
#import <AWSiOSSDK/S3/AmazonS3Client.h>
#import <AWSiOSSDK/SES/AmazonSESClient.h>
#import <AWSiOSSDK/SNS/AmazonSNSClient.h>
#import <AWSiOSSDK/SQS/AmazonSQSClient.h>
#import <AWSiOSSDK/STS/AmazonSecurityTokenServiceClient.h>

#define REGION_ENCODING_KEY_AMAZON_REGION @"RegionEncodingKeyAmazonRegion"
#define REGION_ENCODING_KEY_EC2REGION_NAME @"RegionEncodingKeyEC2RegionName"
#define REGION_ENCODING_KEY_EC2REGION_ENDPOINT @"RegionEncodingKeyEC2RegionEndpoint"

#pragma mark Private Methods

@interface DSRegion ()

@property (nonatomic, strong) EC2Region *ec2Region;

@end

#pragma mark - Implementation

@implementation DSRegion

@synthesize name=_name, ec2Region=_ec2Region;

// The Region's Display Name
- (NSString *)name
{
    switch (self.amazonRegion)
    {
        case US_EAST_1:
            return @"US East (North Virginia)";

        case US_WEST_1:
            return @"US West (Oregon)";

        case US_WEST_2:
            return @"US West (North California)";

        case EU_WEST_1:
            return @"Europe (Ireland)";

        case AP_NORTHEAST_1:
            return @"Asia Pacific (Tokyo)";

        case AP_SOUTHEAST_1:
            return @"Asia Pacific (Singapore)";

        case AP_SOUTHEAST_2:
            return @"Asia Pacific (Sydney)";

        case SA_EAST_1:
            return @"South America (Sāo Paulo)";

        default:
            return [self shortname];
    }
}

// Retrieve the shortname
- (NSString *)shortname
{
    switch (self.amazonRegion)
    {
        case US_EAST_1:
            return @"North Virginia";

        case US_WEST_1:
            return @"Oregon";

        case US_WEST_2:
            return @"North California";

        case EU_WEST_1:
            return @"Ireland";

        case AP_NORTHEAST_1:
            return @"Tokyo";

        case AP_SOUTHEAST_1:
            return @"Singapore";

        case AP_SOUTHEAST_2:
            return @"Sydney";

        case SA_EAST_1:
            return @"Sāo Paulo";

        default:
            return self.ec2Region.regionName;
    }
}

// Retrieve the endpoint for a specific service
- (NSString *)endpointForService:(__unsafe_unretained Class)serviceClass secure:(BOOL)secure
{
    // Auto Scaling
    if ([serviceClass isSubclassOfClass:[AmazonAutoScalingClient class]])
        return [AmazonEndpoints autoscalingEndpoint:self.amazonRegion secure:secure];

    // CloudWatch
    else if ([serviceClass isSubclassOfClass:[AmazonCloudWatchClient class]])
        return [AmazonEndpoints cwEndpoint:self.amazonRegion secure:secure];

    // DynamoDB
    else if ([serviceClass isSubclassOfClass:[AmazonDynamoDBClient class]])
        return [AmazonEndpoints ddbEndpoint:self.amazonRegion secure:secure];

    // EC2
    else if ([serviceClass isSubclassOfClass:[AmazonEC2Client class]])
        return [AmazonEndpoints ec2Endpoint:self.amazonRegion secure:secure];

    // Elastic Load Balancing
    else if ([serviceClass isSubclassOfClass:[AmazonElasticLoadBalancingClient class]])
        return [AmazonEndpoints elbEndpoint:self.amazonRegion secure:secure];

    // SimpleDB
    else if ([serviceClass isSubclassOfClass:[AmazonSimpleDBClient class]])
        return [AmazonEndpoints sdbEndpoint:self.amazonRegion secure:secure];

    // Simple Storage Service
    else if ([serviceClass isSubclassOfClass:[AmazonS3Client class]])
        return [AmazonEndpoints s3Endpoint:self.amazonRegion secure:secure];

    // Simple Email Service
    else if ([serviceClass isSubclassOfClass:[AmazonSESClient class]])
        return [AmazonEndpoints sesEndpoint:self.amazonRegion secure:secure];

    // Simple Notification Service
    else if ([serviceClass isSubclassOfClass:[AmazonSNSClient class]])
        return [AmazonEndpoints snsEndpoint:self.amazonRegion secure:secure];

    // Simple Queueing Service
    else if ([serviceClass isSubclassOfClass:[AmazonSQSClient class]])
        return [AmazonEndpoints sqsEndpoint:self.amazonRegion secure:secure];

    // Security Token Service
    else if ([serviceClass isSubclassOfClass:[AmazonSecurityTokenServiceClient class]])
        return [AmazonEndpoints stsEndpoint];

    // Default to the unknown
    return nil;
}


#pragma mark - Creating new DSRegions

+ (DSRegion *)regionForEC2Region:(EC2Region *)ec2Region
{
    DSRegion *region = [[self alloc] init];

    // set the EC2 region
    [region setEc2Region:ec2Region];

    // set the Amazon Region Constant if we know it
    if ([ec2Region.regionName isEqualToString:@"us-east-1"])
        [region setAmazonRegion:US_EAST_1];

    else if ([ec2Region.regionName isEqualToString:@"us-west-1"])
        [region setAmazonRegion:US_WEST_1];

    else if ([ec2Region.regionName isEqualToString:@"us-west-2"])
        [region setAmazonRegion:US_WEST_2];

    else if ([ec2Region.regionName isEqualToString:@"eu-west-1"])
        [region setAmazonRegion:EU_WEST_1];

    else if ([ec2Region.regionName isEqualToString:@"ap-southeast-1"])
        [region setAmazonRegion:AP_SOUTHEAST_1];

    else if ([ec2Region.regionName isEqualToString:@"ap-northeast-1"])
        [region setAmazonRegion:AP_NORTHEAST_1];

    else if ([ec2Region.regionName isEqualToString:@"ap-southeast-2"])
        [region setAmazonRegion:AP_SOUTHEAST_2];

    else if ([ec2Region.regionName isEqualToString:@"sa-east-1"])
        [region setAmazonRegion:SA_EAST_1];

    return region;
}

+ (DSRegion *)regionForAmazonRegion:(AmazonRegion)amazonRegion
{
    DSRegion *region = [[self alloc] init];
    [region setAmazonRegion:amazonRegion];
    return region;
}

#pragma mark - NSCoding Methods

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(self.amazonRegion) forKey:REGION_ENCODING_KEY_AMAZON_REGION];
    [aCoder encodeObject:self.ec2Region.regionName forKey:REGION_ENCODING_KEY_EC2REGION_NAME];
    [aCoder encodeObject:self.ec2Region.endpoint forKey:REGION_ENCODING_KEY_EC2REGION_ENDPOINT];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init])
    {
        // Set the AmazonRegion
        AmazonRegion region = [[aDecoder decodeObjectForKey:REGION_ENCODING_KEY_AMAZON_REGION] unsignedIntegerValue];
        [self setAmazonRegion:region];

        // Create the EC2Region
        EC2Region *ec2Region = [[EC2Region alloc] init];
        [ec2Region setRegionName:[aDecoder decodeObjectForKey:REGION_ENCODING_KEY_EC2REGION_NAME]];
        [ec2Region setEndpoint:[aDecoder decodeObjectForKey:REGION_ENCODING_KEY_EC2REGION_ENDPOINT]];
        [self setEc2Region:ec2Region];
    }
    return self;
}

#pragma mark - Comparison Functions

- (BOOL)isEqualToRegion:(DSRegion *)aRegion
{
    return self.amazonRegion == aRegion.amazonRegion;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[self class]])
        return NO;
    return [self isEqualToRegion:object];
}

- (NSUInteger)hash
{
    return (NSUInteger)self.amazonRegion;
}

@end
