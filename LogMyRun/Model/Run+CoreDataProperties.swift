//
//  Run+CoreDataProperties.swift
//  LogMyRun
//
//  Created by Issam on 18/07/15.
//  Copyright © 2015 codemysource. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Run {

    @NSManaged var distance: NSNumber?
    @NSManaged var duration: NSNumber?
    @NSManaged var timestamp: NSDate?
    @NSManaged var locations: NSOrderedSet?

}
