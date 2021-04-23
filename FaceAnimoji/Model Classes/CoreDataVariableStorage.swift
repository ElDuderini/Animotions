//
//  CoreDataVariableStorage.swift
//  FaceAnimoji
//
//  Created by Justin Peters on 2/22/21.
//  Copyright © 2021 ashutosh.dingankar. All rights reserved.
//

import Foundation
import UIKit
import CoreData


//This is an unused document for when I was trying to figure out the best way to transfer information between scenes. Found the prepare function was better for transfering variable values
class CoreDataVariableStorage{
    
    var students:[StudentData] = []
    var currentTeacher:TeacherData?
    
    let defaults = UserDefaults.standard
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func populateCurrentTeacher(teachEntry: TeacherData){
        
        currentTeacher = teachEntry
        
    }
    
    func populateStudentList(currentTeacher: TeacherData){
        
    }
    
    
}
