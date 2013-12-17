//
//  DSEC2GenericOperation.m
//  Kestrel
//
//  Created by Rob Amos on 3/10/2013.
//  Copyright (c) 2013 Desto. All rights reserved.
//

#import "DSEC2Operation.h"
#import <AWSiOSSDK/EC2/AWSEC2.h>

#pragma mark Private Methods

@interface DSEC2Operation ()

@end

#pragma mark - Implementation

@implementation DSEC2Operation


#pragma mark Operation Configuration

- (BOOL)isRegionFree
{
    return NO;
}

// An instance of the client used to execute this operation
- (Class)clientClass
{
    return [AmazonEC2Client class];
}

- (SEL)clientSelector
{
    NSDictionary *mapping =
    @{
        @"EC2ActivateLicenseRequest":                       @"activateLicense:",
        @"EC2AllocateAddressRequest":                       @"allocateAddress:",
        @"EC2AssociateAddressRequest":                      @"associateAddress:",
        @"EC2AttachVolumeRequest":                          @"attachVolume:",
        @"EC2AuthorizeSecurityGroupIngressRequest":         @"authorizeSecurityGroupIngress:",
        @"EC2BundleInstanceRequest":                        @"bundleInstance:",
        @"EC2CancelBundleTaskRequest":                      @"cancelBundleTask:",
        @"EC2CancelConversionTaskRequest":                  @"cancelConversionTask:",
        @"EC2CancelExportTaskRequest":                      @"cancelExportTask:",
        @"EC2CancelReservedInstancesListingRequest":        @"cancelReservedInstancesListing:",
        @"EC2CancelSpotInstanceRequestsRequest":            @"cancelSpotInstanceRequests:",
        @"EC2ConfirmProductInstanceRequest":                @"confirmProductInstance:",
        @"EC2CopyImageRequest":                             @"doCopyImage:",
        @"EC2CopySnapshotRequest":                          @"doCopySnapshot:",
        @"EC2CreateImageRequest":                           @"createImage:",
        @"EC2CreateInstanceExportTaskRequest":              @"createInstanceExportTask:",
        @"EC2CreateKeyPairRequest":                         @"createKeyPair:",
        @"EC2CreatePlacementGroupRequest":                  @"createPlacementGroup:",
        @"EC2CreateReservedInstancesListingRequest":        @"createReservedInstancesListing:",
        @"EC2CreateSecurityGroupRequest":                   @"createSecurityGroup:",
        @"EC2CreateSnapshotRequest":                        @"createSnapshot:",
        @"EC2CreateSpotDatafeedSubscriptionRequest":        @"createSpotDatafeedSubscription:",
        @"EC2CreateTagsRequest":                            @"createTags:",
        @"EC2CreateVolumeRequest":                          @"createVolume:",
        @"EC2DeactivateLicenseRequest":                     @"deactivateLicense:",
        @"EC2DeleteKeyPairRequest":                         @"deleteKeyPair:",
        @"EC2DeletePlacementGroupRequest":                  @"deletePlacementGroup:",
        @"EC2DeleteSecurityGroupRequest":                   @"deleteSecurityGroup:",
        @"EC2DeleteSnapshotRequest":                        @"deleteSnapshot:",
        @"EC2DeleteSpotDatafeedSubscriptionRequest":        @"deleteSpotDatafeedSubscription:",
        @"EC2DeleteTagsRequest":                            @"deleteTags:",
        @"EC2DeleteVolumeRequest":                          @"deleteVolume:",
        @"EC2DeregisterImageRequest":                       @"deregisterImage:",
        @"EC2DescribeAccountAttributesRequest":             @"describeAccountAttributes:",
        @"EC2DescribeAddressesRequest":                     @"describeAddresses:",
        @"EC2DescribeAvailabilityZonesRequest":             @"describeAvailabilityZones:",
        @"EC2DescribeBundleTasksRequest":                   @"describeBundleTasks:",
        @"EC2DescribeConversionTasksRequest":               @"describeConversionTasks:",
        @"EC2DescribeExportTasksRequest":                   @"describeExportTasks:",
        @"EC2DescribeImageAttributeRequest":                @"describeImageAttribute:",
        @"EC2DescribeImagesRequest":                        @"describeImages:",
        @"EC2DescribeInstanceAttributeRequest":             @"describeInstanceAttribute:",
        @"EC2DescribeInstanceStatusRequest":                @"describeInstanceStatus:",
        @"EC2DescribeInstancesRequest":                     @"describeInstances:",
        @"EC2DescribeKeyPairsRequest":                      @"describeKeyPairs:",
        @"EC2DescribeLicensesRequest":                      @"describeLicenses:",
        @"EC2DescribePlacementGroupsRequest":               @"describePlacementGroups:",
        @"EC2DescribeRegionsRequest":                       @"describeRegions:",
        @"EC2DescribeReservedInstancesListingsRequest":     @"describeReservedInstancesListings:",
        @"EC2DescribeReservedInstancesOfferingsRequest":    @"describeReservedInstancesOfferings:",
        @"EC2DescribeReservedInstancesRequest":             @"describeReservedInstances:",
        @"EC2DescribeSecurityGroupsRequest":                @"describeSecurityGroups:",
        @"EC2DescribeSnapshotAttributeRequest":             @"describeSnapshotAttribute:",
        @"EC2DescribeSnapshotsRequest":                     @"describeSnapshots:",
        @"EC2DescribeSpotDatafeedSubscriptionRequest":      @"describeSpotDatafeedSubscription:",
        @"EC2DescribeSpotInstanceRequestsRequest":          @"describeSpotInstanceRequests:",
        @"EC2DescribeSpotPriceHistoryRequest":              @"describeSpotPriceHistory:",
        @"EC2DescribeSubnetsRequest":                       @"describeSubnets:",
        @"EC2DescribeTagsRequest":                          @"describeTags:",
        @"EC2DescribeVolumeAttributeRequest":               @"describeVolumeAttribute:",
        @"EC2DescribeVolumeStatusRequest":                  @"describeVolumeStatus:",
        @"EC2DescribeVolumesRequest":                       @"describeVolumes:",
        @"EC2DescribeVpcsRequest":                          @"describeVpcs:",
        @"EC2DetachVolumeRequest":                          @"detachVolume:",
        @"EC2DisassociateAddressRequest":                   @"disassociateAddress:",
        @"EC2EnableVolumeIORequest":                        @"enableVolumeIO:",
        @"EC2GetConsoleOutputRequest":                      @"getConsoleOutput:",
        @"EC2GetPasswordDataRequest":                       @"getPasswordData:",
        @"EC2ImportInstanceRequest":                        @"importInstance:",
        @"EC2ImportKeyPairRequest":                         @"importKeyPair:",
        @"EC2ImportVolumeRequest":                          @"importVolume:",
        @"EC2ModifyImageAttributeRequest":                  @"modifyImageAttribute:",
        @"EC2ModifyInstanceAttributeRequest":               @"modifyInstanceAttribute:",
        @"EC2ModifySnapshotAttributeRequest":               @"modifySnapshotAttribute:",
        @"EC2ModifyVolumeAttributeRequest":                 @"modifyVolumeAttribute:",
        @"EC2MonitorInstancesRequest":                      @"monitorInstances:",
        @"EC2PurchaseReservedInstancesOfferingRequest":     @"purchaseReservedInstancesOffering:",
        @"EC2RebootInstancesRequest":                       @"rebootInstances:",
        @"EC2RegisterImageRequest":                         @"registerImage:",
        @"EC2ReleaseAddressRequest":                        @"releaseAddress:",
        @"EC2ReportInstanceStatusRequest":                  @"reportInstanceStatus:",
        @"EC2RequestSpotInstancesRequest":                  @"requestSpotInstances:",
        @"EC2ResetImageAttributeRequest":                   @"resetImageAttribute:",
        @"EC2ResetInstanceAttributeRequest":                @"resetInstanceAttribute:",
        @"EC2ResetSnapshotAttributeRequest":                @"resetSnapshotAttribute:",
        @"EC2RevokeSecurityGroupIngressRequest":            @"revokeSecurityGroupIngress:",
        @"EC2RunInstancesRequest":                          @"runInstances:",
        @"EC2StartInstancesRequest":                        @"startInstances:",
        @"EC2StopInstancesRequest":                         @"stopInstances:",
        @"EC2TerminateInstancesRequest":                    @"terminateInstances:",
        @"EC2UnmonitorInstancesRequest":                    @"unmonitorInstances:",
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

#pragma mark - Wait Operations

// Wait for the instance to be available
+ (DSEC2Operation *)waitOperationUntilInstanceRunning:(EC2Instance *)instance owner:(id)owner completion:(DSAWSOperationCompletionBlock)completion
{
    // Create the request
    EC2DescribeInstancesRequest *request = [[EC2DescribeInstancesRequest alloc] init];
    [request addInstanceId:instance.instanceId];

    return [DSEC2Operation waitOperationWithRequest:request
                                              owner:owner
                                       untilKeyPath:@"reservations.@unionOfObjects.instances.@unionOfObjects.state.name"
                                            inArray:@[ @"running", @"stopping", @"shutting-down", @"terminated", @"stopped" ]
                                         completion:completion];
}

// Wait for the instance to be stopped
+ (DSEC2Operation *)waitOperationUntilInstanceStopped:(EC2Instance *)instance owner:(id)owner completion:(DSAWSOperationCompletionBlock)completion
{
    // Create the request
    EC2DescribeInstancesRequest *request = [[EC2DescribeInstancesRequest alloc] init];
    [request addInstanceId:instance.instanceId];
    
    return [DSEC2Operation waitOperationWithRequest:request
                                              owner:owner
                                       untilKeyPath:@"reservations.@unionOfObjects.instances.@unionOfObjects.state.name"
                                            inArray:@[ @"stopped", @"pending", @"shutting-down", @"terminated" ]
                                         completion:completion];
}

// Wait for the instance to be terminated
+ (DSEC2Operation *)waitOperationUntilInstanceTerminated:(EC2Instance *)instance owner:(id)owner completion:(DSAWSOperationCompletionBlock)completion
{
    // Create the request
    EC2DescribeInstancesRequest *request = [[EC2DescribeInstancesRequest alloc] init];
    [request addInstanceId:instance.instanceId];
    
    return [DSEC2Operation waitOperationWithRequest:request
                                              owner:owner
                                       untilKeyPath:@"reservations.@unionOfObjects.instances.@unionOfObjects.state.name"
                                            inArray:@[ @"stopped", @"pending", @"terminated" ]
                                         completion:completion];
}


@end
