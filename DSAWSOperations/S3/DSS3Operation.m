//
//  DSS3Operation.m
//  Kestrel
//
//  Created by Rob Amos on 16/12/2013.
//  Copyright (c) 2013 Desto. All rights reserved.
//

#import "DSS3Operation.h"
#import <AWSS3/AWSS3.h>

#pragma mark Private Methods

@interface DSS3Operation ()

@end

#pragma mark - Implementation

@implementation DSS3Operation

#pragma mark Operation Configuration

- (BOOL)isRegionFree
{
    return NO;
}

// An instance of the client used to execute this operation
- (Class)clientClass
{
    return [AmazonS3Client class];
}

- (SEL)clientSelector
{
    NSDictionary *mapping =
    @{
        @"S3AbortMultipartUploadRequest":               @"abortMultipartUpload:",
        @"S3CompleteMultipartUploadRequest":            @"completeMultipartUpload:",
        @"S3CopyObjectRequest":                         @"objectCopy:",
        @"S3CopyPartRequest":                           @"partCopy:",
        @"S3CreateBucketRequest":                       @"createBucket:",
        @"S3DeleteBucketCrossOriginRequest":            @"deleteBucketCrossOrigin:",
        @"S3DeleteBucketLifecycleConfigurationRequest": @"deleteBucketLifecycleConfiguration:",
        @"S3DeleteBucketPolicyRequest":                 @"deleteBucketPolicy:",
        @"S3DeleteBucketRequest":                       @"deleteBucket:",
        @"S3DeleteBucketTaggingRequest":                @"deleteBucketTagging:",
        @"S3DeleteBucketWebsiteConfigurationRequest":   @"deleteBucketWebsiteConfiguration:",
        @"S3DeleteObjectRequest":                       @"deleteObject:",
        @"S3DeleteObjectsRequest":                      @"deleteObjects:",
        @"S3DeleteVersionRequest":                      @"deleteVersion:",
        @"S3GetACLRequest":                             @"getACL:",
        @"S3GetBucketCrossOriginRequest":               @"getBucketCrossOrigin:",
        @"S3GetBucketLifecycleConfigurationRequest":    @"getBucketLifecycleConfiguration:",
        @"S3GetBucketPolicyRequest":                    @"getBucketPolicy:",
        @"S3GetBucketTaggingRequest":                   @"getBucketTagging:",
        @"S3GetBucketVersioningConfigurationRequest":   @"getBucketVersioningConfiguration:",
        @"S3GetBucketWebsiteConfigurationRequest":      @"getBucketWebsiteConfiguration:",
        @"S3GetObjectMetadataRequest":                  @"getObjectMetadata:",
        @"S3GetObjectRequest":                          @"getObject:",
        @"S3GetPreSignedURLRequest":                    @"getPreSignedURL:",
        @"S3InitiateMultipartUploadRequest":            @"initiateMultipartUpload:",
        @"S3ListBucketsRequest":                        @"listBuckets:",
        @"S3ListMultipartUploadsRequest":               @"listMultipartUploads:",
        @"S3ListObjectsRequest":                        @"listObjects:",
        @"S3ListPartsRequest":                          @"listParts:",
        @"S3ListVersionsRequest":                       @"listVersions:",
        @"S3PutObjectRequest":                          @"putObject:",
        @"S3RestoreObjectRequest":                      @"restoreObject:",
        @"S3SetACLRequest":                             @"setACL:",
        @"S3SetBucketCrossOriginRequest":               @"setBucketCrossOrigin:",
        @"S3SetBucketLifecycleConfigurationRequest":    @"setBucketLifecycleConfiguration:",
        @"S3SetBucketPolicyRequest":                    @"setBucketPolicy:",
        @"S3SetBucketTaggingRequest":                   @"setBucketTagging:",
        @"S3SetBucketVersioningConfigurationRequest":   @"setBucketVersioningConfiguration:",
        @"S3SetBucketWebsiteConfigurationRequest":      @"setBucketWebsiteConfiguration:",
        @"S3UploadPartRequest":                         @"uploadPart:"
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