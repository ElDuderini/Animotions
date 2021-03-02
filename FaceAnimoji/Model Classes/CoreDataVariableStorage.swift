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
