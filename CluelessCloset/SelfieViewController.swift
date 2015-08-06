//
//  SelfieViewController.swift
//  CluelessCloset
//
//  Created by Sonova Middleton on 8/4/15.
//  Copyright (c) 2015 supernova8productions. All rights reserved.
//

import UIKit
import CoreData


class SelfieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedObjectContext:NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var looksArray = [Looks]()

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
        newLook.lookSeason = 0 as Int
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

    func fetchLooks(SearchText: String) -> [Looks] {
        println("Fetch")
        let fetchRequest :NSFetchRequest = NSFetchRequest(entityName: "Looks")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lookNumber", ascending: true), NSSortDescriptor(key: "lookName", ascending:true)]
        
        return managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as! [Looks]
        
    }
   
    //MARK: - TableView Methods
    
    //Sections
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
        
    }// this lets it know its sections
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("Count: %lu", looksArray.count)

        if section == 0 {
            return looksArray.count
        }
        if section == 1 {
            return looksArray.count
            
        }
        if section == 2 {
            return looksArray.count
            
        }
        return 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Photo"
        }
        if section == 1 {
            return "Info"
        }
        if section == 2 {
            return "Details"
        }
        return "Unknown"
    }
    
//    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        if section == 0 {
//            return "\(metroStationsArray.count) Stations"
//        }
//        if section == 1 {
//            return "\(bikeStationsArray.count) Stations"
//        }
//        return "Unknown"
//    }
    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
//        
//        if indexPath.section == 0 {
//            cell.textLabel!.text = metroStationsArray[indexPath.row]
//            
//        } else if indexPath.section == 1 {
//            cell.textLabel!.text = bikeStationsArray[indexPath.row]
//        }
//        
//        return cell
//        
//    }

    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        if indexPath.section == 0 {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:"cell")
            let currentLook = looksArray[indexPath.row]
            cell.textLabel!.text = currentLook.lookName
            
            var totalDates = 0
            let dateWornSet = currentLook.relationshipLookLookDates
            
            for dateWorn in dateWornSet {
                totalDates++
            }
            

            cell.detailTextLabel!.text = "\(totalDates)"
        
        } else if indexPath.section == 1 {
    
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:"cell")
            let currentLook = looksArray[indexPath.row]
            cell.textLabel!.text = currentLook.lookName
            
            var totalDates = 0
            let dateWornSet = currentLook.relationshipLookLookDates
            
            for dateWorn in dateWornSet {
            totalDates++
            }
        }
    
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //performSegueWithIdentifier("editToDetailSegue", sender: self)
        
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
