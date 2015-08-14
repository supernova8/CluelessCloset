//
//  CarouselViewController.swift
//  CluelessCloset
//
//  Created by Sonova Middleton on 8/13/15.
//  Copyright (c) 2015 supernova8productions. All rights reserved.
//

import UIKit
import CoreData
import CoreMotion
import AVFoundation
import AudioToolbox


class CarouselViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout   {

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedObjectContext:NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var looksArray = [Looks]()
    var lastRandomNum = Int?()
    
    @IBOutlet var looksCollectionView :UICollectionView!
    @IBOutlet private var shuffleBarButtonItem :UIBarButtonItem!
    
    let systemSoundID: SystemSoundID = 1109
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Core Methods
    
    func fetchLooks() -> [Looks] {
        println("Fetch")
        
        //var searchString = lookSearchBar.text
        
        let fetchRequest :NSFetchRequest = NSFetchRequest(entityName: "Looks")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lookNumber", ascending: true), NSSortDescriptor(key: "lookName", ascending:true)]
        
//        if count(searchString) > 0 {
//            
//            if searchString.capitalizedString == "Fave" || searchString.capitalizedString == "Fav" || searchString.capitalizedString == "Favorite" {
//                
//                println("Fave!!")
//                
//                let predicate = NSPredicate(format: "lookFave == 1")
//                
//                fetchRequest.predicate = predicate
//                
//            } else {
//                
//                let predicate = NSPredicate(format: "lookTags contains[cd] %@ or lookName contains[cd] %@ or lookAccessoryType contains[cd] %@ or lookBottomType contains[cd] %@ or lookDressType contains[cd] %@ or lookNumber contains[cd] %@ or lookOuterwearType contains[cd] %@ or lookSeason contains[cd] %@ or lookShoeType contains[cd] %@ or lookTopType contains[cd] %@", searchString, searchString, searchString, searchString, searchString, searchString, searchString, searchString, searchString, searchString)
//                
//                fetchRequest.predicate = predicate
//                
//            }
            //fetchRequest.predicate = predicate
        //}
        //var predicate = NSPredicate.
        
        return managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as! [Looks]
        
    }

    func getDocumentPathForFile(filename: String) -> String {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        //NSTemporaryDirectory() // temp directory
        return  documentsPath.stringByAppendingPathComponent(filename)
        
        
    }

    //MARK: - interactivity
    
    @IBAction func faveButtonTapped(sender: AnyObject) {
        println("Fave Button Tapped")
        
        let textFieldPosition = sender.convertPoint(CGPointZero, toView: looksCollectionView)
        if let indexPath = looksCollectionView.indexPathForItemAtPoint(textFieldPosition) {
        
            
            
            //let cell = looksTableView.cellForRowAtIndexPath(indexPath!)
            
            
            //if let indexPath = lookToFaveIndexPath {
            println("Look To Fave")
            
            
            let lookToFave = self.looksArray[indexPath.row]
            
            if lookToFave.lookFave == false {
                lookToFave.lookFave = true
            } else if lookToFave.lookFave == true {
                lookToFave.lookFave = false
            }
            
            appDelegate.saveContext()
            looksCollectionView.reloadItemsAtIndexPaths([indexPath])
            //looksTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            
            
        }
        
    }

    @IBAction func shuffleButtonTapped(sender: AnyObject) {
        
        var randomNum = Int(arc4random_uniform(UInt32(looksArray.count)))
        
        println("YourRandom Number: \(randomNum)")
        
        if (lastRandomNum == nil) {
            lastRandomNum = randomNum
            
        } else { //Have a lastRandomNum
            
            while (lastRandomNum == randomNum) {
                
                randomNum = Int(arc4random_uniform(UInt32(looksArray.count)))
                
                println("Your Last Random Number: \(lastRandomNum)")
                println("Your New Random Number: \(randomNum)")
            }// while loop
            
        } //else loop
        
        // shuffle stuff here
        let cViewIndexPath = NSIndexPath(forRow: randomNum, inSection: 0)
        
        looksCollectionView.scrollToItemAtIndexPath(cViewIndexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
        
        AudioServicesPlaySystemSound (systemSoundID)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        //near end
        lastRandomNum = randomNum
        
    }
    
    //MARK: - Shake Methods
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        if motion == .MotionShake {
            println("shaking")
            self.shuffleButtonTapped(self)
            
        }
    }
    
@IBAction func wearAgainButtonTapped(sender: AnyObject) {
    
    println("Wear It Again Button Tapped")
    
    let textFieldPosition = sender.convertPoint(CGPointZero, toView: looksCollectionView)
    //if let indexPath = looksCollectionView.indexPathForItemAtPoint(textFieldPosition) {
    if let indexPath = looksCollectionView.indexPathsForVisibleItems().first as? NSIndexPath  {
        
        
        
        //let cell = looksTableView.cellForRowAtIndexPath(indexPath!)
        
        
        //if let indexPath = lookToFaveIndexPath {
//        println("Look To Fave")
        
        
        let lookToWearAgain = self.looksArray[indexPath.row]
        
        let dateWornSet = lookToWearAgain.relationshipLookLookDates
        var sortDescriptor = NSSortDescriptor(key: "dateWorn", ascending: false)
        var dateWornSortedArray = dateWornSet.sortedArrayUsingDescriptors([sortDescriptor])
        
        var lastLookDate = dateWornSortedArray.first as! LookDates
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        
        //lastWornDateLabel.text = "\(formatter.stringFromDate(lastLookDate.dateWorn))"
        var timesWorn = "\(dateWornSet.count)"
        
        
        println("Last Worn: \(formatter.stringFromDate(lastLookDate.dateWorn))")
        
        let entityDescription2 : NSEntityDescription! = NSEntityDescription.entityForName("LookDates", inManagedObjectContext: managedObjectContext)
        
        var newLookDate = LookDates(entity: entityDescription2, insertIntoManagedObjectContext: managedObjectContext)
        
        newLookDate.dateWorn = NSDate()
        newLookDate.dateUpdated = NSDate()
        newLookDate.dateAdded = NSDate()
        newLookDate.dateOccasion = ""
        
        newLookDate.relationshipLookDateLook = lookToWearAgain
        
        appDelegate.saveContext()
        looksCollectionView.reloadItemsAtIndexPaths([indexPath])
        
        //looksTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        
        
    }

    
    }
    
    
    //MARK: - Collection View Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return looksArray.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell :CarouselCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cCell", forIndexPath: indexPath) as! CarouselCollectionViewCell
        
        let currentLook = looksArray[indexPath.row]
        cell.lookNumberLabel!.text = "Look No. \(currentLook.lookNumber)"
        
        cell.lookNameLabel!.text = currentLook.lookName
        //cell.seasonLabel!.text = "Season: \(currentLook.lookSeason)"
        
        
        let dateWornSet = currentLook.relationshipLookLookDates
        var sortDescriptor = NSSortDescriptor(key: "dateWorn", ascending: false)
        var dateWornSortedArray = dateWornSet.sortedArrayUsingDescriptors([sortDescriptor])
        
        var lastLookDate = dateWornSortedArray.first as! LookDates
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        
        //lastWornDateLabel.text = "\(formatter.stringFromDate(lastLookDate.dateWorn))"
        var timesWorn = "\(dateWornSet.count)"
        
        
        cell.lastWornLabel.text = "Last Worn: \(formatter.stringFromDate(lastLookDate.dateWorn))"
        
        
        //cell.timesWornLabel!.text = "Time Worn: \(timesWorn)"
        
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
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(435, 535)
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
       performSegueWithIdentifier("editToDetailSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destController = segue.destinationViewController as! SelfieViewController
        
        //var x = 1 as Float // same as this
        if segue.identifier == "editToDetailSegue" {
            
            let indexPath = looksCollectionView.indexPathsForSelectedItems()[0] as! NSIndexPath
            let currentLook = looksArray[indexPath.row]
            destController.selectedLook = currentLook
            looksCollectionView.deselectItemAtIndexPath(indexPath, animated: true)
            
        }
        
            if segue.identifier == "addToDetailSegue" {
            destController.selectedLook = nil
            
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext:NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        //looksCollectionView.registerClass(UICollectionViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        looksArray = fetchLooks()
        looksCollectionView.reloadData()

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
