//
//  CLosetViewController.swift
//  CluelessCloset
//
//  Created by Sonova Middleton on 8/4/15.
//  Copyright (c) 2015 supernova8productions. All rights reserved.
//

import UIKit
import CoreData

class ClosetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedObjectContext:NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var looksArray = [Looks]()
    
    @IBOutlet var lookSearchBar :UISearchBar!
    @IBOutlet var looksTableView :UITableView!
    
    //MARK: - Core Methods
    
    func tempAddRecords() {
        
        
        println("Add!")
        
        let entityDescription : NSEntityDescription! = NSEntityDescription.entityForName("Looks", inManagedObjectContext: managedObjectContext)
        let entityDescription2 : NSEntityDescription! = NSEntityDescription.entityForName("LookDates", inManagedObjectContext: managedObjectContext)
        
        var newLook = Looks(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
        var newLookDate = LookDates(entity: entityDescription2, insertIntoManagedObjectContext: managedObjectContext)
        var newLookDate2 = LookDates(entity: entityDescription2, insertIntoManagedObjectContext: managedObjectContext)
        
        //Record 1
        newLook.lookName = "Country Chic"
        newLook.lookNumber = 1 as Int
        newLook.lookSeason = "Summer"
        newLook.lookFave = false
        newLook.dateAdded = NSDate()
        newLook.dateUpdated = NSDate()
        
        newLookDate.dateWorn = NSDate()
        newLookDate.dateUpdated = NSDate()
        newLookDate.dateAdded = NSDate()
        
        newLookDate2.dateWorn = NSDate()
        newLookDate2.dateUpdated = NSDate()
        newLookDate2.dateAdded = NSDate()
        
        newLookDate.relationshipLookDateLook = newLook
        newLookDate2.relationshipLookDateLook = newLook
        
        
        //        //Record 2
        //        var newLook1 = Looks(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
        //
        //        newLook1.lookName = "Read Email"
        //        newLook1.lookNumber = 2 as Int
        //
        //        newLook1.lookSeason = 0 as Int
        //        newLook1.lookFave = false
        //
        ////        newLook1.dateEntered = NSDate()
        ////        newLook1.dateUpdated = NSDate()
        ////        newLook1.lookDateCompleted = NSDate()
        ////
        //        //Record 3
        //        var newLook2 = Looks(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
        //
        //        newLook2.lookName = "Pay Bills"
        //        newLook2.lookNumber = 3 as Int
        //
        //        newLook2.lookSeason = 0 as Int
        //        newLook2.lookFave = false
        //
        ////        newLook2.dateEntered = NSDate()
        ////        newLook2.dateUpdated = NSDate()
        ////        newLook2.lookDateCompleted = NSDate()
        ////
        //        //Record 4
        //        var newLook3 = Looks(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
        //
        //        newLook3.lookName = "Cook Dinner"
        //        newLook3.lookNumber = 4 as Int
        //
        //        newLook3.lookSeason = 0 as Int
        //        newLook3.lookFave = false
        //
        ////        newLook3.dateEntered = NSDate()
        ////        newLook3.dateUpdated = NSDate()
        ////        newLook3.lookDateCompleted = NSDate()
        ////
        
        appDelegate.saveContext()
        
        
        
    }
    
    @IBAction func searchBarSearchButtonClicked(sender: UISearchBar) {
        
        sender.resignFirstResponder()
        var searchStringPlus = lookSearchBar.text
        
        
        //searchStringPlus = searchStringPlus.stringByReplacingOccurrencesOfString(" ", withString: "+")
        
        println("Search For This: \(searchStringPlus)")
        
        looksArray = fetchLooks(searchStringPlus)
    }
    
    func fetchLooks(SearchText: String) -> [Looks] {
        println("Fetch")
        let fetchRequest :NSFetchRequest = NSFetchRequest(entityName: "Looks")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lookNumber", ascending: true), NSSortDescriptor(key: "lookName", ascending:true)]
        
        return managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as! [Looks]
        
    }
    
    //MARK: - TableView Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("Count: %lu", looksArray.count)
        return looksArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:"cell")
        let currentLook = looksArray[indexPath.row]
        cell.textLabel!.text = currentLook.lookName
        
        var totalDates = 0
        let dateWornSet = currentLook.relationshipLookLookDates
        
        for dateWorn in dateWornSet {
            totalDates++
        }
        
        
        cell.detailTextLabel!.text = "\(totalDates)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("editToDetailSegue", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destController = segue.destinationViewController as! DetailViewController
        
        //var x = 1 as Float // same as this
        if segue.identifier == "editToDetailSegue" {
            
            let indexPath = looksTableView.indexPathForSelectedRow()
            if let unwrappedIndexPath = indexPath {
                let currentLook = looksArray[unwrappedIndexPath.row]
                destController.selectedLook = currentLook
                looksTableView.deselectRowAtIndexPath(unwrappedIndexPath, animated: true)
                // need this in other apps ^
                
            }
        }
        
        if segue.identifier == "addToDetailSegue" {
            destController.selectedLook = nil
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext:NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        looksTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //self.tempAddRecords()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        looksArray = fetchLooks("")
        looksTableView.reloadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
