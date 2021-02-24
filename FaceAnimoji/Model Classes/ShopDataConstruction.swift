//
//  ShopDataConstruction.swift
//  FaceAnimoji
//
//  Created by Justin Peters on 1/26/21.
//  Copyright © 2021 ashutosh.dingankar. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ShopDataConstruction{
    
    let fm = FileManager.default
    
    let path = Bundle.main.resourcePath! + "/art.scnassets"
    
    var sceneArray : [String] = []
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items:[ShopData] = []
    
    var priceIncrese : Int = 0
    
    var priceIncrement = 50
    
    func populateData(studentData:StudentData) {
        
        priceIncrese = 50
        
        do{
            let files = try fm.contentsOfDirectory(atPath: path)
            sceneArray = files
        }
        catch let error{
            print(error.localizedDescription)
        }
        
        sceneArray = sceneArray.filter{
            word in return word.contains(".scn")
        }
        
        for index in 0...sceneArray.count - 1{
            sceneArray[index] = sceneArray[index].replacingOccurrences(of: ".scn", with: "")
        }
        
        sceneArray.sort()
        
        for index in 0...sceneArray.count - 1{
            
            let request = ShopData.fetchRequest() as NSFetchRequest<ShopData>
            
            let predString = "name == '" + sceneArray[index] + "' && student == %@"
            
            let pred = NSPredicate(format: predString, studentData)
            request.predicate = pred
            
            do{
                items = try context.fetch(request)
            }
            catch{
                print("Unable to retrive data")
            }
            
            if(items.isEmpty){
                save(name: sceneArray[index], cost: Int64(Int32(priceIncrese)), studentData: studentData)
                print("New entry created for " + sceneArray[index])
            }
            else{
                print("Dupe prevented for " + sceneArray[index])
            }
            
            priceIncrese += priceIncrement;
        }
        
    }
    
    func save(name: String, cost: Int64, studentData: StudentData) {
        
        let newFace = ShopData(context: self.context)
        
        newFace.setValue(name, forKeyPath: "name")
        newFace.setValue(false, forKey: "purchased")
        newFace.setValue(cost, forKey: "price")
        newFace.setValue(Date(), forKey: "dateCreated")
        newFace.setValue(studentData, forKey: "student")
        
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteData(){
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = ShopData.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        let persistantContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        
        do{
            try persistantContainer.viewContext.execute(deleteRequest)
            print("Deleted items")
        }
        catch{
            print("Unable to delete items")
        }
    }
}
