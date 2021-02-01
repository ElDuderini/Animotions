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

class ShopDataConstruction {
    
    var faces : [NSManagedObject] = []
    
    let fm = FileManager.default
    
    let path = Bundle.main.resourcePath! + "/art.scnassets"
    
    var sceneArray : [String] = []
    
    var priceIncrese : Int = 0
    
    func populateData() {
        
        priceIncrese = 50
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ShopData")
        
        do {
            faces = try managedContext.fetch(fetchRequest)
            print("FetchedData")
            print(faces)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "ShopData", in: managedContext)!
        let face = NSManagedObject(entity: entity, insertInto: managedContext)
    
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
        
        for index in 0...sceneArray.count - 1{
            
            save(name: sceneArray[index], cost: Int32(priceIncrese), face: face)
            
            priceIncrese += priceIncrese;
        }
        
    }
    
    
    func save(name: String, cost: Int32, face: NSManagedObject) {
        
        face.setValue(name, forKeyPath: "name")
        face.setValue(false, forKey: "purchased")
        face.setValue(cost, forKey: "price")
        face.setValue(Date(), forKey: "dateCreated")
        
        do {
            try face.managedObjectContext?.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
