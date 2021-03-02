//
//  MainMenuVC.swift
//  FaceAnimoji
//
//  Created by Justin Peters on 1/19/21.
//  Copyright © 2021 ashutosh.dingankar. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class MainMenuVC: UIViewController {
    
    let defaults = UserDefaults.standard
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var currentStudentLabel: UILabel!
    
    var BaseFunc = BaseFunctions()
    
    var shopData = ShopDataConstruction()
    
    var teachers:[TeacherData] = []
    
    var teacher:TeacherData?
    
    var students:[StudentData] = []
    
    var student:StudentData?
    
    @IBOutlet var mainMenuButtonArray: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BaseFunc.setUpBackground(view: self.view, imageName: "BackgroundGreen")
        
        if(!isKeyPresentInDefaults(key: "audioOn")){
            defaults.set(true, forKey: "audioOn")
        }
        
        if(!isKeyPresentInDefaults(key: "hapticOn")){
            defaults.set(true, forKey: "hapticOn")
        }
        
        if(!isKeyPresentInDefaults(key: "points")){
            defaults.set(0, forKey:"points")
        }
        
        loadStudentName()
    }
    
    func loadStudentName(){
        if(teacher!.selectedStudent != nil && teacher!.selectedStudent != ""){
            currentStudentLabel.text = teacher!.selectedStudent
            for button in mainMenuButtonArray{
                button.isEnabled = true
            }
            getCurrentStudent()
            shopData.populateData(studentData: student!)
        }
        else{
            currentStudentLabel.text = "Please create a student before playing"
            
            for button in mainMenuButtonArray{
                button.isEnabled = false
            }
        }
    }
    
    func getCurrentStudent(){
        print("Updating table")
        
        let request = StudentData.fetchRequest() as NSFetchRequest<StudentData>

        let predString = "teacher == %@ && fullName == '" + currentStudentLabel.text! + "'"

        let pred = NSPredicate(format: predString, teacher!)

        request.predicate = pred

        do{
            students = try context.fetch(request)
        }
        catch{
            print("Unable to retrive data")
        }
        
        student = students[0]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "studentVC" :
            let destinationVC:StudentVC = segue.destination as! StudentVC
            destinationVC.teacher = teacher
            destinationVC.mainMenu = self
            break;
        
        case "statsVC" :
            let destinationVC:StatsViewController = segue.destination as! StatsViewController
            destinationVC.student = student
            break;
            
        case "freeplayVC":
            let destinationVC:FreePlayVC = segue.destination as! FreePlayVC
            destinationVC.student = student
            break;
            
        case "lessonVC":
            let destinationVC:ARVC = segue.destination as! ARVC
            destinationVC.student = student
            break;
            
        case "shopVC":
            let destinationVC:ShopVC = segue.destination as! ShopVC
            destinationVC.student = student
            break;
            
        default:
            break;
        }
    }
    
    @IBAction func ButtonPress(){
        BaseFunc.Feedback()
    }
    
    func isKeyPresentInDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    @IBAction func logOutBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        BaseFunc.Feedback()
    }
}
