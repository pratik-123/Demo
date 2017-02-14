//
//  ConstantFuction.swift
//  Demo
//
//  Created by Bunty on 13/02/17.
//  Copyright © 2017 Bunty. All rights reserved.
//

import UIKit
import CoreData

let prefrence = UserDefaults.standard

func getDBContext() -> NSManagedObjectContext{
    var managedContext  : NSManagedObjectContext!
    if #available(iOS 10.0, *) {
        managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    else
    {
        managedContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    }
    return managedContext
}
