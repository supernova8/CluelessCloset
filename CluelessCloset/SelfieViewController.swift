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
    
    func fetchCloset() -> Closets {
        println("Fetch Image and Look Numbers")
        let fetchRequest :NSFetchRequest = NSFetchRequest(entityName: "Closets")
        
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lookNumber", ascending: true), NSSortDescriptor(key: "lookName", ascending:true)]
        
        var error :NSError?
        let fetchresults = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [Closets]
//        
//        if let fetchresultsArray = fetchresults {
//            let currentCloset = fetchresultsArray[0] as Closets
//            println("Return CLoset Name and Description: \(currentCloset.closetName), \(currentCloset.closetDescription)")
//            
//            return currentCloset
//        } else {
        
            println("Create New Closet, Name and Description")
            
            let entityDescription : NSEntityDescription! = NSEntityDescription.entityForName("Closets", inManagedObjectContext: managedObjectContext)
            
            var newCloset = Closets(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
            
            newCloset.closetName = "Default"
            newCloset.closetDescription = "The First Closet!"
            
            appDelegate.saveContext()
            println("New Closet Add")
            return newCloset
       // }
    }

    
    
    func fetchSettings() -> Settings {
        println("Fetch Image and Look Numbers")
        let fetchRequest :NSFetchRequest = NSFetchRequest(entityName: "Settings")
        
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lookNumber", ascending: true), NSSortDescriptor(key: "lookName", ascending:true)]
        
        var error :NSError?
        let fetchresults = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [Settings]
        
//        if let fetchresultsArray = fetchresults {
//            let currentSets = fetchresultsArray[0] as Settings
//            println("Return Image and Look Numbers: \(currentSets.imageNameCounter),  \(currentSets.lookNumberCounter)")
//            
//            return currentSets
//        } else {
        
            println("Create New Image and Look Numbers")
            
            let entityDescription : NSEntityDescription! = NSEntityDescription.entityForName("Settings", inManagedObjectContext: managedObjectContext)
            
            var newSetting = Settings(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
            
            newSetting.imageNameCounter = 1 as Int
            newSetting.lookNumberCounter = 1 as Int
            
            appDelegate.saveContext()
            println("New Setting Add")
            return newSetting
       // }
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
            photoCell.saveToCameraRollSwitch.addTarget(self, action: "saveToCameraRollSwitchChanged:", forControlEvents: UIControlEvents.ValueChanged)
            photoCell.selectionStyle = UITableViewCellSelectionStyle.None
            
            if (haveSelfie == false) {
                println("Have Selfie? \(haveSelfie)")
                photoCell.saveToCameraRollSwitch.userInteractionEnabled = false
                photoCell.saveToCameraRollLabel.textColor = UIColor.lightGrayColor()
                photoCell.saveToCameraRollView.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 0.5)
                //segControlCell.cellSegControl.enabled = false
            } else {
                println("Have Selfie? \(haveSelfie)")
                photoCell.saveToCameraRollSwitch.userInteractionEnabled = true
                photoCell.saveToCameraRollLabel.textColor = UIColor(red: 127/255, green: 188/255, blue: 163/255, alpha: 1)
                photoCell.saveToCameraRollView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)

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
                
                if (haveSelfie == false) {
                    println("Have Selfie? \(haveSelfie)")
                textFieldCell.userInteractionEnabled = false
                textFieldCell.cellTextField.textColor = UIColor.lightGrayColor()
                textFieldCell.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 0.5)
                textFieldCell.cellLabel.textColor = UIColor.lightGrayColor()
                } else {
                    println("Have Selfie? \(haveSelfie)")
                    textFieldCell.userInteractionEnabled = true
                    textFieldCell.cellTextField.textColor = UIColor.blackColor()
                    textFieldCell.backgroundColor = UIColor.whiteColor()
                    textFieldCell.cellLabel.textColor = UIColor.blackColor()
                }
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
                    labelCell.backgroundColor = UIColor.whiteColor()
                    labelCell.cellDateLabel.textColor = UIColor.blackColor()
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
                    segControlCell.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 0.5)
                    segControlCell.cellSegControl.enabled = false
                } else {
                    println("Have Selfie? \(haveSelfie)")
                    segControlCell.userInteractionEnabled = true
                    segControlCell.cellLabel.textColor = UIColor.blackColor()
                    segControlCell.backgroundColor = UIColor.whiteColor()
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
                    dblSegControlCell.backgroundColor = UIColor.whiteColor()
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
                tableView.reloadSections( theSet, withRowAnimation: UITableViewRowAnimation.None)
                
                
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
            return 350.0
        }
        }
        if indexPath.section == 1 {
            if infoFieldTypeArray[indexPath.row] == "datePickerCell" {
                return 200.0
            }
        }
        if indexPath.section == 2 {
            if detailFieldTypeArray[indexPath.row] == "textViewCell" {
                return 150.0
            } else if detailFieldTypeArray[indexPath.row] == "buttonCell" {
                return 75.0
            } else if detailFieldTypeArray[indexPath.row] == "dblSegControlCell" {
                return 100.0
            }

        }

        
        return 44.0
    }

    
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

    func saveToCameraRollSwitchChanged(camSwitch: UISwitch) {
       
        saveToCameraRoll = camSwitch.on
        
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
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                //selfiePhoto.contentMode = .ScaleAspectFit
                println("Picked An image")
                selfiePhoto = pickedImage
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
        
        var imageFileName = "image\(newLookImageNumber).png"
        
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
            //scaleImage
            UIImagePNGRepresentation(selfiePhoto).writeToFile(newImagePath, atomically: true)
            newLook.lookImageName = imageFileName
            //currentSettings.imageNameCounter = currentSettings.imageNameCounter.integerValue + 1
            
            if (saveToCameraRoll == true) {
                
                UIImageWriteToSavedPhotosAlbum(selfiePhoto, nil, nil, nil)
                println("Saved to Camera Roll")
                
            }
            appDelegate.saveContext()
            println("Save Image Add")
        }
        
    }
    func fileIsLocal(filename: String) -> Bool {
        var fileManager = NSFileManager.defaultManager()
        
        return fileManager.fileExistsAtPath(getDocumentPathForFile(filename))
        
        
    }
    
    
    
    //MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
         selfieTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
           }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if let unwrappedLook = selectedLook {
            
            //from tapped row
            println("From Somewhere")
            newLook = unwrappedLook
            
            let dateWornSet = newLook.relationshipLookLookDates
            var sortDescriptor = NSSortDescriptor(key: "dateWorn", ascending: false)
            var dateWornSortedArray = dateWornSet.sortedArrayUsingDescriptors([sortDescriptor])
            
            newLookDate = dateWornSortedArray.first as! LookDates
            
            var formatter = NSDateFormatter()
            formatter.dateFormat = "EEEE, MMMM d, yyyy"
            
            //lastWornDateLabel.text = "\(formatter.stringFromDate(lastLookDate.dateWorn))"
            timesWorn = "\(dateWornSet.count)"
            
            
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
                
                println("Now a Fave")
                
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
//                self.title = "New Look"
            }
          
        }
        
        //looksArray = fetchLooks("")
        selfieTableView.reloadData()
        

      
        
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
