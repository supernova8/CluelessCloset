//
//  DetailViewController.swift
//  CluelessCloset
//
//  Created by Sonova Middleton on 8/5/15.
//  Copyright (c) 2015 supernova8productions. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    var selectedLook :Looks? //unwrapped so it can be nil
    private var currentLook  :Looks! //not wrapped

    
    @IBOutlet private var nameTextField         :UITextField!
    @IBOutlet var lastWornDateLabel             :UILabel!
    @IBOutlet var timesWornLabel                :UILabel!

    
    @IBAction func saveButtonPressed(sender: UIButton) {
        println("Save")
        
      
     }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let unwrappedLook = selectedLook {
            //from tapped row
            
            currentLook = unwrappedLook
            nameTextField.text = currentLook.lookName
            
            
            let dateWornSet = currentLook.relationshipLookLookDates
            var sortDescriptor = NSSortDescriptor(key: "dateWorn", ascending: false)
            var dateWornSortedArray = dateWornSet.sortedArrayUsingDescriptors([sortDescriptor])
            
            var lastLookDate = dateWornSortedArray.first as! LookDates
            
            var formatter = NSDateFormatter()
            formatter.dateFormat = "EEEE, MMMM d, yyyy"
            
            lastWornDateLabel.text = "\(formatter.stringFromDate(lastLookDate.dateWorn))"
            timesWornLabel.text = "\(dateWornSet.count)"
            
            
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
