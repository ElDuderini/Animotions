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
    
    var priceIncrement = 100
    
    //This function is used to look into the files that were added as scenes and then add them to coreData
    func populateData(studentData:StudentData) {
        
        
        priceIncrese = 100
        
        getMaxValue(studentData: studentData)
        
        //Populate array with the files in the directory
        do{
            let files = try fm.contentsOfDirectory(atPath: path)
            sceneArray = files
        }
        catch let error{
            print(error.localizedDescription)
        }
        
        //Filter the array to only inculde files that have the .scn extension
        sceneArray = sceneArray.filter{
            word in return word.contains(".scn")
        }
        
        //For each element in the new array, remove the .scn portion of the file name with an empty value
        for index in 0...sceneArray.count - 1{
            sceneArray[index] = sceneArray[index].replacingOccurrences(of: ".scn", with: "")
        }
        
        //Sort the array alpabetically
        sceneArray.sort()
        
        //Set up a for loop that looks though the array
        for index in 0...sceneArray.count - 1{
            
            //Set up a fetch request for the currently selected student and name of the mask
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
            
            //If the fetch returns nothing, then create a new entry for the mask in shopData
            if(items.isEmpty){
                save(name: sceneArray[index], cost: Int64(Int32(priceIncrese)), studentData: studentData)
                print("New entry created for " + sceneArray[index])
                priceIncrese += priceIncrement
            }
            //If there is data, then do nothing. This prevents duplicate masks being added to the shop
            else{
                print("Dupe prevented for " + sceneArray[index])
            }
            
            //Increase the price by 50 for each new mask
           // priceIncrese += priceIncrement
        }
        
    }
    
    func getMaxValue(studentData:StudentData){
        let request = ShopData.fetchRequest() as NSFetchRequest<ShopData>
        request.fetchLimit = 1
        
        let sorter = NSSortDescriptor(key: "price", ascending: false)
        request.sortDescriptors = [sorter]
        
        let predString = "student == %@"
        
        let pred = NSPredicate(format: predString, studentData)
        request.predicate = pred
        
        do{
            items = try context.fetch(request)
            priceIncrese = Int(items.first?.price ?? 100)
        }
        catch{
            print("Unable to retrive data")
        }
    }
    
    //Save the new face information with default values
    func save(name: String, cost: Int64, studentData: StudentData) {
        
        let newFace = ShopData(context: self.context)
        
        newFace.setValue(name, forKeyPath: "name")
        
        if(name == "Girl" || name == "Boy"){
            newFace.setValue(true, forKey: "purchased")
            newFace.setValue(0, forKey: "price")
            priceIncrese -= priceIncrement
        }
        else{
            newFace.setValue(false, forKey: "purchased")
            newFace.setValue(cost, forKey: "price")
        }
        newFace.setValue(Date(), forKey: "dateCreated")
        newFace.setValue(studentData, forKey: "student")
        
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //This function was used for testing, deletes data from the array of shopdata without having to delete the app
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
