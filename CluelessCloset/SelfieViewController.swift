//
//  SelfieViewController.swift
//  CluelessCloset
//
//  Created by Sonova Middleton on 8/4/15.
//  Copyright (c) 2015 supernova8productions. All rights reserved.
//

import UIKit
import CoreData


class SelfieViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedObjectContext:NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var selectedLook        :Looks? //unwrapped so it can be nil
    var newLook     :Looks! //not wrapped
    var selectedLookDate :LookDates? //not wrapped
    private var newLookDate :LookDates! //not wrapped
    var currentSettings     :Settings!
    var currentCloset       :Closets!
    var newLookImageNumber = 0
    var timesWorn = ""
    
    var looksArray = [Looks]()

    var photoEntryFieldArray = ["Photo"]
    var photoFieldTypeArray = ["photoCell"]
    
    var infoEntryFieldArray = ["Name:","Occasion:","Season:","Time Worn:","Date Worn:"]
    var infoFieldTypeArray = ["textFieldCell","textFieldCell","segControlCell","labelCell","labelCell"]
    
    var detailEntryFieldArray = ["Top:","Bottom:","Dress:","Shoes:","Outerwear:","Accessories:","Tags:"]
    var detailFieldTypeArray = ["dblSegControlCell","dblSegControlCell","dblSegControlCell","dblSegControlCell","dblSegControlCell","dblSegControlCell","textViewCell"]
    
    var todayDate = NSDate()
    
    var imagePicker = UIImagePickerController()
    
    var selfiePhoto :UIImage?
    var haveSelfie: Bool! = false
    var saveToCameraRoll: Bool! = false
    
    @IBOutlet var selfieTableView :UITableView!
    @IBOutlet var faveButton :UIBarButtonItem!
     @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
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
        
        

        
        appDelegate.saveContext()
        println("Temp Record Add")
        
        
    }

    func fetchLooks(SearchText: String) -> [Looks] {
        println("Fetch")
        let fetchRequest :NSFetchRequest = NSFetchRequest(entityName: "Looks")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lookNumber", ascending: true), NSSortDescriptor(key: "lookName", ascending:true)]
        
        return managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as! [Looks]
        
    }
    
    func createClosetAndSettings() {
        
        println("Fetch Image and Look Numbers")
//        let fetchRequest :NSFetchRequest = NSFetchRequest(entityName: "Closets")
//        
//        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lookNumber", ascending: true), NSSortDescriptor(key: "lookName", ascending:true)]
//        
//        var error :NSError?
//        let fetchresults = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [Closets]
        

        println("Create New Closet, Name and Description")
        
        let entityDescription : NSEntityDescription! = NSEntityDescription.entityForName("Closets", inManagedObjectContext: managedObjectContext)
        
        var newCloset = Closets(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
        
        newCloset.closetName = "Default"
        newCloset.closetDescription = "The First Closet!"
        
        appDelegate.saveContext()
        println("New Closet Added")
        
        println("Fetch Image and Look Numbers")
//        let fetchRequestS :NSFetchRequest = NSFetchRequest(entityName: "Settings")
//        
//        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lookNumber", ascending: true), NSSortDescriptor(key: "lookName", ascending:true)]
//        
//        var errorS :NSError?
//        let fetchresultsS = managedObjectContext!.executeFetchRequest(fetchRequest, error: &errorS) as? [Settings]
//        
        println("Create New Image and Look Numbers")
        
        let entityDescriptionS : NSEntityDescription! = NSEntityDescription.entityForName("Settings", inManagedObjectContext: managedObjectContext)
        
        var newSetting = Settings(entity: entityDescriptionS, insertIntoManagedObjectContext: managedObjectContext)
        
        newSetting.imageNameCounter = 1 as Int
        newSetting.lookNumberCounter = 1 as Int
        
        appDelegate.saveContext()
        println("New Setting Add")
        

        
    }
    func fetchCloset() -> Closets {
        println("Fetch Image and Look Numbers")
        let fetchRequest :NSFetchRequest = NSFetchRequest(entityName: "Closets")
        
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lookNumber", ascending: true), NSSortDescriptor(key: "lookName", ascending:true)]
        
        var error :NSError?
        let fetchresults = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [Closets]
        
        if let fetchresultsArray = fetchresults {
            let currentCloset = fetchresultsArray[0] as Closets
            println("Return CLoset Name and Description: \(currentCloset.closetName), \(currentCloset.closetDescription)")
            
            return currentCloset
        } else {
        
            println("Create New Closet, Name and Description")
            
            let entityDescription : NSEntityDescription! = NSEntityDescription.entityForName("Closets", inManagedObjectContext: managedObjectContext)
            
            var newCloset = Closets(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
            
            newCloset.closetName = "Default"
            newCloset.closetDescription = "The First Closet!"
            
            appDelegate.saveContext()
            println("New Closet Add")
            return newCloset
        }
    }

    
    
    func fetchSettings() -> Settings {
        println("Fetch Image and Look Numbers")
        let fetchRequest :NSFetchRequest = NSFetchRequest(entityName: "Settings")
        
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lookNumber", ascending: true), NSSortDescriptor(key: "lookName", ascending:true)]
        
        var error :NSError?
        let fetchresults = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [Settings]
        
        if let fetchresultsArray = fetchresults {
            let currentSets = fetchresultsArray[0] as Settings
            println("Return Image and Look Numbers: \(currentSets.imageNameCounter),  \(currentSets.lookNumberCounter)")
            
            return currentSets
        } else {
        
            println("Create New Image and Look Numbers")
            
            let entityDescription : NSEntityDescription! = NSEntityDescription.entityForName("Settings", inManagedObjectContext: managedObjectContext)
            
            var newSetting = Settings(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
            
            newSetting.imageNameCounter = 1 as Int
            newSetting.lookNumberCounter = 1 as Int
            
            appDelegate.saveContext()
            println("New Setting Add")
            return newSetting
        }
    }
    

    
   
    //MARK: - TableView Methods
    
    //Sections
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if newLook == nil {
            
            return 1
        }
            return 3
        
    }// this lets it know its sections
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //println("Count: ", looksArray.count)

        if section == 0 {
            println("Sec 0 Count: ", photoEntryFieldArray.count)
            return photoEntryFieldArray.count
        }
        if section == 1 {
            println("Sec 1 Count: ", infoEntryFieldArray.count)
            return infoEntryFieldArray.count
            
        }
        if section == 2 {
            println("Sec 2 Count: ", detailEntryFieldArray.count)
            return detailEntryFieldArray.count
            
        }
        return 0
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return "Photo"
//        }
//        if section == 1 {
//            return "Info"
//        }
//        if section == 2 {
//            return "Details"
//        }
//        return "Unknown"
//    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! SelfieHeaderCell
        //headerCell.backgroundColor = UIColor.cyanColor()
        
        switch (section) {
        case 0:
            headerCell.headerLabel.text = "Photo"
            println("Header Cell")
            //return sectionHeaderView
        case 1:
            headerCell.headerLabel.text = "Info"
            //return sectionHeaderView
        case 2:
            headerCell.headerLabel.text = "Details"
            //return sectionHeaderView
        default:
            headerCell.headerLabel.text = "Other"
        }
        
        return headerCell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60;
    }
   
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        var returnedView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 20.0)) //set these values as necessary
//        returnedView.backgroundColor = UIColor.brightTurqColor()
//        
//        var label = UILabel(frame: CGRectMake(8, 8, 12, 10))
//        if section == 0 {
//            label.text = "Photo"
//        }
//        if section == 1 {
//            label.text = "Info"
//        }
//        if section == 2 {
//            label.text =  "Details"
//        }
//
//        //label.text = self.sectionHeaderTitleArray[section]
//        returnedView.addSubview(label)
//        
//        return returnedView
//    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        if indexPath.section == 0 {
            
            var photoCell = tableView.dequeueReusableCellWithIdentifier("photoCell") as! PhotoTableViewCell
            if let lookPhoto = selfiePhoto {
            photoCell.lookImageView.image = selfiePhoto
                //photoCell.lookImageView.image = UIImage(named: getDocumentPathForFile(newLook.lookImageName))
                //println("we have a photo! number: \(currentSettings.imageNameCounter)")
            }
            //photoCell.galleryButton.addTarget(self, action: galleryButtonTapped:", forControlEvents: UIControlEvents.EditingChanged)
            //photoCell.cellLabel.text = infoEntryFieldArray[indexPath.row]
            
//            photoCell.saveToCameraRollSwitch.addTarget(self, action: "saveToCameraRollSwitchChanged:", forControlEvents: UIControlEvents.ValueChanged)
//            photoCell.selectionStyle = UITableViewCellSelectionStyle.None
            
            //photoCell.saveToCameraRollSwitch.addTarget(self, action: "saveToCameraRollSwitchChanged:", forControlEvents: UIControlEvents.ValueChanged)
            photoCell.selectionStyle = UITableViewCellSelectionStyle.None
            
            
            if (haveSelfie == false) {
                println("Have Selfie? \(haveSelfie)")
                //photoCell.saveToCameraRollButton.selected = false
                photoCell.saveToCameraRollButton.hidden = false
                photoCell.saveToCameraRollButton.enabled = false
                photoCell.saveToCameraRollButton.backgroundColor = UIColor.selfieButtonOffColor()
                
                photoCell.shareButton.backgroundColor = UIColor.selfieButtonOffColor()
                photoCell.shareButton.hidden = false
                photoCell.shareButton.enabled = false
                
                //photoCell.saveToCameraRollLabel.textColor = UIColor.lightGrayColor()
                //photoCell.saveToCameraRollView.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 0.5)
                
//                photoCell.saveToCameraRollSwitch.userInteractionEnabled = false
//                photoCell.saveToCameraRollLabel.textColor = UIColor.lightGrayColor()
//                photoCell.saveToCameraRollView.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 0.5)
                //segControlCell.cellSegControl.enabled = false
            } else {
                println("Have Selfie? \(haveSelfie)")
                photoCell.saveToCameraRollButton.hidden = false
                photoCell.saveToCameraRollButton.enabled = true
                photoCell.saveToCameraRollButton.backgroundColor = UIColor.selfieButtonColor()
                
                photoCell.shareButton.backgroundColor = UIColor.selfieButtonColor()
                photoCell.shareButton.hidden = false
                photoCell.shareButton.enabled = true
                
//                photoCell.saveToCameraRollSwitch.userInteractionEnabled = true
//                photoCell.saveToCameraRollLabel.textColor = UIColor(red: 127/255, green: 188/255, blue: 163/255, alpha: 1)
//                photoCell.saveToCameraRollView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)

                //segControlCell.cellSegControl.enabled = true
            }
 
            return photoCell

        } else if indexPath.section == 1 {
            switch infoFieldTypeArray[indexPath.row] {
            case "textFieldCell":
                var textFieldCell = tableView.dequeueReusableCellWithIdentifier("textFieldCell") as! TextFieldTableViewCell
                textFieldCell.cellLabel.text = infoEntryFieldArray[indexPath.row]
                
                if textFieldCell.cellLabel.text == "Name:" {
                    textFieldCell.cellTextField.text = newLook.lookName
                    
                } else if textFieldCell.cellLabel.text == "Occasion:" {
                    textFieldCell.cellTextField.text = newLookDate.dateOccasion
                }
                
                textFieldCell.cellTextField.addTarget(self, action: "tableFieldChanged:", forControlEvents: UIControlEvents.EditingChanged)
                textFieldCell.selectionStyle = UITableViewCellSelectionStyle.None
                
//                if (haveSelfie == false) {
//                    println("Have Selfie? \(haveSelfie)")
//                textFieldCell.userInteractionEnabled = false
//                textFieldCell.cellTextField.textColor = UIColor.lightGrayColor()
//                textFieldCell.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 0.5)
//                textFieldCell.cellLabel.textColor = UIColor.lightGrayColor()
//                } else {
                    println("Have Selfie? \(haveSelfie)")
                    //textFieldCell.userInteractionEnabled = true
                    //textFieldCell.cellTextField.textColor = UIColor.blackColor()
                    //textFieldCell.backgroundColor = UIColor.whiteColor()
                    //textFieldCell.cellLabel.textColor = UIColor.blackColor()
//                }
                return textFieldCell
            case "labelCell":
                var labelCell = tableView.dequeueReusableCellWithIdentifier("labelCell") as! LabelTableViewCell
                labelCell.cellLabel.text = infoEntryFieldArray[indexPath.row]

                
                if labelCell.cellLabel.text == "Date Worn:" {
                    
                var formatter = NSDateFormatter()
                formatter.dateFormat = "EEEE, MMMM d, yyyy"

                labelCell.cellDateLabel.text = "\(formatter.stringFromDate(newLookDate.dateWorn))"
                    
                } else if labelCell.cellLabel.text == "Time Worn:" {
                    
                    labelCell.cellDateLabel.text = timesWorn
                    
                }
                
                labelCell.selectionStyle = UITableViewCellSelectionStyle.None
               // labelCell.cellLabel.addTarget(self, action: "tableFieldChanged:", forControlEvents: UIControlEvents.ValueChanged)
                
                if (haveSelfie == false) {
                    println("Have Selfie? \(haveSelfie)")
                    labelCell.userInteractionEnabled = false
                    labelCell.cellLabel.textColor = UIColor.lightGrayColor()
                    labelCell.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 0.5)
                    labelCell.cellDateLabel.textColor = UIColor.lightGrayColor()
                } else {
                    println("Have Selfie? \(haveSelfie)")
                    labelCell.userInteractionEnabled = true
                    labelCell.cellLabel.textColor = UIColor.blackColor()
                    labelCell.backgroundColor = UIColor.brightTurqColor()
                    labelCell.cellDateLabel.textColor = UIColor.brightPinkColor()
                }
                
                
                
                return labelCell
           case "segControlCell":
                
                var segControlCell = tableView.dequeueReusableCellWithIdentifier("segControlCell") as! SegControlTableViewCell
                segControlCell.cellLabel.text = infoEntryFieldArray[indexPath.row]
                //seg control

                //segControlCell.cellSegControl = UISegmentedControl (items: ["First","Second","Third"])
                //segControlCell.cellSegControl.frame = CGRectMake(60, 250,200, 30)
                segControlCell.cellSegControl.removeAllSegments()
                let tempArray = ["Fall","Winter","Spring", "Summer" ]
                for season in tempArray {
                    segControlCell.cellSegControl.insertSegmentWithTitle(season, atIndex: 0, animated: false)
                }
                //segControlCell.cellSegControl.selectedSegmentIndex = 0
                //segmentedControl.addTarget(self, action: "segmentedControlAction:", forControlEvents: .ValueChanged)
                //self.view.addSubview(segControlCell.cellSegControl)
                
                let selectTempArray = tempArray.reverse()
                for (var i = 0; i < selectTempArray.count; i++) {
                    if newLook.lookSeason == selectTempArray[i] {
                        segControlCell.cellSegControl.selectedSegmentIndex = i
                    }
                }

                
                
                
//                for season in selectTempArray {
//                    if newLook.lookSeason == season {
//                        segControlCell.cellSegControl.   selectedSegmentIndex = selectTempArray.
//                    }
//                    
//                }
                
                segControlCell.cellSegControl.addTarget(self, action: "tableFieldChanged:", forControlEvents: UIControlEvents.ValueChanged)
                segControlCell.selectionStyle = UITableViewCellSelectionStyle.None
                
                if (haveSelfie == false) {
                    println("Have Selfie? \(haveSelfie)")
                    segControlCell.userInteractionEnabled = false
                    segControlCell.cellLabel.textColor = UIColor.lightGrayColor()
                    segControlCell.backgroundColor = UIColor.tealColor()
                    segControlCell.cellSegControl.enabled = false
                } else {
                    println("Have Selfie? \(haveSelfie)")
                    segControlCell.userInteractionEnabled = true
                    segControlCell.cellLabel.textColor = UIColor.blackColor()
                    segControlCell.backgroundColor = UIColor.tealColor()
                    segControlCell.cellSegControl.enabled = true
                }
                
                
                return segControlCell
            case "datePickerCell":
                var datePickerCell = tableView.dequeueReusableCellWithIdentifier("datePickerCell") as! DatePickerTableViewCell
                datePickerCell.cellDatePickerView.date = newLookDate.dateWorn
                datePickerCell.cellDatePickerView.addTarget(self, action: "datePickerChanged:", forControlEvents: UIControlEvents.ValueChanged)
                datePickerCell.selectionStyle = UITableViewCellSelectionStyle.None
                return datePickerCell
            default:
                var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }

            
            
            
        } else if indexPath.section == 2 {
            switch detailFieldTypeArray[indexPath.row] {
            case "textViewCell":
                var textViewCell = tableView.dequeueReusableCellWithIdentifier("textViewCell") as! TextViewTableViewCell
                textViewCell.cellLabel.text = detailEntryFieldArray[indexPath.row]
                textViewCell.cellTextView.text = newLook.lookTags
                
                textViewCell.selectionStyle = UITableViewCellSelectionStyle.None
                
                if (haveSelfie == false) {
                    println("Have Selfie? \(haveSelfie)")
                    textViewCell.userInteractionEnabled = false
                    textViewCell.cellLabel.textColor = UIColor.lightGrayColor()
                    textViewCell.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 0.5)
                    textViewCell.cellTextView.textColor = UIColor.lightGrayColor()
                } else {
                    println("Have Selfie? \(haveSelfie)")
                    textViewCell.userInteractionEnabled = true
                    textViewCell.cellLabel.textColor = UIColor.blackColor()
                    textViewCell.backgroundColor = UIColor.whiteColor()
                    textViewCell.cellTextView.textColor = UIColor.blackColor()
                }

                
                
                return textViewCell
            case "buttonCell":
                var buttonCell = tableView.dequeueReusableCellWithIdentifier("buttonCell") as! ButtonTableViewCell
                //buttonCell.cellLabel.text = detailEntryFieldArray[indexPath.row]
                buttonCell.saveButton.addTarget(self, action: "tableFieldChanged:", forControlEvents: UIControlEvents.ValueChanged)
                buttonCell.selectionStyle = UITableViewCellSelectionStyle.None
                return buttonCell

            case "dblSegControlCell":
                var dblSegControlCell = tableView.dequeueReusableCellWithIdentifier("dblSegControlCell") as! DoubleSegControlTableViewCell
                dblSegControlCell.cellLabel.text = detailEntryFieldArray[indexPath.row]
                //seg control
                
                if dblSegControlCell.cellLabel.text == "Top:" {
                   
                        dblSegControlCell.cellSegControl.removeAllSegments()
                        let tempArray = ["T-Shirt","Shirt","Blouse", "None" ]
                        for season in tempArray {
                            dblSegControlCell.cellSegControl.insertSegmentWithTitle(season, atIndex: 0, animated: false)
                        }
                        
                        dblSegControlCell.cellSegControl2.removeAllSegments()
                        let tempArray2 = ["Other","Polo","Sweater", "Tank" ]
                        for season in tempArray2 {
                            dblSegControlCell.cellSegControl2.insertSegmentWithTitle(season, atIndex: 0, animated: false)
                        }
                    
                    if (newLook.lookTopType == "") {
                        dblSegControlCell.cellSegControl.selectedSegmentIndex = 0
                    } else {
                    
                        let selectTempArray = tempArray.reverse()
                        for (var i = 0; i < selectTempArray.count; i++) {
                            //print("Str: \(selectTempArray[i])")
                            if newLook.lookTopType == selectTempArray[i] {
                                dblSegControlCell.cellSegControl.selectedSegmentIndex = i
                            }
                        }
                        
                        let selectTempArray2 = tempArray2.reverse()
                        for (var i = 0; i < selectTempArray2.count; i++) {
                            //print("Str: \(selectTempArray2[i])")
                            if newLook.lookTopType == selectTempArray2[i] {
                                dblSegControlCell.cellSegControl2.selectedSegmentIndex = i
                            }
                        }
                        
                    }
                    
                    
                    
                } else if dblSegControlCell.cellLabel.text == "Bottom:" {
                    
                    dblSegControlCell.cellSegControl.removeAllSegments()
                    let tempArray = ["Leggings","Jeans","Pants", "None" ]
                    for season in tempArray {
                        dblSegControlCell.cellSegControl.insertSegmentWithTitle(season, atIndex: 0, animated: false)
                    }
                    
                    dblSegControlCell.cellSegControl2.removeAllSegments()
                    let tempArray2 = ["Other","Cropped","Shorts", "Skirt" ]
                    for season in tempArray2 {
                        dblSegControlCell.cellSegControl2.insertSegmentWithTitle(season, atIndex: 0, animated: false)
                    }
                    
                    if (newLook.lookBottomType == "") {
                        dblSegControlCell.cellSegControl.selectedSegmentIndex = 0
                    } else {
                        
                        let selectTempArray = tempArray.reverse()
                        for (var i = 0; i < selectTempArray.count; i++) {
                            //print("Str: \(selectTempArray[i])")
                            if newLook.lookBottomType == selectTempArray[i] {
                                dblSegControlCell.cellSegControl.selectedSegmentIndex = i
                            }
                        }
                        
                        let selectTempArray2 = tempArray2.reverse()
                        for (var i = 0; i < selectTempArray2.count; i++) {
                            //print("Str: \(selectTempArray2[i])")
                            if newLook.lookBottomType == selectTempArray2[i] {
                                dblSegControlCell.cellSegControl2.selectedSegmentIndex = i
                            }
                        }
                        
                    }

                    
                    
                } else if dblSegControlCell.cellLabel.text == "Dress:" {
                   
                    dblSegControlCell.cellSegControl.removeAllSegments()
                    let tempArray = ["Evening","Cocktail","Maxi", "None" ]
                    for season in tempArray {
                        dblSegControlCell.cellSegControl.insertSegmentWithTitle(season, atIndex: 0, animated: false)
                    }
                    
                    dblSegControlCell.cellSegControl2.removeAllSegments()
                    let tempArray2 = ["Other","Baby-Doll","Midi", "Knee-Length" ]
                    for season in tempArray2 {
                        dblSegControlCell.cellSegControl2.insertSegmentWithTitle(season, atIndex: 0, animated: false)
                    }
                    
                    if (newLook.lookDressType == "") {
                        dblSegControlCell.cellSegControl.selectedSegmentIndex = 0
                    } else {
                        
                        let selectTempArray = tempArray.reverse()
                        for (var i = 0; i < selectTempArray.count; i++) {
                            print("Str: \(selectTempArray[i])")
                            if newLook.lookDressType == selectTempArray[i] {
                                dblSegControlCell.cellSegControl.selectedSegmentIndex = i
                            }
                        }
                        
                        let selectTempArray2 = tempArray2.reverse()
                        for (var i = 0; i < selectTempArray2.count; i++) {
                            print("Str: \(selectTempArray2[i])")
                            if newLook.lookDressType == selectTempArray2[i] {
                                dblSegControlCell.cellSegControl2.selectedSegmentIndex = i
                            }
                        }
                        
                    }

                    
                } else if dblSegControlCell.cellLabel.text == "Shoes:" {
                    
                    dblSegControlCell.cellSegControl.removeAllSegments()
                    let tempArray = ["Sneakers","Heels","Flats", "None" ]
                    for season in tempArray {
                        dblSegControlCell.cellSegControl.insertSegmentWithTitle(season, atIndex: 0, animated: false)
                    }
                    
                    dblSegControlCell.cellSegControl2.removeAllSegments()
                    let tempArray2 = ["Other","Wedges","Sandals", "Boots" ]
                    for season in tempArray2 {
                        dblSegControlCell.cellSegControl2.insertSegmentWithTitle(season, atIndex: 0, animated: false)
                    }
                    
                    if (newLook.lookShoeType == "") {
                        dblSegControlCell.cellSegControl.selectedSegmentIndex = 0
                    } else {
                        
                        let selectTempArray = tempArray.reverse()
                        for (var i = 0; i < selectTempArray.count; i++) {
                            print("Str: \(selectTempArray[i])")
                            if newLook.lookShoeType == selectTempArray[i] {
                                dblSegControlCell.cellSegControl.selectedSegmentIndex = i
                            }
                        }
                        
                        let selectTempArray2 = tempArray2.reverse()
                        for (var i = 0; i < selectTempArray2.count; i++) {
                            print("Str: \(selectTempArray2[i])")
                            if newLook.lookShoeType == selectTempArray2[i] {
                                dblSegControlCell.cellSegControl2.selectedSegmentIndex = i
                            }
                        }
                        
                    }

                    
                    
                } else if dblSegControlCell.cellLabel.text == "Outerwear:" {
                    
                    dblSegControlCell.cellSegControl.removeAllSegments()
                    let tempArray = ["Hat","Coat","Jacket", "None" ]
                    for season in tempArray {
                        dblSegControlCell.cellSegControl.insertSegmentWithTitle(season, atIndex: 0, animated: false)
                    }
                    
                    dblSegControlCell.cellSegControl2.removeAllSegments()
                    let tempArray2 = ["Other","Scarf","Gloves", "Sweatshirt" ]
                    for season in tempArray2 {
                        dblSegControlCell.cellSegControl2.insertSegmentWithTitle(season, atIndex: 0, animated: false)
                        
                    }
                    
                    if (newLook.lookOuterwearType == "") {
                        dblSegControlCell.cellSegControl.selectedSegmentIndex = 0
                    } else {
                        
                        let selectTempArray = tempArray.reverse()
                        for (var i = 0; i < selectTempArray.count; i++) {
                            //print("Str: \(selectTempArray[i])")
                            if newLook.lookOuterwearType == selectTempArray[i] {
                                dblSegControlCell.cellSegControl.selectedSegmentIndex = i
                            }
                        }
                        
                        let selectTempArray2 = tempArray2.reverse()
                        for (var i = 0; i < selectTempArray2.count; i++) {
                            //print("Str: \(selectTempArray2[i])")
                            if newLook.lookOuterwearType == selectTempArray2[i] {
                                dblSegControlCell.cellSegControl2.selectedSegmentIndex = i
                            }
                        }
                        
                    }

                    
                    
                } else if dblSegControlCell.cellLabel.text == "Accessories:" {
                    
                    dblSegControlCell.cellSegControl.removeAllSegments()
                    let tempArray = ["Socks","Belt","Sunglasses", "None" ]
                    for season in tempArray {
                        dblSegControlCell.cellSegControl.insertSegmentWithTitle(season, atIndex: 0, animated: false)
                    }
                    
                    dblSegControlCell.cellSegControl2.removeAllSegments()
                    let tempArray2 = ["Other","Headphones", "Backpack", "Handbag" ]
                    for season in tempArray2 {
                        dblSegControlCell.cellSegControl2.insertSegmentWithTitle(season, atIndex: 0, animated: false)
                    }
                    
                    if (newLook.lookAccessoryType == "") {
                        dblSegControlCell.cellSegControl.selectedSegmentIndex = 0
                    } else {
                        
                        let selectTempArray = tempArray.reverse()
                        for (var i = 0; i < selectTempArray.count; i++) {
                            print("Str: \(selectTempArray[i])")
                            if newLook.lookAccessoryType == selectTempArray[i] {
                                dblSegControlCell.cellSegControl.selectedSegmentIndex = i
                            }
                        }
                        
                        let selectTempArray2 = tempArray2.reverse()
                        for (var i = 0; i < selectTempArray2.count; i++) {
                            print("Str: \(selectTempArray2[i])")
                            if newLook.lookAccessoryType == selectTempArray2[i] {
                                dblSegControlCell.cellSegControl2.selectedSegmentIndex = i
                            }
                        }
                        
                    }

                }
                //dblSegControlCell.cellSegControl.selectedSegmentIndex = 0
                dblSegControlCell.cellSegControl.apportionsSegmentWidthsByContent = true
                dblSegControlCell.cellSegControl2.apportionsSegmentWidthsByContent = true
                dblSegControlCell.cellSegControl.addTarget(self, action: "segControlChanged:", forControlEvents: UIControlEvents.ValueChanged)
                dblSegControlCell.cellSegControl2.addTarget(self, action: "segControl2Changed:", forControlEvents: UIControlEvents.ValueChanged)
                dblSegControlCell.selectionStyle = UITableViewCellSelectionStyle.None
                
                if (haveSelfie == false) {
                    println("Have Selfie? \(haveSelfie)")
                    dblSegControlCell.userInteractionEnabled = false
                    dblSegControlCell.cellLabel.textColor = UIColor.lightGrayColor()
                    dblSegControlCell.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 0.5)
                    dblSegControlCell.cellSegControl.enabled = false
                    dblSegControlCell.cellSegControl2.enabled = false
                } else {
                    println("Have Selfie? \(haveSelfie)")
                    dblSegControlCell.userInteractionEnabled = true
                    dblSegControlCell.cellLabel.textColor = UIColor.blackColor()
                    dblSegControlCell.backgroundColor = UIColor.tealColor()
                    dblSegControlCell.cellSegControl.enabled = true
                    dblSegControlCell.cellSegControl2.enabled = true
                }
                
                
                
                return dblSegControlCell
                
            case "datePickerCell":
                var datePickerCell = tableView.dequeueReusableCellWithIdentifier("datePickerCell") as! DatePickerTableViewCell
                datePickerCell.cellDatePickerView.date = newLookDate.dateWorn
                datePickerCell.cellDatePickerView.addTarget(self, action: "datePickerChanged:", forControlEvents: UIControlEvents.ValueChanged)
                datePickerCell.selectionStyle = UITableViewCellSelectionStyle.None
                return datePickerCell
            default:
                var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }
        
        
        }
            var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
            
        
        
        //return cell
    }

//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        println("IndexPath")
//        if indexPath.section == 1 && infoFieldTypeArray[indexPath.row] == "labelCell" {
//            
//            let cell = tableView.cellForRowAtIndexPath(indexPath) as! LabelTableViewCell
//            if cell.cellLabel.text == "Date Worn:" {
//                let nextIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
//                let nextCell = tableView.cellForRowAtIndexPath(nextIndexPath)
//                if nextCell is DatePickerTableViewCell {
//                    infoEntryFieldArray.removeAtIndex(nextIndexPath.row)
//                    infoFieldTypeArray.removeAtIndex(nextIndexPath.row)
//                    //cell.cellDateLabel.textColor = UIColor.blackColor();
//                    
//                } else {
//                    //cell.cellDateLabel.textColor = UIColor.redColor();
//                    infoEntryFieldArray.insert("New Worn Date", atIndex: indexPath.row + 1)
//                    infoFieldTypeArray.insert("datePickerCell", atIndex: indexPath.row + 1)
//                    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
//                }
//                var theSet = NSMutableIndexSet.new()
//                theSet.addIndex(indexPath.section)
//                tableView.reloadSections( theSet, withRowAnimation: UITableViewRowAnimation.Automatic)

//                println("The Set Count: \(theSet.count)")
//                //tableView.reloadRowsAtIndexPaths(, withRowAnimation: UITableViewRowAnimation.Top)
//                
//                //looksTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
//                //tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
//                tableView.reloadData()
//                println("The Set Count: \(theSet.count)")
//            }
//            println("LabelCell")
//        } else {
//        println("Cell")
//        }
//    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("IndexPath")
        if indexPath.section == 1 && infoFieldTypeArray[indexPath.row] == "labelCell" {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! LabelTableViewCell
            if cell.cellLabel.text == "Date Worn:" {
                let nextIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
                let nextCell = tableView.cellForRowAtIndexPath(nextIndexPath)
                if nextCell is DatePickerTableViewCell {
                    infoEntryFieldArray.removeAtIndex(nextIndexPath.row)
                    infoFieldTypeArray.removeAtIndex(nextIndexPath.row)
                    //cell.cellDateLabel.textColor = UIColor.blackColor();
                    
                } else {
                    //cell.cellDateLabel.textColor = UIColor.redColor();
                    infoEntryFieldArray.insert("New Worn Date", atIndex: indexPath.row + 1)
                    infoFieldTypeArray.insert("datePickerCell", atIndex: indexPath.row + 1)
                    
                }
                var theSet = NSMutableIndexSet.new()
                theSet.addIndex(indexPath.section)
                println("The Set Count: \(indexPath.section)")
                tableView.reloadSections( theSet, withRowAnimation: UITableViewRowAnimation.Automatic)
                
                
                //tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                tableView.reloadData()
            }
            println("LabelCell")
            
        } else {
            println("Cell")
        }
    }
    

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
        if photoFieldTypeArray[indexPath.row] == "photoCell" {
            //return 350.0
            
            //let collectionViewWidth = selfieTableView.bounds.size.width
            let collectionViewHeight = selfieTableView.bounds.size.height - 115.0
            return collectionViewHeight
            
        }
        }
        if indexPath.section == 1 {
            if infoFieldTypeArray[indexPath.row] == "datePickerCell" {
                return 200.0
            }
        }
        if indexPath.section == 2 {
            if detailFieldTypeArray[indexPath.row] == "textViewCell" {
                return 250.0
            } else if detailFieldTypeArray[indexPath.row] == "buttonCell" {
                return 75.0
            } else if detailFieldTypeArray[indexPath.row] == "dblSegControlCell" {
                return 100.0
            }

        }

        
        return 44.0
    }

//    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        
//        // Background view is at index 0, content view at index 1
//        if let bgView = view.subviews[0] as? UIView
//        {
//            // do your stuff
//        }
//        
//        view.layer.borderColor = UIColor.magentaColor().CGColor
//        view.layer.borderWidth = 1
//    }
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        var myCustomView: UIImageView
//        var myImage: UIImage = UIImage(named: "myImageResource")!
//        myCustomView.image = myImage
//        
//        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
//        header.addSubview(myCustomView)
//        return header
//    }
    
    //MARK: - Interactivity Methods
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func tableFieldChanged(sender: AnyObject) {
        
        let textFieldPosition = sender.convertPoint(CGPointZero, toView: selfieTableView)
        let indexPath = selfieTableView.indexPathForRowAtPoint(textFieldPosition)
        
        let cell = selfieTableView.cellForRowAtIndexPath(indexPath!)
        
        if cell is TextFieldTableViewCell {
            let sCell = selfieTableView.cellForRowAtIndexPath(indexPath!) as! TextFieldTableViewCell
            if sCell.cellLabel.text == "Name:" {
                newLook.lookName = sCell.cellTextField.text
                println("Name: \(sCell.cellTextField.text)")
            } else if sCell.cellLabel.text == "Occasion:" {
                newLookDate.dateOccasion = sCell.cellTextField.text
                println("Occasion: \(sCell.cellTextField.text)")
            }
        } else if cell is SegControlTableViewCell {
            let sCell = selfieTableView.cellForRowAtIndexPath(indexPath!) as! SegControlTableViewCell
            if sCell.cellLabel.text == "Season:" {
                let index = sCell.cellSegControl.selectedSegmentIndex
                newLook.lookSeason = sCell.cellSegControl.titleForSegmentAtIndex(index)!
                
                //newLook.lookSeason = sCell.cellSegControl.
                println("season: \(sCell.cellSegControl.selectedSegmentIndex)")
            }
        }
        
        appDelegate.saveContext()
        println("Info Section (tf and Season) Add")
    }

    func segControlChanged(sender: AnyObject) {
        let textFieldPosition = sender.convertPoint(CGPointZero, toView: selfieTableView)
        let indexPath = selfieTableView.indexPathForRowAtPoint(textFieldPosition)
        
        let cell = selfieTableView.cellForRowAtIndexPath(indexPath!)
        
        if cell is DoubleSegControlTableViewCell {
            let sCell = selfieTableView.cellForRowAtIndexPath(indexPath!) as! DoubleSegControlTableViewCell
            sCell.cellSegControl2.selectedSegmentIndex = UISegmentedControlNoSegment
            let index = sCell.cellSegControl.selectedSegmentIndex
            if sCell.cellLabel.text == "Top:" {
                newLook.lookTopType = sCell.cellSegControl.titleForSegmentAtIndex(index)!
            } else if sCell.cellLabel.text == "Bottom:" {
                newLook.lookBottomType = sCell.cellSegControl.titleForSegmentAtIndex(index)!
            } else if sCell.cellLabel.text == "Dress:" {
                newLook.lookDressType = sCell.cellSegControl.titleForSegmentAtIndex(index)!
            } else if sCell.cellLabel.text == "Shoes:" {
                newLook.lookShoeType = sCell.cellSegControl.titleForSegmentAtIndex(index)!
            } else if sCell.cellLabel.text == "Outerwear:" {
                newLook.lookOuterwearType = sCell.cellSegControl.titleForSegmentAtIndex(index)!
            } else if sCell.cellLabel.text == "Accessories:" {
                newLook.lookAccessoryType = sCell.cellSegControl.titleForSegmentAtIndex(index)!
            }

                println("top: \(sCell.cellSegControl.selectedSegmentIndex)")
                println("top2: \(sCell.cellSegControl2.selectedSegmentIndex)")

        }
        appDelegate.saveContext()
        println("Pieces top row Add")
    }
    func segControl2Changed(sender: AnyObject) {
        let textFieldPosition = sender.convertPoint(CGPointZero, toView: selfieTableView)
        let indexPath = selfieTableView.indexPathForRowAtPoint(textFieldPosition)
        
        let cell = selfieTableView.cellForRowAtIndexPath(indexPath!)
        
        if cell is DoubleSegControlTableViewCell {
            let sCell = selfieTableView.cellForRowAtIndexPath(indexPath!) as! DoubleSegControlTableViewCell
                
            sCell.cellSegControl.selectedSegmentIndex = UISegmentedControlNoSegment
            
            let index = sCell.cellSegControl2.selectedSegmentIndex
            if sCell.cellLabel.text == "Top:" {
                newLook.lookTopType = sCell.cellSegControl2.titleForSegmentAtIndex(index)!
            } else if sCell.cellLabel.text == "Bottom:" {
                newLook.lookBottomType = sCell.cellSegControl2.titleForSegmentAtIndex(index)!
            } else if sCell.cellLabel.text == "Dress:" {
                newLook.lookDressType = sCell.cellSegControl2.titleForSegmentAtIndex(index)!
            } else if sCell.cellLabel.text == "Shoes:" {
                newLook.lookShoeType = sCell.cellSegControl2.titleForSegmentAtIndex(index)!
            } else if sCell.cellLabel.text == "Outerwear:" {
                newLook.lookOuterwearType = sCell.cellSegControl2.titleForSegmentAtIndex(index)!
            } else if sCell.cellLabel.text == "Accessories:" {
                newLook.lookAccessoryType = sCell.cellSegControl2.titleForSegmentAtIndex(index)!
            }
                println("top: \(sCell.cellSegControl.selectedSegmentIndex)")
                println("top2: \(sCell.cellSegControl2.selectedSegmentIndex)")
   
        }
        appDelegate.saveContext()
        println("Pices Bottom Row Add")
    }

    @IBAction func saveToCameraRollSwitchChanged(camButton: UIButton) {
       
        saveToCameraRoll = camButton.selected
        
        saveImage()
        
        println("Save To Camera Roll?: \(saveToCameraRoll)")
    }
    
    func textViewDidChange(textView: UITextView) {
//        if cell is TextViewTableViewCell {
//            let sCell = selfieTableView.cellForRowAtIndexPath(indexPath!) as! TextViewTableViewCell
//            if sCell.cellLabel.text == "Tags:" {
//                println("Tags: \(sCell.cellTextView.text)")
//            }
//        }
        newLook.lookTags = textView.text
        println("Tags: \(textView.text)")
        appDelegate.saveContext()
        println("Tags Add")
    }
    
    func datePickerChanged(datepicker: UIDatePicker) {
        
        newLookDate.dateWorn = datepicker.date
        println("Date Worn: \(newLookDate.dateWorn)")
        appDelegate.saveContext()
        println("Date Picker Add")
    }
    
    @IBAction func faveButtonPressed(sender: UIBarButtonItem) {
        
        if faveButton.tag == 0 {
            newLook.lookFave = true
            faveButton.image = UIImage(named: "heart-full")
            faveButton.tag = 1
            
            println("Now a Fave")
            
        }
        else if (faveButton.tag == 1) {
            
            newLook.lookFave = false
            faveButton.image = UIImage(named: "heart-empty")
            faveButton.tag = 0
            
            println("Not a Fave")
            
        } else {
            println("Confused about faves")
            
        }
        appDelegate.saveContext()
        println("Fave Button Add")
    }

    
    @IBAction func shareButtonClicked(sender: UIButton)
    {
        var objectsToShare = [AnyObject]()
        
        
        let textToShare = "Check out my Look No. \(newLook.lookNumber) in Clueless Closet! Tell me what you think!"
            objectsToShare.append(textToShare)
//        let picToShare = selfiePhoto
            objectsToShare.append(selfiePhoto!)
        let linkToShare = NSURL(string: "http://www.supernova8.com/")
            objectsToShare.append(linkToShare!)
        //objectsToShare = [textToShare,picToShare,lookNumberToShare]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll]
            //activityViewController.excludedActivityTypes = [UIActivityTypeCopyToPasteboard,UIActivityTypeAirDrop,UIActivityTypeAddToReadingList,UIActivityTypeAssignToContact,UIActivityTypePostToTencentWeibo,UIActivityTypePostToVimeo,UIActivityTypePrint,UIActivityTypeSaveToCameraRoll,UIActivityTypePostToWeibo]
            
            self.presentViewController(activityVC, animated: true, completion: nil)
        
    }
    
    @IBAction func saveToCameraRollButtonClicked(sender: UIButton)
    {
        var objectsToShare = [AnyObject]()
        
        objectsToShare.append(selfiePhoto!)
        
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        //New Excluded Activities Code
        activityVC.excludedActivityTypes = [UIActivityTypeCopyToPasteboard,UIActivityTypeAirDrop,UIActivityTypeAddToReadingList,UIActivityTypeAssignToContact,UIActivityTypePostToTencentWeibo,UIActivityTypePostToVimeo,UIActivityTypePrint,UIActivityTypePostToWeibo,UIActivityTypeMessage,UIActivityTypeMail, UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypePostToFlickr]
        //activityViewController.excludedActivityTypes = [UIActivityTypeCopyToPasteboard,UIActivityTypeAirDrop,UIActivityTypeAddToReadingList,UIActivityTypeAssignToContact,UIActivityTypePostToTencentWeibo,UIActivityTypePostToVimeo,UIActivityTypePrint,UIActivityTypeSaveToCameraRoll,UIActivityTypePostToWeibo]
        
        //activityViewController.excludedActivityTypes = [UIActivityTypeCopyToPasteboard,UIActivityTypeAirDrop,UIActivityTypeAddToReadingList,UIActivityTypeAssignToContact,UIActivityTypePostToTencentWeibo,UIActivityTypePostToVimeo,UIActivityTypePrint,UIActivityTypeSaveToCameraRoll,UIActivityTypePostToWeibo]
        
        self.presentViewController(activityVC, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Keyboard Handling
    
    func registerForKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillChangeFrame(aNotification: NSNotification) {
        
        let info = aNotification.userInfo!
        println("Keyboard notified")
        
        var frameEnd = info[UIKeyboardFrameEndUserInfoKey]!.CGRectValue()
        var convertedFrameEnd = self.view.convertRect(frameEnd, fromView: nil)
        let heightOffset = self.view.bounds.size.height - convertedFrameEnd.origin.y
        
        var animationDurationValue = info[UIKeyboardAnimationDurationUserInfoKey] as! NSValue
        var duration: NSTimeInterval = 0
        animationDurationValue.getValue(&duration)
        
        self.bottomConstraint.constant = heightOffset
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.selfieTableView.layoutIfNeeded()
        })
        
    }
    
    //MARK: - Camera and Image Methods
    
    @IBAction func cameraButtonTapped(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                
                //let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                //imagePicker.mediaTypes = [kUTTypeImage as NSString]
                imagePicker.allowsEditing = false
                
                self.presentViewController(imagePicker, animated: true, 
                    completion: nil)
                //newMedia = true
        } else {
            let alertController = UIAlertController(title: "No Cameraa!", message:
                "Looks like you don't have a camera! :P", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            println("No Camera");
        }


    }
    
    @IBAction func galleryButtonTapped(sender: AnyObject) {
    
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
                println("Button capture")
                
                
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                imagePicker.allowsEditing = false
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
    }
    
    func createNewLook() {
        
        // it's Nil, an add so create it
        
        println("NEW LOOK")
        
        let entityDescription : NSEntityDescription! = NSEntityDescription.entityForName("Looks", inManagedObjectContext: managedObjectContext)
        let entityDescription2 : NSEntityDescription! = NSEntityDescription.entityForName("LookDates", inManagedObjectContext: managedObjectContext)
        
        
        
        newLook = Looks(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
        newLookDate = LookDates(entity: entityDescription2, insertIntoManagedObjectContext: managedObjectContext)
        
        currentCloset = fetchCloset()
        currentSettings = fetchSettings()
        
        newLook.lookNumber = currentSettings.lookNumberCounter
        currentSettings.lookNumberCounter = currentSettings.lookNumberCounter.integerValue + 1
        
        newLookImageNumber = currentSettings.imageNameCounter.integerValue
        newLook.lookImageName = "image\(newLookImageNumber).png"
        //do i need to do the above here?
        
        currentSettings.imageNameCounter = currentSettings.imageNameCounter.integerValue + 1
        
        newLook.lookName = ""
        newLook.lookSeason = ""
        
        newLook.lookAccessoryType = ""
        newLook.lookBottomType = ""
        newLook.lookDressType = ""
        newLook.lookOuterwearType = ""
        newLook.lookShoeType = ""
        newLook.lookTopType = ""
        newLook.lookTags = ""
        
        newLook.lookArchive = false
        newLook.lookFave = false
        
        //newLook.lookImageName = nil;
        
        newLook.dateAdded = NSDate()
        newLook.dateUpdated = NSDate()
        
        newLook.relationshipLookCloset = currentCloset
        
        newLookDate.dateWorn = NSDate()
        newLookDate.dateUpdated = NSDate()
        newLookDate.dateAdded = NSDate()
        newLookDate.dateOccasion = ""
        
        newLookDate.relationshipLookDateLook = newLook
        
        timesWorn = "0"
        
        //disable fave icon
        
        faveButton.enabled = true
        
        
        
        println(newLook)
        
        navigationItem.title = "Look No. \(newLook.lookNumber)"
        
    }
    
        func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
            
//            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//            //    // Resize the image from the camera
//            UIImage *scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(560.0, 560.0) interpolationQuality:kCGInterpolationHigh];
//            //    // Crop the image to a square (yikes, fancy!)
//            UIImage *croppedImage = [scaledImage croppedImage:CGRectMake((scaledImage.size.width - 560.0)/2, (scaledImage.size.height - 560)/2, 560.0, 560.0)];
//            //    // Show the photo on the screen
//            //    photo.image = croppedImage;
//            //    [picker dismissModalViewControllerAnimated:NO];
//            
//            _dishImageView.image = croppedImage;
//            
//            [picker dismissViewControllerAnimated:true completion:nil];
            
            
            
            
//            // Obj-C
//            // Method signature
//            — (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
//            bounds: (CGSize)bounds
//            interpolationQuality: (CGInterpolationQuality)quality
//            { ... }
//            // Method call
//            [UIImage resizedImageWithContentMode: UIViewContentModeAspectFill
//                bounds: CGSizeMake(size1, size2)
//                interpolationQuality: quality];
//            // Swift
//            // Method signature
//            func resizedImage(contentMode: UIViewContentMode,
//                bounds: CGSize,
//                interpolationQuality quality: CGInterpolationQuality
//                ) -> UIImage { ... }
//            // Method call
//            UIImage.resizedImage(.AspectFill, 
//                bounds: CGSizeMake(size1, size2),
//                interpolationQuality: quality
//            )
            
            
            
            
            
            
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                //selfiePhoto.contentMode = .ScaleAspectFit
                println("Picked An image")
                //let orientedImage = UIImage(CGImage: pickedImage.CGImage, scale: 1, orientation: pickedImage.imageOrientation)!
//                var scaledImage = pickedImage.resizedImage(.AspectFill, bounds:CGSizeMake(560.0, 560.0), interpolationQuality: kCGInterpolationHigh
                
                //let rotatedImage = scaleAndRotateImage(scaledImage)
                
                
                var mainScreenSize : CGSize = UIScreen.mainScreen().bounds.size // Getting main screen size of iPhone
                //var imageSize = CGSizeMake(mainScreenSize.width, mainScreenSize.height)
                 var imageSized = CGSizeMake(mainScreenSize.width, mainScreenSize.height)
                var imageObbj:UIImage! = imageResize(pickedImage, sizeChange: imageSized)
                
                
                //self.view.backgroundColor = UIColor(patternImage:imageObbj)
                
                
                
                
                
                selfiePhoto = imageObbj
                haveSelfie = true
                
                if newLook == nil {
                    println("New Look is Nil, Create New Look")
                    createNewLook()
                }
                
                saveImage()
                selfieTableView.reloadData()
                self.faveButton.enabled = true
                

            }
            
            dismissViewControllerAnimated(true, completion: nil)
            
        }
        
        func imagePickerControllerDidCancel(picker: UIImagePickerController) {
            self.imagePicker = UIImagePickerController()
            dismissViewControllerAnimated(true, completion: nil)
        }
    
    func getDocumentPathForFile(filename: String) -> String {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        //NSTemporaryDirectory() // temp directory
        return  documentsPath.stringByAppendingPathComponent(filename)
        
        
    }
    
    func saveImage() {
        
        println("Save Image!")
        var fileManager = NSFileManager.defaultManager()
        var error:NSErrorPointer = NSErrorPointer()
        
        
        var imageFileName = ""
        
        if newLookImageNumber == 0 {
            
            imageFileName = newLook.lookImageName
            println("Changing Pic: \(imageFileName)")
            
        } else {
            imageFileName = "image\(newLookImageNumber).png"
            println("New Pic: \(imageFileName)")
        }
        
        var newImagePath = getDocumentPathForFile(imageFileName)
        println("Document Path and Name: \(newImagePath)")
        
        if ((selfiePhoto) != nil) {
            
            if (fileManager.fileExistsAtPath(newImagePath)) {
                println("removed file: \(newImagePath)")
               fileManager.removeItemAtPath(newImagePath, error: error)
                if error != nil {
                    println(error.debugDescription)
                }
                
            }
            //scaleImage -obj-C
            //UIImage *scaledRotatedImage = [self scaleAndRotateImage:_dishImageView.image];
            
            let rotatedImage = scaleAndRotateImage(selfiePhoto!)
            UIImagePNGRepresentation(rotatedImage).writeToFile(newImagePath as String, atomically: true)

            
            //UIImagePNGRepresentation(selfiePhoto).writeToFile(newImagePath, atomically: true)
            newLook.lookImageName = imageFileName
            //currentSettings.imageNameCounter = currentSettings.imageNameCounter.integerValue + 1
            
//            if (saveToCameraRoll == true) {
//                
//                UIImageWriteToSavedPhotosAlbum(selfiePhoto, nil, nil, nil)
//                println("Saved to Camera Roll")
//                
//            }
            appDelegate.saveContext()
            println("Save Image Add")
        }
        
    }
    func fileIsLocal(filename: String) -> Bool {
        var fileManager = NSFileManager.defaultManager()
        
        return fileManager.fileExistsAtPath(getDocumentPathForFile(filename))
        
        
    }
    
    func scaleAndRotateImage(image: UIImage) -> UIImage {
        let kMaxResolution = 1280 as CGFloat
        let imgRef = image.CGImage
        
        let width = CGFloat(CGImageGetWidth(imgRef))
        let height = CGFloat(CGImageGetHeight(imgRef))
        
        var transform = CGAffineTransformIdentity
        var bounds = CGRectMake(0.0, 0.0, width, height)
        if width > kMaxResolution || height > kMaxResolution {
            let ratio = width / height
            if ratio > 1 {
                bounds.size.width = kMaxResolution
                bounds.size.height = CGFloat(bounds.size.width) / CGFloat(ratio)
            } else {
                bounds.size.height = kMaxResolution
                bounds.size.width = CGFloat(bounds.size.height) * CGFloat(ratio)
            }
        }
        
        let scaleRatio = CGFloat(bounds.size.width) / CGFloat(width)
        let imageSize = CGSizeMake(CGFloat(CGImageGetWidth(imgRef)), CGFloat(CGImageGetHeight(imgRef)))
        var boundHeight :CGFloat!
        let orient = image.imageOrientation
        switch orient {
        case .Up: //EXIF = 1
            transform = CGAffineTransformIdentity;
        case .UpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
        case .Down: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI));
        case .DownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
        case .LeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * CGFloat(M_PI) / 2.0);
        case .Left: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * CGFloat(M_PI) / 2.0);
        case .RightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI) / 2.0);
        case .Right: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI) / 2.0);
        default:
            NSException(name: "Inavlid Orientation", reason: "Invalid Image orientation", userInfo: nil)
        }
        
        UIGraphicsBeginImageContext(bounds.size);
        
        let context = UIGraphicsGetCurrentContext();
        
        if (orient == UIImageOrientation.Right || orient == UIImageOrientation.Left) {
            CGContextScaleCTM(context, -scaleRatio, scaleRatio);
            CGContextTranslateCTM(context, -height, 0);
        }
        else {
            CGContextScaleCTM(context, scaleRatio, -scaleRatio);
            CGContextTranslateCTM(context, 0, -height);
        }
        
        CGContextConcatCTM(context, transform);
        
        CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
        let imageCopy = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return imageCopy;
    }
    
    
    func imageResize (imageObj:UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
    //MARK: - View
    
//    func configureView() {
//        
//        // Change the font and size of nav bar text
//        if let navBarFont = UIFont(name: "KG Manhattan Script", size: 32.0) {
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

    
    //MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
         selfieTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
         registerForKeyboardNotifications()
        
        //create New Closet and Settings Numbers
        //createClosetAndSettings()
        //configureView()
        
           }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if let unwrappedLook = selectedLook {
           
            //from tapped row
            println("From Somewhere")
            newLook = unwrappedLook
            
            //if from Calendar then selected date is not nil
            
            if let unwrappedLookDate = selectedLookDate {
                println("From Calendar")
            
              let dateWornSet = newLook.relationshipLookLookDates
//            var sortDescriptor = NSSortDescriptor(key: "dateWorn", ascending: false)
//            var dateWornSortedArray = dateWornSet.sortedArrayUsingDescriptors([sortDescriptor])
            
                timesWorn = "\(dateWornSet.count)"
                
            newLookDate = unwrappedLookDate
                
            } else {
            
                    //display last worn date
                let dateWornSet = newLook.relationshipLookLookDates
                var sortDescriptor = NSSortDescriptor(key: "dateWorn", ascending: false)
                var dateWornSortedArray = dateWornSet.sortedArrayUsingDescriptors([sortDescriptor])
                
                timesWorn = "\(dateWornSet.count)"
                
                newLookDate = dateWornSortedArray.first as! LookDates
            }
            
            var formatter = NSDateFormatter()
            formatter.dateFormat = "EEEE, MMMM d, yyyy"
            
            
            //lastWornDateLabel.text = "\(formatter.stringFromDate(lastLookDate.dateWorn))"
//            timesWorn = "\(dateWornSet.count)"
            
            
            // FIGURE OUT THE DATE STUFF LATER - CALENDAT VS. CLOSET, ETC.
            
            //            let entityDescription2 : NSEntityDescription! = NSEntityDescription.entityForName("LookDates", inManagedObjectContext: managedObjectContext)
            //
            //            newLookDate = LookDates(entity: entityDescription2, insertIntoManagedObjectContext: managedObjectContext)
            //
            //            newLookDate.dateWorn = NSDate()
            //            newLookDate.dateUpdated = NSDate()
            //            newLookDate.dateAdded = NSDate()
            //            newLookDate.dateOccasion = ""
            //
            //            newLookDate.relationshipLookDateLook = newLook
            
            
            
            //Set the Image
            if self.fileIsLocal(newLook.lookImageName) {
                println("Found \(newLook.lookImageName)")
                selfiePhoto = UIImage(named: getDocumentPathForFile(newLook.lookImageName))
                println("\(getDocumentPathForFile(newLook.lookImageName))")
                println(selfiePhoto?.description)
                haveSelfie = true
                
            } else {
                println("Not Found \(newLook.lookImageName)")
                
            }
            
            //favebutton
            faveButton.enabled = true
            
            if newLook.lookFave == true {
                
                faveButton.image = UIImage(named: "heart-full")
                faveButton.tag = 1
                
                println("It's a Fave")
                
            }
//            else if newLook.lookFave == fa {
//                
//                newLook.lookFave = false
//                faveButton.image = UIImage(named: "heart-empty")
//                faveButton.tag = 0
//                
//                println("Not a Fave")
//                
//            }
            
            self.title = "Look No. \(newLook.lookNumber)"
            
        } else {

            if newLook == nil {
                println("New Look is Nil, Disable FAve Button")
                  faveButton.enabled = false
                selfiePhoto = nil
                haveSelfie = false
                selfiePhoto = UIImage(named: "aqua-crown")
                //self.title = "New Look"
            }
          
        }
        print(newLook)
        //looksArray = fetchLooks("")
        selfieTableView.reloadData()
        
        //self.navigationController!.navigationBar.barTintColor = UIColor(red: 0.62, green: 0.81, blue: 0.78, alpha: 0.2)
        //self.navigationController!.navigationBar.translucent = true
//      var image = UIImage(named: "navbar_back2")
//        self.navigationController!.navigationBar.setBackgroundImage(image,
//            forBarMetrics: .Default)
    }
    
    override func viewWillDisappear(animated: Bool) {
        if managedObjectContext.hasChanges {
            
            
            
            managedObjectContext.rollback()
            
        }
        println("VWD")
        
//        newLook = nil
//        newLookDate = nil
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}
