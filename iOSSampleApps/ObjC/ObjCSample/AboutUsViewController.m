//
//  AboutUsViewController.m
//  ObjCSample
//
//  Created by Blake Clough on 1/26/16.
//  Copyright © 2016 Webtrends. All rights reserved.
//

#import "AboutUsViewController.h"
#import "OptimizeSDK.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WTOptimizeManager *manager = [WTOptimizeManager sharedManager];
    [manager triggerPageView:self withTestAlias:@"ta_Optimize" projectLocation:@"WTBankSample.app/persistent"];
    WTSwitchingOptimizeFactor *factor = (WTSwitchingOptimizeFactor *) [manager optimizeFactorForIdentifier:@"$wt_m_ID_switchValue_0"];
    switch (factor.selectedOption) {
        case 1:
            // Turn the background color to beige.
            self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.92 blue:0.86 alpha:1.0];
            break;
        case 2:
            // Turn the background color to light blue.
            self.view.backgroundColor = [UIColor colorWithRed:0.69 green:0.85 blue:0.90 alpha:1.0];
            break;
            
        default:
            // Otherwise, turn the background white
            self.view.backgroundColor = [UIColor whiteColor];
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)sendConversion:(id)sender {
    WTOptimizeManager *manager = [WTOptimizeManager sharedManager];
    [manager triggerEventForConversionWithTestAlias:@"ta_Optimize" projectLocation:@"WTBankSample.app/persistent" conversionPoint:@"cp_clickedConvertButton"];
}
- (IBAction)greet:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Send Message" message:@"Send a message to the Optimize server" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Personalized Greeting" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // Send an in-the-moment request to the Optimize server
        [self fetchTestWithData:@{@"greeting":@"personal"}];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Generic Greeting" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // Send an in-the-moment request to the Optimize server
        [self fetchTestWithData:@{@"greeting":@"generic"}];
    }];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Default Greeting" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // Send an in-the-moment request to the Optimize server
        [self fetchTestWithData:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [alert addAction:action2];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void) fetchTestWithData:(NSDictionary *)data
{
    UIView *overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    overlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.view.window addSubview:overlay];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = overlay.center;
    spinner.hidesWhenStopped = NO;
    [overlay addSubview:spinner];
    [spinner startAnimating];
    
    [[WTOptimizeManager sharedManager] fetchTestLocation:@"WTBankSample.app/customDataTest" customData:data completion:^(NSArray<WTOptimizeTest *> * _Nullable tests, NSError * _Nullable error) {
        [overlay removeFromSuperview];
        NSString *greeting = @"No Greeting Returned from Server";
        WTMultivariateOptimizeFactor *factor = (WTMultivariateOptimizeFactor *) [tests.firstObject factorForIdentifier:@"ID_messageText"];
        if (factor) {
            greeting = factor.text;
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Greetings!" message:greeting preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
}
@end
