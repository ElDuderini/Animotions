//
//  LandingPageVC.swift
//  FaceAnimoji
//
//  Created by Justin Peters on 2/18/21.
//  Copyright © 2021 ashutosh.dingankar. All rights reserved.
//

import UIKit
import CoreData

class LandingPageVC: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var entryTypeToggle: UISegmentedControl!
    
    var teachers:[TeacherData] = []
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordField.isSecureTextEntry = true
        
        // Do any additional setup after loading the view.
    }
    
    func searchTeacher() -> Bool{
        let request = TeacherData.fetchRequest() as NSFetchRequest<TeacherData>
        
        let predString = "username CONTAINS '" + usernameField.text!.uppercased() + "'"
        
        let pred = NSPredicate(format: predString)
        request.predicate = pred
        
        do{
            teachers = try context.fetch(request)
        }
        catch{
            print("Unable to retrive data")
        }
        
        if(teachers.isEmpty){
            print("No teachers found")
            return false
        }
        else{
            print("Teacher name " + usernameField.text!.uppercased() + " found!")
            return true
        }
    }
    
    func newTeacher() {
        
        let newTeach = TeacherData(context: self.context)
        
        newTeach.setValue(usernameField.text?.uppercased(), forKeyPath: "username")
        newTeach.setValue(passwordField.text, forKey: "password")
        
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        searchTeacher()
        teachers[0] = newTeach
    }
    
    func warningMessage(message: String){
        usernameField.text = nil
        passwordField.text = nil
        
        usernameField.placeholder = message
        passwordField.placeholder = message
    }
    
    @IBAction func enterBtn(_ sender: UIButton) {
        
        if(entryTypeToggle.selectedSegmentIndex == 0){
            
            if(usernameField.text != "" && passwordField.text != ""){
                
                if(searchTeacher() == true){
                    
                    if(teachers[0].password == passwordField.text!){
                        performSegue(withIdentifier: "destinationVC", sender: self)
                    }
                    else{
                        warningMessage(message: "Password isn't correct")
                    }
                }
                else{
                    warningMessage(message: "Username doesn't exist")
                }
            }
            else{
                warningMessage(message: "Make sure text boxes aren't empty")
            }
        }
        
        else if(entryTypeToggle.selectedSegmentIndex == 1){
            print("Register")
            
            if(usernameField.text != "" && passwordField.text != ""){
                
                if(searchTeacher() == false){
                    newTeacher()
                    performSegue(withIdentifier: "destinationVC", sender: self)
                }
                else{
                    warningMessage(message: "Username already exists")
                }
            }
            else{
                warningMessage(message: "Make sure text boxes aren't empty")
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "destinationVC"){
            let destinationVC:MainMenuVC = segue.destination as! MainMenuVC
            
            destinationVC.teacher = teachers[0]
        }
    }
}
