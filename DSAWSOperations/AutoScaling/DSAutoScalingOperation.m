//
//  DSAutoScalingOperation.m
//  Kestrel
//
//  Created by Rob Amos on 16/12/2013.
//  Copyright (c) 2013 Desto. All rights reserved.
//

#import "DSAutoScalingOperation.h"
#import <AWSiOSSDK/AutoScaling/AmazonAutoScalingClient.h>

#pragma mark Private Methods

@interface DSAutoScalingOperation ()

@end

#pragma mark - Implementation

@implementation DSAutoScalingOperation

#pragma mark Operation Configuration

- (BOOL)isRegionFree
{
    return NO;
}

// An instance of the client used to execute this operation
- (Class)clientClass
{
    return [AmazonAutoScalingClient class];
}

- (SEL)clientSelector
{
    NSDictionary *mapping =
    @{
        @"AutoScalingCreateAutoScalingGroupRequest":                    @"createAutoScalingGroup:",
        @"AutoScalingCreateLaunchConfigurationRequest":                 @"createLaunchConfiguration:",
        @"AutoScalingCreateOrUpdateTagsRequest":                        @"createOrUpdateTags:",
        @"AutoScalingDeleteAutoScalingGroupRequest":                    @"deleteAutoScalingGroup:",
        @"AutoScalingDeleteLaunchConfigurationRequest":                 @"deleteLaunchConfiguration:",
        @"AutoScalingDeleteNotificationConfigurationRequest":           @"deleteNotificationConfiguration:",
        @"AutoScalingDeletePolicyRequest":                              @"deletePolicy:",
        @"AutoScalingDeleteScheduledActionRequest":                     @"deleteScheduledAction:",
        @"AutoScalingDeleteTagsRequest":                                @"deleteTags:",
        @"AutoScalingDescribeAdjustmentTypesRequest":                   @"describeAdjustmentTypes:",
        @"AutoScalingDescribeAutoScalingGroupsRequest":                 @"describeAutoScalingGroups:",
        @"AutoScalingDescribeAutoScalingInstancesRequest":              @"describeAutoScalingInstances:",
        @"AutoScalingDescribeAutoScalingNotificationTypesRequest":      @"describeAutoScalingNotificationTypes:",
        @"AutoScalingDescribeLaunchConfigurationsRequest":              @"describeLaunchConfigurations:",
        @"AutoScalingDescribeMetricCollectionTypesRequest":             @"describeMetricCollectionTypes:",
        @"AutoScalingDescribeNotificationConfigurationsRequest":        @"describeNotificationConfigurations:",
        @"AutoScalingDescribePoliciesRequest":                          @"describePolicies:",
        @"AutoScalingDescribeScalingActivitiesRequest":                 @"describeScalingActivities:",
        @"AutoScalingDescribeScalingProcessTypesRequest":               @"describeScalingProcessTypes:",
        @"AutoScalingDescribeScheduledActionsRequest":                  @"describeScheduledActions:",
        @"AutoScalingDescribeTagsRequest":                              @"describeTags:",
        @"AutoScalingDescribeTerminationPolicyTypesRequest":            @"describeTerminationPolicyTypes:",
        @"AutoScalingDisableMetricsCollectionRequest":                  @"disableMetricsCollection:",
        @"AutoScalingEnableMetricsCollectionRequest":                   @"enableMetricsCollection:",
        @"AutoScalingExecutePolicyRequest":                             @"executePolicy:",
        @"AutoScalingPutNotificationConfigurationRequest":              @"putNotificationConfiguration:",
        @"AutoScalingPutScalingPolicyRequest":                          @"putScalingPolicy:",
        @"AutoScalingPutScheduledUpdateGroupActionRequest":             @"putScheduledUpdateGroupAction:",
        @"AutoScalingResumeProcessesRequest":                           @"resumeProcesses:",
        @"AutoScalingSetDesiredCapacityRequest":                        @"setDesiredCapacity:",
        @"AutoScalingSetInstanceHealthRequest":                         @"setInstanceHealth:",
        @"AutoScalingSuspendProcessesRequest":                          @"suspendProcesses:",
        @"AutoScalingTerminateInstanceInAutoScalingGroupRequest":       @"terminateInstanceInAutoScalingGroup:",
        @"AutoScalingUpdateAutoScalingGroupRequest":                    @"updateAutoScalingGroup:"
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