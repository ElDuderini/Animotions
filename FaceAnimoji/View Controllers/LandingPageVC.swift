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
    
    var baseFunc = BaseFunctions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissKeyboard()
        
        passwordField.isSecureTextEntry = true
        
        baseFunc.setUpBackground(view: self.view, imageName: "LogInScreen")
        
        //If the defaults for the user are null, then give them a default value
        if(!isKeyPresentInDefaults(key: "audioOn")){
            defaults.set(true, forKey: "audioOn")
        }
        
        if(!isKeyPresentInDefaults(key: "hapticOn")){
            defaults.set(true, forKey: "hapticOn")
        }

    }
    
    //Check to see if a teacher exists or not
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
    
    //Add a new teacher to coreData
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
    
    //Let the user know what they need to do to log in
    func warningMessage(message: String){
        usernameField.text = nil
        passwordField.text = nil
        
        usernameField.placeholder = message
        passwordField.placeholder = message
    }
    
    //When the user tries to log in, perform various checks
    @IBAction func enterBtn(_ sender: UIButton) {
        baseFunc.Feedback()
        
        //Check to see if the user is logging in or registering a new teacher
        //If you are logging in
        if(entryTypeToggle.selectedSegmentIndex == 0){
            //Check to see if the text is empty for both text feilds
            if(usernameField.text != "" && passwordField.text != ""){
                //If the teacher is found, then contine
                if(searchTeacher() == true){
                    //Check to see if the password is correct. Login if matches
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
        //Similar the the prior check. This is for registering a new teacher
        else if(entryTypeToggle.selectedSegmentIndex == 1){
            print("Register")
            
            if(usernameField.text != "" && passwordField.text != ""){
                
                //If a teacher doesn't exist, then create a new teacher and login
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
    
    //Check to see if a userDefault object exists
    func isKeyPresentInDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    //Send teacher data to mainMenu
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "destinationVC"){
            let destinationVC:MainMenuVC = segue.destination as! MainMenuVC
            
            destinationVC.teacher = teachers[0]
        }
    }
}
