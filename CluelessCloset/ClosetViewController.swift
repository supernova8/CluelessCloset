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
    var deleteLookIndexPath: NSIndexPath? = nil
    var lookToFaveIndexPath: NSIndexPath? = nil
    
    @IBOutlet var lookSearchBar :UISearchBar!
    @IBOutlet var looksTableView :UITableView!
    @IBOutlet private var editBarButtonItem :UIBarButtonItem!
    
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
    
    @IBAction private func editButtonPressed(sender: UIBarButtonItem!) {
        if looksTableView.editing {
            looksTableView.setEditing(false, animated: true)
            editBarButtonItem.title = "Edit"
        } else {
            looksTableView.setEditing(true, animated: true)
            editBarButtonItem.title = "Done"
        }
    }

    
    @IBAction func searchBarSearchButtonClicked(sender: UISearchBar) {
        
        sender.resignFirstResponder()
        //var searchStringPlus = lookSearchBar.text
        
        
        //searchStringPlus = searchStringPlus.stringByReplacingOccurrencesOfString(" ", withString: "+")
        
        println("Search For This: \(lookSearchBar.text)")
        
        looksArray = searchLooks()
        
        looksTableView.reloadData()
        
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
         println("ended editing search")
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        println("text Did Change in Search Bar: \(searchText)")
    
        if count(searchText) == 0 {
            println("canceled button")
            
            self.searchBarCancelButtonClicked(searchBar)
            
            //searchBar.resignFirstResponder()
            
//            looksArray = searchLooks()
//            
//            looksTableView.reloadData()
//            
//            searchBar.resignFirstResponder()

        }
    
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        // Clear any search criteria
        searchBar.text = ""
        
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
        
        // Force reload of table data

        
        println("canceled search")
        
        looksArray = searchLooks()
        
        looksTableView.reloadData()
    }
    
    func searchLooks() -> [Looks] {
        println("Fetch")
        
        var searchString = lookSearchBar.text
        
        let fetchRequest :NSFetchRequest = NSFetchRequest(entityName: "Looks")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lookNumber", ascending: true), NSSortDescriptor(key: "lookName", ascending:true)]
        
        if count(searchString) > 0 {
            
            if searchString.capitalizedString == "Fave" || searchString.capitalizedString == "Fav" || searchString.capitalizedString == "Favorite" {
                
                    println("Fave!!")
                
            let predicate = NSPredicate(format: "lookFave == 1")
                
                fetchRequest.predicate = predicate

            } else {

        let predicate = NSPredicate(format: "lookTags contains[cd] %@ or lookName contains[cd] %@ or lookAccessoryType contains[cd] %@ or lookBottomType contains[cd] %@ or lookDressType contains[cd] %@ or lookNumber contains[cd] %@ or lookOuterwearType contains[cd] %@ or lookSeason contains[cd] %@ or lookShoeType contains[cd] %@ or lookTopType contains[cd] %@", searchString, searchString, searchString, searchString, searchString, searchString, searchString, searchString, searchString, searchString)
           
                fetchRequest.predicate = predicate

            }
        //fetchRequest.predicate = predicate
        }
        //var predicate = NSPredicate.
        
        return managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as! [Looks]
        
    }
    
    func getDocumentPathForFile(filename: String) -> String {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        //NSTemporaryDirectory() // temp directory
        return  documentsPath.stringByAppendingPathComponent(filename)
        
        
    }
    
    //MARK: - TableView Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("Count: \(looksArray.count)")
        return looksArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
//        cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:"cell")
//        
//        
//        NSString *cellIdentifier =@"Cell"; //we've replaced string with this
//        
//        TunesTableViewCell *cell = (TunesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        
        var cell = tableView.dequeueReusableCellWithIdentifier("closetLookCell") as! ClosetLookTableViewCell
//         :UILabel!
//        @IBOutlet var  :UILabel!
//        @IBOutlet var  :UILabel!
//        @IBOutlet var lastWornLabel :UILabel!
//        @IBOutlet var  :UILabel!
//        @IBOutlet var  :UIImageView!
//        @IBOutlet var  :UIImageView!

 
        
        
        let currentLook = looksArray[indexPath.row]
        cell.lookNumberLabel!.text = "Look No. \(currentLook.lookNumber)"
        
        cell.lookNameLabel!.text = "\"\(currentLook.lookName)\""
        cell.seasonLabel!.text = "\(currentLook.lookSeason) Season"
        
        
        let dateWornSet = currentLook.relationshipLookLookDates
        var sortDescriptor = NSSortDescriptor(key: "dateWorn", ascending: false)
        var dateWornSortedArray = dateWornSet.sortedArrayUsingDescriptors([sortDescriptor])
        
        var lastLookDate = dateWornSortedArray.first as! LookDates
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        
        //lastWornDateLabel.text = "\(formatter.stringFromDate(lastLookDate.dateWorn))"
        var timesWorn = "\(dateWornSet.count)"

        
        cell.lastWornLabel.text = "Last Worn: \(formatter.stringFromDate(lastLookDate.dateWorn))"
        
        
        cell.timesWornLabel!.text = "\(timesWorn)"
        
        if currentLook.lookFave == true {
        //cell.faveImageView!.image = UIImage(named: "pink-heart-full")
        cell.faveButton!.setImage(UIImage(named: "pink-heart-full"), forState: .Normal)

        } else if currentLook.lookFave == false {
        //cell.faveImageView!.image = UIImage(named: "pink-heart-empty")
        cell.faveButton!.setImage(UIImage(named: "pink-heart-empty"), forState: .Normal)
      
        }
        
        cell.lookImageView!.image = UIImage(named: getDocumentPathForFile(currentLook.lookImageName))

        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        //let imageName = "yourImage.png"
       
        //let imageView = UIImageView(image: image!)
        
//         let image = UIImage(named: "cell_middle.png")
//        cell.backgroundView = UIImageView(image: image!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("editToDetailSegue", sender: self)
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
                
        return 145.0
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let deleteAction = UITableViewRowAction(style: .Normal, title: "Delete") { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            println("Delete")
            //dial the phone code
            
            self.deleteLookIndexPath = indexPath
            let lookToDelete = self.looksArray[indexPath.row]
            
            self.confirmDelete("Look No. \(lookToDelete.lookNumber)")
            
        }
        
        deleteAction.backgroundColor = UIColor.redColor()
      
        
//        let faveAction = UITableViewRowAction(style: .Normal, title: "Fave") { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
//            println("Fave")
//            
//            
//            self.lookToFaveIndexPath = indexPath
//            self.lookToFave()
//            
//            
//            let lookToFave = self.looksArray[indexPath.row]
//            
//            if lookToFave.lookFave == false {
//                lookToFave.lookFave = true
//             } else if lookToFave.lookFave == true {
//                lookToFave.lookFave = false
//             }
//          
//            self.appDelegate.saveContext()
//            self.looksTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
//            
//        }
//        faveAction.backgroundColor = UIColor(red: 255/255, green: 67/255, blue: 242/255, alpha: 1)

        
        //return [deleteAction, faveAction]
        
        return [deleteAction]
        
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }

    func colorForIndex(index: Int) -> UIColor {
        let itemCount = looksArray.count - 1
        let color = (CGFloat(index + 3) / CGFloat(itemCount)) * 0.6
        let color2 = (CGFloat(index) / CGFloat(itemCount)) * 0.95
        return UIColor(red: 1.0, green: color, blue: 0.95, alpha: 1.0)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            //cell.backgroundColor = colorForIndex(indexPath.row)
            //cell.backgroundColor = UIColor(red: 1.0, green: 0.67, blue: 0.95, alpha: 1.0)
    }
    
    //MARK: - Interactivity Methods
    
   @IBAction func faveButtonTapped(sender: AnyObject) {
        println("Fave Button Tapped")
    
    let textFieldPosition = sender.convertPoint(CGPointZero, toView: looksTableView)
    if let indexPath = looksTableView.indexPathForRowAtPoint(textFieldPosition) {
    
    //let cell = looksTableView.cellForRowAtIndexPath(indexPath!)

    
        //if let indexPath = lookToFaveIndexPath {
            println("Look To Fave")
            
            looksTableView.beginUpdates()
            
            let lookToFave = self.looksArray[indexPath.row]
            
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
    
    // Delete Confirmation and Handling
    func confirmDelete(look: String) {
        let alert = UIAlertController(title: "Delete Look", message: "Are you sure you want to permanently delete \(look)?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeleteLook)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeleteLook)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleDeleteLook(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteLookIndexPath {
            
//            managedObjectContext.deleteObject(looksArray[indexPath.row])
//            appDelegate.saveContext()
//            looksTableView.reloadData()
//            
            
            looksTableView.beginUpdates()
            
            managedObjectContext.deleteObject(looksArray[indexPath.row])
            
            looksArray.removeAtIndex(indexPath.row)
            
            // Note that indexPath is wrapped in an array:  [indexPath]
            looksTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            deleteLookIndexPath = nil
            appDelegate.saveContext()
            looksTableView.endUpdates()
        }
    }
    
    func cancelDeleteLook(alertAction: UIAlertAction!) {
        deleteLookIndexPath = nil
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destController = segue.destinationViewController as! SelfieViewController
        
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
    
//    func configureView() {
//        
//        // Change the font and size of nav bar text
//        if let navBarFont = UIFont(name: "Budmo", size: 30.0) {
//            println("Carosel font")
//            let navBarAttributesDictionary: [NSObject: AnyObject]? = [
//                NSForegroundColorAttributeName: UIColor.brightPinkColor(),
//                NSFontAttributeName: navBarFont
//            ]
//            
//            navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
//            //UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: "Budmo"], forState: UIControlState.Normal)
//            //shuffleBarButtonItem.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Didot", size: 26)!], forState: UIControlState.Normal)
//        }
//        //UINavigationBar.appearance().titleTextAttributes = [ NSFontAttributeName: customFont!]
//        
//        
//        //UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: customFont!], forState: UIControlState.Normal)
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext:NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        looksTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //configureView()
        
        //self.tempAddRecords()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        looksArray = searchLooks()
        looksTableView.reloadData()
        
        //var image = UIImage(named: "closet_navbar_background")
        //self.navigationController!.navigationBar.setBackgroundImage(image, forBarMetrics: .Default)
//        self.navigationController!.navigationBar.barTintColor = UIColor(red: 0.62, green: 0.81, blue: 0.78, alpha: 1.0)
//        self.navigationController!.navigationBar.translucent = true
        
        //self.navigationController!.navigationBar.backgroundColor = UIColor(red: 0.65, green: 0.84, blue: 0.81, alpha: 1.0)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
