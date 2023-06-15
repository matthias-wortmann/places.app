//
//  InformationViewController.swift
//  Places
//
//  Created by Matthias Wortmann on 14.02.16.
//  Copyright © 2016 Matthias Wortmann. All rights reserved.
//

import UIKit


class InformationViewController: UIViewController {
    
    @IBAction func onChancel(sender: AnyObject) {
        dismissViewControllerAnimated(true,
            completion: nil)

    }
    
    @IBAction func deleteAllPlaces(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("locationArray")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let alert = SCLAlertView()
        alert.showWarning(kNoticeTitle, subTitle: "Heimat ist der Duft unserer Erinnerungen.")
    }
    
    
    
    

}
