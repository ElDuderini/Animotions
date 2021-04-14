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
    
    var BaseFunc:BaseFunctions? = nil
    
    var shopData = ShopDataConstruction()
    
    var teachers:[TeacherData] = []
    
    var teacher:TeacherData?
    
    var students:[StudentData] = []
    
    var student:StudentData?
    
    @IBOutlet var mainMenuButtonArray: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if(!BaseFunc!.musicPlayer!.isPlaying){
            //BaseFunc!.StartMusic()
        //}
        //Set up the background
        BaseFunc!.setUpBackground(view: self.view, imageName: "BackgroundGreen")
        
        loadStudentName()
    }
    
    //This function is used to check to see what the currently selected student for the current teacher
    func loadStudentName(){
        //If the student is not null, then enable all the buttons that require a student to be selected and populate the shopData for the student
        if(teacher!.selectedStudent != nil && teacher!.selectedStudent != ""){
            currentStudentLabel.text = teacher!.selectedStudent
            for button in mainMenuButtonArray{
                button.isEnabled = true
            }
            getCurrentStudent()
            shopData.populateData(studentData: student!)
        }
        //If the value of the student is null, then let the teacher know they need to select/add a student. Disable the buttons that require a student
        else{
            currentStudentLabel.text = "Please create a student before playing"
            
            for button in mainMenuButtonArray{
                button.isEnabled = false
            }
        }
    }
    
    //If the selected student not null, then populate the student variable with studentData based on the currentTeacher and the selectedStudent of that teacher
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
    
    //When changing scenes, transfer the student variable to the destination page
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
            destinationVC.baseFunc = BaseFunc
            break;
            
        case "lessonVC":
            let destinationVC:ARVC = segue.destination as! ARVC
            destinationVC.student = student
            destinationVC.baseFunc = BaseFunc!
            break;
            
        case "shopVC":
            let destinationVC:ShopVC = segue.destination as! ShopVC
            destinationVC.student = student
            break;
            
        case "optionsVC":
            let destinationVC:OptionsVC = segue.destination as! OptionsVC
            destinationVC.baseFunc = BaseFunc
            break;
            
        case "statementVC":
            let destinationVC:StatementVC = segue.destination as! StatementVC
            destinationVC.student = student
            break;
            
        default:
            break;
        }
    }
    
    
    //If any button is pressed, play the feedback to the user
    @IBAction func ButtonPress(){
        BaseFunc!.Feedback()
    }
    
    //Log out of the current teacher
    @IBAction func logOutBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        BaseFunc!.Feedback()
    }
}
