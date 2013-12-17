//
//  DSELBOperation.m
//  Kestrel
//
//  Created by Rob Amos on 11/12/2013.
//  Copyright (c) 2013 Desto. All rights reserved.
//

#import "DSELBOperation.h"
#import <AWSElasticLoadBalancing/AWSElasticLoadBalancing.h>

#pragma mark Private Methods

@interface DSELBOperation ()

@end

#pragma mark - Implementation

@implementation DSELBOperation

#pragma mark Operation Configuration

- (BOOL)isRegionFree
{
    return NO;
}

// An instance of the client used to execute this operation
- (Class)clientClass
{
    return [AmazonElasticLoadBalancingClient class];
}

- (SEL)clientSelector
{
    NSDictionary *mapping =
    @{
        @"ElasticLoadBalancingApplySecurityGroupsToLoadBalancerRequest":          @"applySecurityGroupsToLoadBalancer:",
        @"ElasticLoadBalancingAttachLoadBalancerToSubnetsRequest":                @"attachLoadBalancerToSubnets:",
        @"ElasticLoadBalancingConfigureHealthCheckRequest":                       @"– describeLoadBalancerPolicyTypes:",
        @"ElasticLoadBalancingCreateAppCookieStickinessPolicyRequest":            @"createAppCookieStickinessPolicy:",
        @"ElasticLoadBalancingCreateLBCookieStickinessPolicyRequest":             @"createLBCookieStickinessPolicy:",
        @"ElasticLoadBalancingCreateLoadBalancerListenersRequest":                @"createLoadBalancerListeners:",
        @"ElasticLoadBalancingCreateLoadBalancerPolicyRequest":                   @"createLoadBalancerPolicy:",
        @"ElasticLoadBalancingCreateLoadBalancerRequest":                         @"createLoadBalancer:",
        @"ElasticLoadBalancingDeleteLoadBalancerListenersRequest":                @"deleteLoadBalancerListeners:",
        @"ElasticLoadBalancingDeleteLoadBalancerPolicyRequest":                   @"deleteLoadBalancerPolicy:",
        @"ElasticLoadBalancingDeleteLoadBalancerRequest":                         @"deleteLoadBalancer:",
        @"ElasticLoadBalancingDeregisterInstancesFromLoadBalancerRequest":        @"deregisterInstancesFromLoadBalancer:",
        @"ElasticLoadBalancingDescribeInstanceHealthRequest":                     @"describeInstanceHealth:",
        @"ElasticLoadBalancingDescribeLoadBalancerPoliciesRequest":               @"describeLoadBalancerPolicies:",
        @"ElasticLoadBalancingDescribeLoadBalancerPolicyTypesRequest":            @"describeLoadBalancerPolicyTypes:",
        @"ElasticLoadBalancingDescribeLoadBalancersRequest":                      @"describeLoadBalancers:",
        @"ElasticLoadBalancingDetachLoadBalancerFromSubnetsRequest":              @"detachLoadBalancerFromSubnets:",
        @"ElasticLoadBalancingDisableAvailabilityZonesForLoadBalancerRequest":    @"disableAvailabilityZonesForLoadBalancer:",
        @"ElasticLoadBalancingEnableAvailabilityZonesForLoadBalancerRequest":     @"enableAvailabilityZonesForLoadBalancer:",
        @"ElasticLoadBalancingRegisterInstancesWithLoadBalancerRequest":          @"registerInstancesWithLoadBalancer",
        @"ElasticLoadBalancingSetLoadBalancerListenerSSLCertificateRequest":      @"setLoadBalancerListenerSSLCertificate",
        @"ElasticLoadBalancingSetLoadBalancerPoliciesForBackendServerRequest":    @"setLoadBalancerPoliciesForBackendServer:",
        @"ElasticLoadBalancingSetLoadBalancerPoliciesOfListenerRequest":          @"setLoadBalancerPoliciesOfListener:"
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