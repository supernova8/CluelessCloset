//
//  SelfieViewController.swift
//  CluelessCloset
//
//  Created by Sonova Middleton on 8/4/15.
//  Copyright (c) 2015 supernova8productions. All rights reserved.
//

import UIKit
import CoreData


class SelfieViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedObjectContext:NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var selectedLook :Looks? //unwrapped so it can be nil
    private var newLook  :Looks! //not wrapped
    private var newLookDate  :LookDates! //not wrapped
    var currentSettings :Settings!
    
    var looksArray = [Looks]()

    var photoEntryFieldArray = ["Photo"]
    var photoFieldTypeArray = ["photoCell"]
    
    var infoEntryFieldArray = ["Name:","Occasion:","Season:","Date Worn:"]
    var infoFieldTypeArray = ["textFieldCell","textFieldCell","segControlCell","labelCell"]
    
    var detailEntryFieldArray = ["Top:","Bottom:","Dress:","Shoes:","Outerwear:","Accessories:","Tags:"]
    var detailFieldTypeArray = ["dblSegControlCell","dblSegControlCell","dblSegControlCell","dblSegControlCell","dblSegControlCell","dblSegControlCell","textViewCell"]
    
    var todayDate = NSDate()
    
    @IBOutlet var selfieTableView :UITableView!
    
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

    func fetchLooks(SearchText: String) -> [Looks] {
        println("Fetch")
        let fetchRequest :NSFetchRequest = NSFetchRequest(entityName: "Looks")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lookNumber", ascending: true), NSSortDescriptor(key: "lookName", ascending:true)]
        
        return managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as! [Looks]
        
    }
    
    func fetchSettings() -> Settings {
        println("Fetch Image and Look Numbers")
        let fetchRequest :NSFetchRequest = NSFetchRequest(entityName: "Settings")
        
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lookNumber", ascending: true), NSSortDescriptor(key: "lookName", ascending:true)]
        
        var error :NSError?
        let fetchresults = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [Settings]
        
//        if fetchresults == nil {
//            println("Create New Image and Look Numbers")
//            
//            let entityDescription : NSEntityDescription! = NSEntityDescription.entityForName("Settings", inManagedObjectContext: managedObjectContext)
//            
//            var newSetting = Settings(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
//            
//            newSetting.imageNameCounter = 1 as Int
//            newSetting.lookNumberCounter = 1 as Int
//            
//            appDelegate.saveContext()
//            
//            return newSetting
//        } else {
//            let currentSets = fetchresults![0] as Settings
//            println("Return Image and Look Numbers: \(currentSets.imageNameCounter),  \(currentSets.lookNumberCounter)")
//            
//            return currentSets
//        }
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
            
            return newSetting
        }
    }
    
//    func fetchLookNumber(SearchText: String) -> [Looks] {
//        println("Fetch")
//        let fetchRequest :NSFetchRequest = NSFetchRequest(entityName: "Looks")
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lookNumber", ascending: true), NSSortDescriptor(key: "lookName", ascending:true)]
//        
//        return managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as! [Looks]
//        
//    }
    
   
    //MARK: - TableView Methods
    
    //Sections
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
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
        
        //var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        if indexPath.section == 0 {
            
            var photoCell = tableView.dequeueReusableCellWithIdentifier("photoCell") as! PhotoTableViewCell
            //photoCell.lookImageView.image = UIImage(named:"iTunesArtwork")
            //photoCell.cameraButton.
            //photoCell.cellLabel.text = infoEntryFieldArray[indexPath.row]
            //photoCell.cellTextField.addTarget(self, action: "tableFieldChanged:", forControlEvents: UIControlEvents.EditingChanged)
            photoCell.selectionStyle = UITableViewCellSelectionStyle.None
            return photoCell
            
            
//            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:"cell")
//            let currentLook = looksArray[indexPath.row]
//            cell.textLabel!.text = currentLook.lookName
//            
//            var totalDates = 0
//            let dateWornSet = currentLook.relationshipLookLookDates
//            
//            for dateWorn in dateWornSet {
//                totalDates++
//            }
//
//            cell.detailTextLabel!.text = "\(totalDates)"
        
        } else if indexPath.section == 1 {
    
//            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:"cell")
//            let currentLook = looksArray[indexPath.row]
//            cell.textLabel!.text = currentLook.lookName
//            
//            var totalDates = 0
//            let dateWornSet = currentLook.relationshipLookLookDates
//            
//            for dateWorn in dateWornSet {
//            totalDates++
//            }
        
//            switch indexPath.row {
//            case 0,1:
//                var textFieldCell = tableView.dequeueReusableCellWithIdentifier("textFieldCell") as! TextFieldTableViewCell
//                textFieldCell.cellLabel.text = infoEntryFieldArray[indexPath.row]
//                textFieldCell.cellTextField.addTarget(self, action: "tableFieldChanged:", forControlEvents: UIControlEvents.EditingChanged)
//                return textFieldCell
//            case 2:
//                var segControlCell = tableView.dequeueReusableCellWithIdentifier("segControlCell") as! SegControlTableViewCell
//                segControlCell.cellLabel.text = infoEntryFieldArray[indexPath.row]
//                //seg control
//                
//                //segControlCell.cellSegControl = UISegmentedControl (items: ["First","Second","Third"])
//                //segControlCell.cellSegControl.frame = CGRectMake(60, 250,200, 30)
//                segControlCell.cellSegControl.removeAllSegments()
//                let tempArray = ["Fall","Winter","Spring", "Summer" ]
//                for season in tempArray {
//                    segControlCell.cellSegControl.insertSegmentWithTitle(season, atIndex: 0, animated: false)
//                }
//                segControlCell.cellSegControl.selectedSegmentIndex = 0
//                //segmentedControl.addTarget(self, action: "segmentedControlAction:", forControlEvents: .ValueChanged)
//                //self.view.addSubview(segControlCell.cellSegControl)
//                
//                
//                segControlCell.cellSegControl.addTarget(self, action: "tableFieldChanged:", forControlEvents: UIControlEvents.ValueChanged)
//                return segControlCell
//            case 3:
//                var labelCell = tableView.dequeueReusableCellWithIdentifier("labelCell") as! LabelTableViewCell
//                labelCell.cellLabel.text = infoEntryFieldArray[indexPath.row]
//                
//                var formatter = NSDateFormatter()
//                formatter.dateFormat = "EEEE, MMMM d, yyyy"
//                
//                labelCell.cellDateLabel.text = "\(formatter.stringFromDate(todayDate))"
//                
//               // labelCell.cellLabel.addTarget(self, action: "tableFieldChanged:", forControlEvents: UIControlEvents.ValueChanged)
//                return labelCell
//            case 4:
//                var datePickerCell = tableView.dequeueReusableCellWithIdentifier("datePickerCell") as! DatePickerTableViewCell
//                //datePickerCell.cellLabel.text = infoEntryFieldArray[indexPath.row]
//                datePickerCell.cellDatePickerView.date = NSDate()
//                //datePickerCell.cellDatePickerView.addTarget(self, action: "tableFieldChanged:", forControlEvents: UIControlEvents.ValueChanged)
//                return datePickerCell
//            default:
//                var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
//                return cell
//                }
            
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
                return textFieldCell
            case "labelCell":
                var labelCell = tableView.dequeueReusableCellWithIdentifier("labelCell") as! LabelTableViewCell
                labelCell.cellLabel.text = infoEntryFieldArray[indexPath.row]

                var formatter = NSDateFormatter()
                formatter.dateFormat = "EEEE, MMMM d, yyyy"

                labelCell.cellDateLabel.text = "\(formatter.stringFromDate(newLookDate.dateWorn))"
                labelCell.selectionStyle = UITableViewCellSelectionStyle.None
               // labelCell.cellLabel.addTarget(self, action: "tableFieldChanged:", forControlEvents: UIControlEvents.ValueChanged)
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
            
//            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:"cell")
//            let currentLook = looksArray[indexPath.row]
//            cell.textLabel!.text = currentLook.lookName
//            
//            var totalDates = 0
//            let dateWornSet = currentLook.relationshipLookLookDates
//            
//                for dateWorn in dateWornSet {
//                totalDates++
//                }
//            switch indexPath.row {
//            case 0,1,2,3,4,5,6,7,8,9,10,11:
//                var segControlCell = tableView.dequeueReusableCellWithIdentifier("segControlCell") as! SegControlTableViewCell
//                segControlCell.cellLabel.text = detailEntryFieldArray[indexPath.row]
//                //seg control
//                segControlCell.cellSegControl.addTarget(self, action: "tableFieldChanged:", forControlEvents: UIControlEvents.ValueChanged)
//                return segControlCell
//            case 12:
//                var textViewCell = tableView.dequeueReusableCellWithIdentifier("textViewCell") as! TextViewTableViewCell
//                textViewCell.cellLabel.text = detailEntryFieldArray[indexPath.row]
//                //textViewCell.cellTextView.addTarget(self, action: "tableFieldChanged:", forControlEvents: UIControlEvents.ValueChanged)
//                return textViewCell
//            case 13:
//                var buttonCell = tableView.dequeueReusableCellWithIdentifier("buttonCell") as! ButtonTableViewCell
//                //buttonCell.cellLabel.text = detailEntryFieldArray[indexPath.row]
//                buttonCell.saveButton.addTarget(self, action: "tableFieldChanged:", forControlEvents: UIControlEvents.ValueChanged)
//                return buttonCell
//            default:
//                var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
//                return cell
//            }

            switch detailFieldTypeArray[indexPath.row] {
            case "textViewCell":
                var textViewCell = tableView.dequeueReusableCellWithIdentifier("textViewCell") as! TextViewTableViewCell
                textViewCell.cellLabel.text = detailEntryFieldArray[indexPath.row]
                textViewCell.cellTextView.text = newLook.lookTags
                
                textViewCell.selectionStyle = UITableViewCellSelectionStyle.None
                return textViewCell
            case "buttonCell":
                var buttonCell = tableView.dequeueReusableCellWithIdentifier("buttonCell") as! ButtonTableViewCell
                //buttonCell.cellLabel.text = detailEntryFieldArray[indexPath.row]
                buttonCell.saveButton.addTarget(self, action: "tableFieldChanged:", forControlEvents: UIControlEvents.ValueChanged)
                buttonCell.selectionStyle = UITableViewCellSelectionStyle.None
                return buttonCell

            case "dblSegControlCell":
                
//                var segControlCell = tableView.dequeueReusableCellWithIdentifier("segControlCell") as! SegControlTableViewCell
//                segControlCell.cellLabel.text = infoEntryFieldArray[indexPath.row]
//                //seg control
//                
//                //segControlCell.cellSegControl = UISegmentedControl (items: ["First","Second","Third"])
//                //segControlCell.cellSegControl.frame = CGRectMake(60, 250,200, 30)
//                segControlCell.cellSegControl.removeAllSegments()
//                let tempArray = ["Fall","Winter","Spring", "Summer" ]
//                for season in tempArray {
//                    segControlCell.cellSegControl.insertSegmentWithTitle(season, atIndex: 0, animated: false)
//                }
//                segControlCell.cellSegControl.selectedSegmentIndex = 0
//                //segmentedControl.addTarget(self, action: "segmentedControlAction:", forControlEvents: .ValueChanged)
//                //self.view.addSubview(segControlCell.cellSegControl)
//                
//                
//                segControlCell.cellSegControl.addTarget(self, action: "tableFieldChanged:", forControlEvents: UIControlEvents.ValueChanged)
//                return segControlCell
                
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
        
        //appDelegate.saveContext()
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
    }
    
    func datePickerChanged(datepicker: UIDatePicker) {
        
        newLookDate.dateWorn = datepicker.date
        println("Date Worn: \(newLookDate.dateWorn)")
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
            
            
            
            
        } else {
            // it's Nil, an add so create it
            
            let entityDescription : NSEntityDescription! = NSEntityDescription.entityForName("Looks", inManagedObjectContext: managedObjectContext)
            let entityDescription2 : NSEntityDescription! = NSEntityDescription.entityForName("LookDates", inManagedObjectContext: managedObjectContext)
            
            
            newLook = Looks(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
            newLookDate = LookDates(entity: entityDescription2, insertIntoManagedObjectContext: managedObjectContext)
            
            
            //Record 1
            newLook.lookName = "Casual Chic"
            
            currentSettings = fetchSettings()
            
            newLook.lookNumber = currentSettings.lookNumberCounter
            currentSettings.lookNumberCounter = currentSettings.lookNumberCounter.integerValue + 1
            
            newLook.lookSeason = "Summer"
            
            newLook.lookAccessoryType = ""
            newLook.lookBottomType = ""
            newLook.lookDressType = ""
            newLook.lookOuterwearType = ""
            newLook.lookShoeType = ""
            newLook.lookTopType = "Other"
            newLook.lookTags = ""
            
            newLook.lookArchive = false
            newLook.lookFave = false
            
            //newLook.lookImageName = nil;
            
            newLook.dateAdded = NSDate()
            newLook.dateUpdated = NSDate()
            
            newLookDate.dateWorn = NSDate()
            newLookDate.dateUpdated = NSDate()
            newLookDate.dateAdded = NSDate()
            newLookDate.dateOccasion = "Out with the girls"
            
            newLookDate.relationshipLookDateLook = newLook
            
            println(newLook)
            
            
        }

        
        
        //looksArray = fetchLooks("")
        selfieTableView.reloadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}
