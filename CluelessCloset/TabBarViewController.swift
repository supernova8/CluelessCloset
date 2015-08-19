//
//  TabBarViewController.swift
//  CluelessCloset
//
//  Created by Sonova Middleton on 8/10/15.
//  Copyright (c) 2015 supernova8productions. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.selectedIndex = 2;
        
        // Do any additional setup after loading the view.
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        if item.tag == 2 && self.selectedIndex != 2 {
            println("\(item.title)")
            if let vControllers = self.viewControllers {
                let navVC = vControllers[2] as! UINavigationController
                let selfieVC = navVC.viewControllers![0] as! SelfieViewController
                selfieVC.newLook = nil
                selfieVC.selfiePhoto = nil
            }
            
            //[2] as! SelfieViewController
//            selectedVC.newLook = nil
        }
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
