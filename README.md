# Desto AWS Operation Queue

This is small framework designed to take some of the pain out of using the AWS IOS SDK, which can get very verbose and is synchronous out of the box.

## Example

Out of the box, listing the EC2 instances in a region might look something like this:

```objc
EC2DescribeInstancesRequest *request = [[EC2DescribeInstancesRequest alloc] init];
AmazonEC2Client *client = [[AmazonEC2Client alloc] initWithAccessKey:@"" withSecretKey:@""];

EC2DescribeInstancesResponse *response = [client describeInstances:request];
NSLog(@"%@", response);
```

This all happens synchronously, so your thread is blocked while awaiting the response from Amazon. You also need to do your own exception handling every time.

The Desto AWS Operation Queue lets you replace all that with this:

```objc
EC2DescribeInstancesRequest *request = [[EC2DescribeInstancesRequest alloc] init];
DSEC2Operation *op = [DSEC2Operation operationWithRequest:request owner:self completion:^(id response, NSException *exception) {
	NSLog(@"%@", response);
}];
[[DSAWSOperationQueue sharedInstance] addOperation:op];
```

The NSOperationQueue subclass will execute the operation automatically and call your provided completion block with the results or the exception, it also determines the AWS client class and selector to use automatically.

Because it is an NSOperationQueue subclass, you can pause or control the execution of operations as you normally would.

## Waiters

Additionally, some of the other AWS SDKs support the concept of a waiter. A waiter will regularly poll the AWS APIs until the requested condition has been met. You can use a waiter, for example, to wait until a pending instance has finished starting.

The Operation can decide to continue waiting in the background based on a provided block, or by a key path matching a provided value.

For convenience, some waiters come built in:

```
DSEC2Operation *op = [DSEC2Operation waitOperationUntilInstanceRunning:someInstance owner:self completion:^(id response, NSException *exception) {
	// ...
}];
[[DSAWSOperationQueue sharedInstance] addOperation:op];
```

Others can be easily built based on the key path of the returned objects.

```
EC2DescribeImagesRequest *request = [[EC2DescribeImagesRequest alloc] init];
[request addImageId:i.imageId];
DSEC2Operation *op = [DSEC2Operation waitOperationWithRequest:request
                                                        owner:blockSelf
                                                 untilKeyPath:@"images.@unionOfObjects.state"
                                                      inArray:permanentStates
                                                   completion:^(id response, NSException *exception)
{
	// ...
}];
[queue addOperation:op];
```

## System Requirements

Tested under iOS 6+ with the AWS IOS SDK 1.7+

## Installation

1. Install the latest AWS IOS SDK.
2. Clone the project or install via your preferred method.
3. #import "DSAWSOperations.h"
4. Setup an authentication provider.
5. You will still need to import the appropriate AWS framework when you want to use it.

## Authentication

By default, the DSAWSOperation objects will request credentials and region information from the delegate assigned to the queue. You will therefore want to create an authentication provider for this information, or create your own subclass to provide credentials (see DSEC2DescribeRegionsOperation for an example of this).

Creating your own provider is easy:

### YourAuthenticationProvider.h
```objc
#import <Foundation/Foundation.h>
#import "DSAWSOperationAuthenticationDelegate.h"

@interface DSAWSOperationAuthenticationProvider : NSObject <DSAWSOperationAuthenticationDelegate>

@end
```

### YourAuthenticationProvider.m

```objc
#import "YourAuthenticationProvider.h"
#import <AWSRuntime/AWSRuntime.h>
#import "DSRegion.h"

@implementation DSAWSOperationAuthenticationProvider

- (AmazonCredentials *)amazonCredentialsForOperation:(DSAWSOperation *)op
{
    return [[AmazonCredentials alloc] initWithAccessKey:@"xxx" withSecretKey:@"yyy"];
}

- (DSRegion *)regionForOperation:(DSAWSOperation *)op
{
    return [DSRegion regionForAmazonRegion:AP_SOUTHEAST_2];
}

@end
```

You can customise the responses as required.

Then before you use the queue for the first time:

```objc
[[DSAWSOperationQueue sharedInstance] setDelegate:[[YourAuthenticationProvider alloc] init]];
```