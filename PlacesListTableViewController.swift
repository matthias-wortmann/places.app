//
//  PlacesListTableViewController.swift
//  Places
//
//  Created by Matthias Wortmann on 30.06.16.
//  Copyright © 2016 Matthias Wortmann. All rights reserved.
//

import UIKit
import CoreData

class PlacesListTableViewController: UITableViewController  {
    
    var stores = [Store]()
    let moContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
    let sortKeyName   = "storeName"
    let wbSortKey     = "wbSortKey"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        
        self.tableView.dataSource = self // added to make the Table view work
        self.tableView.delegate = self // added to make the Table view work

    }
    override func viewWillAppear(animated: Bool) {
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "PlacesListBackground.png")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        
        let ed = NSEntityDescription.entityForName("Store", inManagedObjectContext: moContext)
        let req = NSFetchRequest()
        req.entity = ed
        
        do
        {
            
            stores = try moContext.executeFetchRequest(req) as! [Store]
            
            if stores.count > 0
            {
                self.tableView.reloadData()
            } else
            {
                let alert = SCLAlertView()
                alert.showError("Keine Places", subTitle: "Du hast noch keine Places gespeichert.")
            }
        } catch let error as NSError
        {
            let alert = SCLAlertView()
            alert.showError("Nein", subTitle: "Etwas ist schief gelaufen")
        }
}
    override func viewDidAppear(animated: Bool) {
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.BlackOpaque
        nav?.tintColor = UIColor.clearColor()
            }
  
    @IBAction func chancelView(sender: AnyObject) {
        dismissViewControllerAnimated(true,
                                      completion: nil)
        
        
    }
    
    @IBAction func filterPlaces(sender: AnyObject) {
        
         NSUserDefaults.standardUserDefaults().setObject(sortKeyName, forKey: wbSortKey)
        self.tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stores.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        
        cell.layoutMargins = UIEdgeInsetsZero
        let s = stores [indexPath.row]
        cell.textLabel?.text = s.storeName
        cell.contentView.backgroundColor = UIColor.clearColor()
        
        let whiteRoundedView : UIView = UIView(frame: CGRectMake(10, 8, self.view.frame.size.width - 20, 149))
        
        whiteRoundedView.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1.0, 1.0, 1.0, 1.0])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSizeMake(-1, 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        switch editingStyle {
        case .Delete:
        // remove the deleted item from the model
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        context.deleteObject(stores[indexPath.row] )
        stores.removeAtIndex(indexPath.row)
        do {
            try context.save()
        } catch _ {
        }
        
        // remove the deleted item from the `UITableView`
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        default:
        return
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?
    {
        
        var shareAction = UITableViewRowAction(style: .Normal, title: "Share") { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            let firstActivityItem = self.stores[indexPath.row]
            
            let activityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
            
            self.presentViewController(activityViewController, animated: true, completion: nil)
            
            
        }
        
        shareAction.backgroundColor = UIColor.blueColor()
        
        return [shareAction]
        
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "editStore"
        {
            let v = segue.destinationViewController as! StartViewController
            
            let indexpath = self.tableView.indexPathForSelectedRow
            let row = indexpath?.row
            
            v.store = stores[row!]
            
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    


}