//
//  WTOptimizeWebViewDelegate.h
//  Webtrends-SDK
//
//  Created by Blake Clough on 1/6/16.
//  Copyright © 2016 Webtrends. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTOptimizeWebViewDelegate : NSObject

+ (BOOL)shouldStartLoadWithRequest:(NSURLRequest *)request;

@end
