//
//  StudentVC.swift
//  FaceAnimoji
//
//  Created by Justin Peters on 2/18/21.
//  Copyright © 2021 ashutosh.dingankar. All rights reserved.
//

import UIKit
import CoreData

class StudentVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    

    @IBOutlet weak var studentSearch: UISearchBar!
    
    @IBOutlet weak var studentList: UITableView!
    
    var BaseFunc = BaseFunctions()
    
    var mainMenu:MainMenuVC?
    
    var studentArray:[StudentData] = []
    
    var teacher:TeacherData?
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let defaults = UserDefaults.standard
    
    var searching = false
    
    var studentSearchArray:[StudentData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTable()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addStudent(_ sender:UIButton){
        BaseFunc.Feedback()
        
        var fullNameFeild : UITextField?
       // var lastNameFeild : UITextField?
        
        let dialogMessage = UIAlertController(title: "Add new student", message: "Please provide student full name", preferredStyle: .alert)
        
        let enter = UIAlertAction(title: "Enter", style: .default, handler: {
            (ACTION) -> Void in
            
            let full = fullNameFeild?.text
           // let last = lastNameFeild?.text
            
            if (full != ""){
                self.createStudent(fullName: full!)
            }
            else{
                return
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel){
            (ACTION) in
            print("Cancel called")
        }
        
        dialogMessage.addAction(enter)
        dialogMessage.addAction(cancel)
        
        dialogMessage.addTextField{(textFeild) in
            fullNameFeild = textFeild
            textFeild.placeholder = "Enter full name"
        }
        
//        dialogMessage.addTextField{(textFeild) in
//            lastNameFeild = textFeild
//            textFeild.placeholder = "Enter last name"
//        }
        
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    func createStudent(fullName: String){
        
        let newStudent = StudentData(context: self.context)
        
        newStudent.setValue(fullName, forKeyPath: "fullName")
        //newStudent.setValue(last, forKey: "lastName")
        newStudent.setValue(0, forKey: "points")
        newStudent.setValue("white", forKey: "lastUsedMask")
        newStudent.setValue(teacher!, forKey: "teacher");
        
        updateTeacher(student: newStudent)
        
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        updateTable()
    }
    
    func updateTeacher(student: StudentData){
        teacher!.setValue(student.fullName!, forKey: "selectedStudent")
    }
    
    func updateTable(){
        
        print("Updating table")
        
        let request = StudentData.fetchRequest() as NSFetchRequest<StudentData>

        let predString = "teacher == %@"

        let pred = NSPredicate(format: predString, teacher!)

        request.predicate = pred

        do{
            studentArray = try context.fetch(request)
        }
        catch{
            print("Unable to retrive data")
        }
    }
    
    @IBAction func backBtn(_ sender:UIButton){
        BaseFunc.Feedback()
        mainMenu!.loadStudentName()
        self.dismiss(animated: true, completion: nil)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let student = studentArray[indexPath.row]
        updateTeacher(student: student)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            print("Searching")
            return studentSearchArray.count
        }
        return studentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        var student = studentArray[indexPath.row]
        
        if searching{
            student = studentSearchArray[indexPath.row]
        }
        
        cell?.textLabel?.text = student.fullName
        return cell!
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete{
//            let student = studentArray[indexPath.row]
//            context.delete(student)
//            updateTable()
//        }
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        studentSearchArray = studentArray.filter({$0.fullName!.prefix(searchText.count) == searchText})
        searching = true
        studentList.reloadData()
    }
}
