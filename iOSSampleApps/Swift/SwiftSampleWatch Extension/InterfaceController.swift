//
//  InterfaceController.swift
//  SwiftSampleWatch Extension
//
//  Created by Blake Clough on 1/18/16.
//  Copyright © 2016 Webtrends. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    @IBOutlet weak var balanceLabel: WKInterfaceLabel!
    var balance = 100

    @IBAction func refreshBalance() {
        balance++
        balanceLabel.setText("$\(balance)")
        let meta = WTWatchEventMeta(eventPath: nil, description: "InterfaceController", type: "tap", customParams: nil)
        WTWatchDataCollector.sharedCollector().sendEventForAction(meta)
        
    }


}
