//
//  InterfaceController.m
//  WTBank ObjC Watch App Extension
//
//  Created by Blake Clough on 1/26/16.
//  Copyright © 2016 Webtrends. All rights reserved.
//

#import "InterfaceController.h"
#import "WebtrendsWatchSDK.h"


@interface InterfaceController()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *balanceLabel;
@property (nonatomic) NSInteger balance;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    
    self.balance = 100;
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}
- (IBAction)refreshBalance {
    self.balance++;
    [self.balanceLabel setText:[NSString stringWithFormat:@"$%@", @(self.balance)]];
    
    WTWatchEventMeta *meta = [WTWatchEventMeta eventMetaForPath:@"/WatchAppBalance" description:@"InterfaceController" type:@"Tap" customParams:nil];
    [[WTWatchDataCollector sharedCollector] sendEventForAction:meta];
    
}

@end



