//
//  Settings.swift
//  CluelessCloset
//
//  Created by Sonova Middleton on 8/10/15.
//  Copyright (c) 2015 supernova8productions. All rights reserved.
//

import Foundation
import CoreData

@objc(Settings)
class Settings: NSManagedObject {

    @NSManaged var imageNameCounter: NSNumber
    @NSManaged var lookNumberCounter: NSNumber

}
