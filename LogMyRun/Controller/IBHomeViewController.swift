//
//  IBHomeViewController.swift
//  LogMyRun
//
//  Created by Issam on 18/07/15.
//  Copyright © 2015 codemysource. All rights reserved.
//

import UIKit
import CoreData

class IBHomeViewController: UIViewController {

    var managedObjectContext : NSManagedObjectContext?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(IBNewRunViewController) {
            if let newRunVC = segue.destinationViewController as? IBNewRunViewController {
                newRunVC.managedObjectContext = managedObjectContext
            }
        }
    }
    
    
    
}
