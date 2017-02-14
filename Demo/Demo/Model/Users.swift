//
//  Users.swift
//  Demo
//
//  Created by Bunty on 13/02/17.
//  Copyright © 2017 Bunty. All rights reserved.
//

import UIKit
import CoreData

class Users: NSObject {
    
    var userObj : [Users] = []
    var address : String = ""
    var city : String = ""
    var name : String = ""
    
    override init() {
        
    }

    init(address:String,city:String,name : String) {
        self.address = address
        self.city = city
        self.name = name
    }
    
    func setJsonData(jsonArray : NSArray){
        
        for i in 0..<jsonArray.count{
            let dic = (jsonArray.object(at: i)) as! NSDictionary
            guard let name = dic.value(forKey: "user_first_name") as? String else {
                print("error while retriving fist name")
                return
            }
            guard let address = dic.value(forKey: "address_name") as? String else {
                print("error while retriving address_name")
                return
            }
            guard let city = dic.value(forKey: "city") as? String else {
                print("error while retriving city")
                return
            }
            userObj.append(Users(address: address, city: city, name: name))
            insertRecord(address: address, city: city, name: name)
        }
    }
    
    func getUsers() -> [Users] {
        return userObj
    }
    
    
    func insertRecord(address:String , city : String , name : String) {
        let context = getDBContext()
        let entity =  NSEntityDescription.entity(forEntityName: "Student",in:context)
        
        let studData = NSManagedObject(entity: entity!,
                                       insertInto:context)
        
        studData.setValue(address, forKey: "address")
        studData.setValue(city, forKey: "city")
        studData.setValue(name, forKey: "name")
        do {
            try context.save()
            //  print("succedd...")
        } catch _ {
            print("failed...")
        }
    }
    
    func selectRecord(){

        let context = getDBContext()
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Student")
        
        do {
            let results = try context.fetch(request)
            
            for i in 0..<results.count
            {
                let dictionary = results[i] as AnyObject
                
                guard let name = dictionary.value(forKey: "name") as? String else {
                    print("name get error")
                    return
                }
                guard let address = dictionary.value(forKey: "address") as? String else {
                    print("name get error")
                    return
                }
                guard let city = dictionary.value(forKey: "city") as? String else {
                    print("name get error")
                    return
                }
                userObj.append(Users(address: address, city: city, name: name))
            }
        } catch {
            
            print("Error with request: \(error)")
        }
    }
    
    
    //Delete record with predicate
    func deleteRecord()
    {
        let context = getDBContext()
        let predicate = NSPredicate(format: "question == %@ && chapter == %@", "test","test")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Study")
        fetchRequest.predicate = predicate
        
        do {
            let fetchedEntities = try context.fetch(fetchRequest) //as! [Study]
            for entity in fetchedEntities {
                context.delete(entity as! NSManagedObject)
            }
        } catch {
            // Do something in response to error condition
        }
        
        do {
            try context.save()
        } catch {
            // Do something in response to error condition
        }
    }
    
    // MARK: ReadQuery form Core Data with predicate
    func getHistoryFromjson(){
        
        let context = getDBContext()
        
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Test")
        let predicate = NSPredicate(format: "test_type_id == %@ && section_id == %@ &&  chep_id == %@", "test","test","test")
        
        // Set the predicate on the fetch request
        fetchRequest.predicate = predicate
        do
        {
            let fetchedResults =  try context.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults
            {
                print(results)
            }
        }
        catch _ {
            print("Could not fetch")
        }
    }
}
