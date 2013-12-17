//
//  DSEC2DescribeRegionsOperation.m
//  Kestrel
//
//  Created by Rob Amos on 8/10/2013.
//  Copyright (c) 2013 Desto. All rights reserved.
//

#import "DSEC2DescribeRegionsOperation.h"
#import <AWSEC2/AWSEC2.h>

#pragma mark Private Methods

@interface DSEC2DescribeRegionsOperation ()

@property (nonatomic, strong) AmazonCredentials *credentials;

@end

#pragma mark - Implementation

@implementation DSEC2DescribeRegionsOperation

@synthesize credentials=__credentials;

#pragma mark - DSAWSGenericOperation Overrides

- (BOOL)isRegionFree
{
    return YES;
}

- (Class)clientClass
{
    return [AmazonEC2Client class];
}

- (SEL)clientSelector
{
    return @selector(describeRegions:);
}

- (AmazonCredentials *)amazonCredentials
{
    return self.credentials;
}

- (void)setAmazonCredentials:(AmazonCredentials *)credentials
{
    [self setCredentials:credentials];
}

@end
