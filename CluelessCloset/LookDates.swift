//
//  LookDates.swift
//  CluelessCloset
//
//  Created by Sonova Middleton on 8/5/15.
//  Copyright (c) 2015 supernova8productions. All rights reserved.
//

import Foundation
import CoreData

// have to do this below to make it compatible!!
@objc(LookDates)

class LookDates: NSManagedObject {

    @NSManaged var dateWorn: NSDate
    @NSManaged var dateOccasion: String
    @NSManaged var dateAdded: NSDate
    @NSManaged var dateUpdated: NSDate
    @NSManaged var relationshipLookDateLook: Looks

}
