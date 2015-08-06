//
//  Looks.swift
//  CluelessCloset
//
//  Created by Sonova Middleton on 8/5/15.
//  Copyright (c) 2015 supernova8productions. All rights reserved.
//

import Foundation
import CoreData

// have to do this below to make it compatible!!
@objc(Looks)

class Looks: NSManagedObject {

    @NSManaged var lookNumber: NSNumber
    @NSManaged var lookName: String
    @NSManaged var lookImageName: String
    @NSManaged var lookSeason: NSNumber
    @NSManaged var lookFave: NSNumber
    @NSManaged var lookTopType: NSNumber
    @NSManaged var lookBottomType: NSNumber
    @NSManaged var lookDressType: NSNumber
    @NSManaged var lookOuterwearType: NSNumber
    @NSManaged var lookShoeType: NSNumber
    @NSManaged var lookAccessoryType: NSNumber
    @NSManaged var lookTags: String
    @NSManaged var lookArchive: NSNumber
    @NSManaged var dateUpdated: NSDate
    @NSManaged var dateAdded: NSDate
    @NSManaged var relationshipLookLookDates: NSSet
    @NSManaged var relationshipLookCloset: Closets

}
