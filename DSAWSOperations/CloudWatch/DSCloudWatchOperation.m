//
//  DSCloudWatchOperation.m
//  Kestrel
//
//  Created by Rob Amos on 22/11/2013.
//  Copyright (c) 2013 Desto. All rights reserved.
//

#import "DSCloudWatchOperation.h"
#import <AWSiOSSDK/CloudWatch/AmazonCloudWatchClient.h>

#pragma mark Private Methods

@interface DSCloudWatchOperation ()

@end

#pragma mark - Implementation

@implementation DSCloudWatchOperation

#pragma mark Operation Configuration

- (BOOL)isRegionFree
{
    return NO;
}

// An instance of the client used to execute this operation
- (Class)clientClass
{
    return [AmazonCloudWatchClient class];
}

- (SEL)clientSelector
{
    NSDictionary *mapping =
    @{
        @"CloudWatchDeleteAlarmsRequest":                   @"deleteAlarms:",
        @"CloudWatchDescribeAlarmHistoryRequest":           @"describeAlarmHistory:",
        @"CloudWatchDescribeAlarmsRequest":                 @"describeAlarms:",
        @"CloudWatchDescribeAlarmsForMetricRequest":        @"describeAlarmsForMetric:",
        @"CloudWatchDisableAlarmActionsRequest":            @"disableAlarmActions:",
        @"CloudWatchEnableAlarmActionsRequest":             @"enableAlarmActions:",
        @"CloudWatchGetMetricStatisticsRequest":            @"getMetricStatistics:",
        @"CloudWatchListMetricsRequest":                    @"listMetrics:",
        @"CloudWatchPutMetricAlarmRequest":                 @"putMetricAlarm:",
        @"CloudWatchPutMetricDataRequest":                  @"putMetricData:",
        @"CloudWatchSetAlarmStateRequest":                  @"setAlarmState:"
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
