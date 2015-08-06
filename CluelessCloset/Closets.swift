//
//  Closets.swift
//  CluelessCloset
//
//  Created by Sonova Middleton on 8/5/15.
//  Copyright (c) 2015 supernova8productions. All rights reserved.
//

import Foundation
import CoreData

// have to do this below to make it compatible!!
@objc(Closets)

class Closets: NSManagedObject {

    @NSManaged var closetName: String
    @NSManaged var closetDescription: String
    @NSManaged var dateAdded: NSDate
    @NSManaged var dateUpdated: String
    @NSManaged var relationshipClosetLooks: NSSet

}
