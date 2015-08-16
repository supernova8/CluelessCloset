//
//  SecondViewController.swift
//  CluelessCloset
//
//  Created by Sonova Middleton on 8/4/15.
//  Copyright (c) 2015 supernova8productions. All rights reserved.
//

import UIKit
import CoreData


class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UITableViewDelegate, UITableViewDataSource {

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedObjectContext:NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    //var looksArray = [Looks]()
    var lookDatesArray = [LookDates]()
    //var deleteLookIndexPath: NSIndexPath? = nil
    //var lookToFaveIndexPath: NSIndexPath? = nil
    
    //@IBOutlet var lookSearchBar :UISearchBar!
    @IBOutlet var looksTableView :UITableView!
    @IBOutlet private var editBarButtonItem :UIBarButtonItem!
    
    @IBOutlet private weak var lookCalendar: FSCalendar!
    
    
    //MARK: - Calendar Methods
    
    
    // FSCalendarDataSource
//    func calendar(calendar: FSCalendar!, subtitleForDate date: NSDate!) -> String! {
//        
//        var yourSubtitle = "N"
//        
//        return yourSubtitle
//    }
    
    // FSCalendarDataSource
    func calendar(calendar: FSCalendar!, hasEventForDate date: NSDate!) -> Bool {
        
        var eventArray = searchDate(date)
        
        var shouldShowEventDot = false
        
        if eventArray.count > 0 {
            
            shouldShowEventDot = true
            
        }
        
        return shouldShowEventDot
    }
    
    // FSCalendarDataSource
//    func calendar(calendar: FSCalendar!, imageForDate date: NSDate!) -> UIImage! {
//        return anyImage
//    }
//    
    func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
        
        println("This date: \(date)")
        lookDatesArray = searchDate(date)
        looksTableView.reloadData()
        
    }

    
    //MARK: - Core Methods
    
    func searchDate(searchDate: NSDate) -> [LookDates] {
        var components = NSDateComponents()
        components.day = 1
        let cal = NSCalendar.currentCalendar()
        let searchDateEnd = cal.dateByAddingComponents(components, toDate: searchDate, options: nil)
        let fetchRequest :NSFetchRequest = NSFetchRequest(entityName: "LookDates")
        let predicate = NSPredicate(format: "%@ <= dateWorn and dateWorn <= %@", searchDate, searchDateEnd!)
        fetchRequest.predicate = predicate
        return managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as! [LookDates]
        
    }
    
    //MARK: - Interactivity Methods
    
    func getDocumentPathForFile(filename: String) -> String {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        //NSTemporaryDirectory() // temp directory
        return  documentsPath.stringByAppendingPathComponent(filename)
        
        
    }
    @IBAction func faveButtonTapped(sender: AnyObject) {
        println("Fave Button Tapped")
        
        
        //        let currentLookDate = lookDatesArray[indexPath.row]
        //
        //        let currentLook = currentLookDate.relationshipLookDateLook
        //
        //        println("\(currentLookDate)")
        //          println("\(currentLook)")
        //
        //        for matchLookDate in currentLook.relationshipLookLookDates {
        //
        //            if currentLookDate.dateWorn == matchLookDate.dateWorn {
        //                println("DAte Match")
        //            }
        //        }

        
        let textFieldPosition = sender.convertPoint(CGPointZero, toView: looksTableView)
        if let indexPath = looksTableView.indexPathForRowAtPoint(textFieldPosition) {
            
           
            println("Look To Fave")
            
            looksTableView.beginUpdates()
            
            let lookDateToFave = lookDatesArray[indexPath.row]
            
            let lookToFave = lookDateToFave.relationshipLookDateLook
            
            if lookToFave.lookFave == false {
                lookToFave.lookFave = true
            } else if lookToFave.lookFave == true {
                lookToFave.lookFave = false
            }
            
            appDelegate.saveContext()
            looksTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            
            looksTableView.endUpdates()
        }
        
    }

    
    
    //MARK: - TableView Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("Count: \(lookDatesArray.count)")
        return lookDatesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        //cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:"cell")
        
        var cell = tableView.dequeueReusableCellWithIdentifier("calendarLookCell") as! CalendarLookTableViewCell
        
        let currentLookDate = lookDatesArray[indexPath.row]
        
        let currentLook = currentLookDate.relationshipLookDateLook
        
        println("\(currentLookDate))")
        
//        var formatter = NSDateFormatter()
//        formatter.dateFormat = "MMMM d, yyyy"
        
        //lastWornDateLabel.text = "\(formatter.stringFromDate(lastLookDate.dateWorn))"
//        var timesWorn = "\(dateWornSet.count)"
        
        //println("\(formatter.stringFromDate(currentLookDate.dateWorn))")
        //println("\(currentLookDate.dateOccasion)")

//        cell.textLabel!.text = "Date"
  //      cell.detailTextLabel!.text = "Occasion"

//        cell.textLabel!.text = "Look No. \(currentLook.lookNumber)"
//        cell.detailTextLabel!.text = "\(currentLookDate.dateOccasion)"
//
        
        //here
        
        cell.lookNumberLabel!.text = "Look No. \(currentLook.lookNumber)"
        
        cell.lookNameLabel!.text = currentLook.lookName
        cell.occasionLabel!.text = "\(currentLookDate.dateOccasion)"
        
        
        let dateWornSet = currentLook.relationshipLookLookDates
//        var sortDescriptor = NSSortDescriptor(key: "dateWorn", ascending: false)
//        var dateWornSortedArray = dateWornSet.sortedArrayUsingDescriptors([sortDescriptor])
//        
//        var lastLookDate = dateWornSortedArray.first as! LookDates
        
        
        
        //lastWornDateLabel.text = "\(formatter.stringFromDate(lastLookDate.dateWorn))"
        var timesWorn = "\(dateWornSet.count)"
        
        
        
        
        cell.timesWornLabel!.text = "Times Worn: \(timesWorn)"
        
        if currentLook.lookFave == true {
            //cell.faveImageView!.image = UIImage(named: "pink-heart-full")
            cell.faveButton!.setImage(UIImage(named: "pink-heart-full"), forState: .Normal)
            
        } else if currentLook.lookFave == false {
            //cell.faveImageView!.image = UIImage(named: "pink-heart-empty")
            cell.faveButton!.setImage(UIImage(named: "pink-heart-empty"), forState: .Normal)
            
        }
        
        cell.lookImageView!.image = UIImage(named: getDocumentPathForFile(currentLook.lookImageName))
        
        

        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        
//        let currentLookDate = lookDatesArray[indexPath.row]
//        
//        let currentLook = currentLookDate.relationshipLookDateLook
//        
//        println("\(currentLookDate)")
//          println("\(currentLook)")
//        
//        for matchLookDate in currentLook.relationshipLookLookDates {
//            
//            if currentLookDate.dateWorn == matchLookDate.dateWorn {
//                println("DAte Match")
//            }
//        }
//        
        
        
        performSegueWithIdentifier("editFromDateToDetailSegue", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destController = segue.destinationViewController as! SelfieViewController
        
        //var x = 1 as Float // same as this
        if segue.identifier == "editFromDateToDetailSegue" {
            
            let indexPath = looksTableView.indexPathForSelectedRow()
            if let unwrappedIndexPath = indexPath {
                
                let currentLookDate = lookDatesArray[unwrappedIndexPath.row]
                
                let currentLook = currentLookDate.relationshipLookDateLook
                    destController.selectedLook = currentLook
                    destController.selectedLookDate = currentLookDate
                    looksTableView.deselectRowAtIndexPath(unwrappedIndexPath, animated: true)
                // need this in other apps ^
                
            }
        }
        
        if segue.identifier == "addToDetailSegue" {
            destController.selectedLook = nil
            
        }
        
    }

    //MARK: - LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext:NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        looksTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

        
        lookCalendar.appearance.weekdayTextColor = UIColor(red: 238/255, green: 139/255, blue: 139/255, alpha: 1)
        lookCalendar.appearance.headerTitleColor = UIColor(red: 255/255, green: 67/255, blue: 42/255, alpha: 1)
        lookCalendar.appearance.eventColor =  UIColor(red: 255/255, green: 122/255, blue: 104/255, alpha: 1)
        lookCalendar.appearance.selectionColor =  UIColor(red: 244/255, green: 197/255, blue: 76/255, alpha: 1)
        lookCalendar.appearance.todayColor =  UIColor(red: 238/255, green: 139/255, blue: 139/255, alpha: 1)

 
       var todayDate = NSDate()
//        
//        calendar(lookCalendar, subtitile: todayDate)
//        
        
        calendar(lookCalendar, didSelectDate: todayDate)
        
        
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        lookDatesArray = searchDate(lookCalendar.selectedDate)
        looksTableView.reloadData()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

