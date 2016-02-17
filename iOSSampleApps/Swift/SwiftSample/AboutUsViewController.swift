//
//  AboutUsViewController.swift
//  SwiftSample
//
//  Created by Blake Clough on 1/12/16.
//  Copyright © 2016 Webtrends. All rights reserved.
//

import Foundation

class AboutUsViewController: UIViewController {
    
    @IBAction func sendConversion(sender: AnyObject) {
        let manager = WTOptimizeManager.sharedManager()
        manager.triggerEventForConversionWithTestAlias("ta_WT", projectLocation: "WTBankSample.app/persistent", conversionPoint: "cp_clickedconvertbutton")
    }

    
    @IBAction func greet(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Send Message", message: "Send a message to the Optimize server", preferredStyle: .ActionSheet)
        let action = UIAlertAction(title: "Personalized Greeting", style: .Default) { (_action) -> Void in
            // Send an in-the-moment request to the Optimize server
            self.fetchTestWithData(["greeting":"personal"])
        }
        let action2 = UIAlertAction(title: "Generic Greeting", style: .Default) { (_action) -> Void in
            // Send an in-the-moment request to the Optimize server
            self.fetchTestWithData(["greeting":"generic"])
            
        }
        let defaultAction = UIAlertAction(title: "Default Greeting", style: .Default) { (_action) -> Void in
            // Send an in-the-moment request to the Optimize server
            self.fetchTestWithData(nil)
        }


        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler:nil)
        alert.addAction(action)
        alert.addAction(action2)
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)

        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func fetchTestWithData(data: [String: String]?) {

        // Since fetching the test from the server will take a while, we want to present a spinner to the user.
        let overlay = UIView(frame: UIScreen.mainScreen().bounds)
        overlay.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        self.view.window?.addSubview(overlay)
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        spinner.center = overlay.center
        spinner.hidesWhenStopped = false
        overlay.addSubview(spinner)
        spinner.startAnimating()
        
        // fetchTestLocation is a blocking method that makes a network call to the Optimize server.
        // data is a dictionary of String:String and will contain "greeting":"personal" or "greeting":"generic" or nil
        WTOptimizeManager.sharedManager().fetchTestLocation("WTBankSample.app/customDataTest", customData: data, completion: { (tests, error) -> Void in
            overlay.removeFromSuperview()
            
            // Set up a default greeting
            var greeting = "No Greeting Returned from Server"
            
            // Create a test factor for the ID_messageText UI element (pre-defined in Optimize server)
            if let factor = tests?.first?.factorForIdentifier("ID_messageText") as? WTMultivariateOptimizeFactor {
                greeting = factor.text
            }
            
            // Display the greeting returned from the Optimize server
            let alert = UIAlertController(title: "Greetings!", message: greeting, preferredStyle: .Alert)
            let ok = UIAlertAction(title: "OK", style: .Cancel, handler:nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    override func viewDidLoad() {
        let manager = WTOptimizeManager.sharedManager()
        manager.triggerPageView(self, withTestAlias: "ta_WT", projectLocation: "WTBankSample.app/persistent")
        if let factor = manager.optimizeFactorForIdentifier("$wt_m_ID_switchValue_0") as? WTSwitchingOptimizeFactor {
            switch factor.selectedOption {
            case 1:
                // turn background color beige
                self.view.backgroundColor = UIColor(red:0.95, green:0.92, blue:0.86, alpha:1.0)
            case 2:
                // turn background color light blue
                self.view.backgroundColor = UIColor(red:0.69, green:0.85, blue:0.90, alpha:1.0)
            default:
                self.view.backgroundColor = UIColor.whiteColor()
            }
        }
    }
}