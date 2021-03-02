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
    
    //Need to set up checks for duplicate students in a future patch
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Populate the table
        updateTable()
        // Do any additional setup after loading the view.
    }
    
    //When the user pressed the "Add Student" button, then create a alert that allows the user to add a new student
    @IBAction func addStudent(_ sender:UIButton){
        BaseFunc.Feedback()
        
        var fullNameFeild : UITextField?
        
        let dialogMessage = UIAlertController(title: "Add new student", message: "Please provide student full name", preferredStyle: .alert)
        
        let enter = UIAlertAction(title: "Enter", style: .default, handler: {
            (ACTION) -> Void in
            
            let full = fullNameFeild?.text
            
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
        
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    //If the user adds a new student, then create a new studentEntry in studentData
    func createStudent(fullName: String){
        
        let newStudent = StudentData(context: self.context)
        
        newStudent.setValue(fullName, forKeyPath: "fullName")
        newStudent.setValue(0, forKey: "points")
        newStudent.setValue("white", forKey: "lastUsedMask")
        newStudent.setValue(teacher!, forKey: "teacher");
        
        //Set up the current teacher with a currentlySelected student based on this most recently made student
        updateTeacher(student: newStudent)
        //Save coreData
        saveContex()
        //Refesh table data
        updateTable()
    }
    
    //Method used to save coreData when setting, deleting and adding values
    func saveContex() {
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //Method used when updating the current student for the current teacher
    func updateTeacher(student: StudentData){
        teacher!.setValue(student.fullName!, forKey: "selectedStudent")
    }
    
    //Refresh data for the table, using a fetch request for all students the teacher has
    func updateTable(){
        
        print("Updating table")
        
        let request = StudentData.fetchRequest() as NSFetchRequest<StudentData>

        let predString = "teacher == %@"

        let pred = NSPredicate(format: predString, teacher!)

        request.predicate = pred

        do{
            studentArray = try context.fetch(request)
            
            print(studentArray)
        }
        catch{
            print("Unable to retrive data")
        }
    }
    
    //Load the student information when returning to the mainMenu
    @IBAction func backBtn(_ sender:UIButton){
        BaseFunc.Feedback()
        mainMenu!.loadStudentName()
        self.dismiss(animated: true, completion: nil)
    }
    
    //When touching a cell in the tableview, then update the currentStudent
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
//        if(searching){
//            let student = studentSearchArray[indexPath.row]
//            updateTeacher(student: student)
//        }
//        else{
            let student = studentArray[indexPath.row]
            updateTeacher(student: student)
        //}
    }
    
    //Set up the total number of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            print("Searching")
            return studentSearchArray.count
        }
        return studentArray.count
    }
    
    //When selecting the table, then set up what the current student is based on that
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        var student = studentArray[indexPath.row]
        
        if searching{
            student = studentSearchArray[indexPath.row]
        }
        
        cell?.textLabel?.text = student.fullName
        return cell!
    }
    
    //Set up the ability to edit a row in the table
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    //Set up edit actions for the teacher to use
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //Set up edit function that pops up a alert to change the students name
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            let alert = UIAlertController(title: "", message: "Change student name", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                if(self.searching){
                    textField.text = self.studentSearchArray[indexPath.row].fullName
                }
                else {
                    textField.text = self.studentArray[indexPath.row].fullName
                }
            })
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (updateAction) in
                if(self.searching){
                    self.studentSearchArray[indexPath.row].setValue(alert.textFields?.first?.text!, forKey: "fullName")
                    self.updateTeacher(student: self.studentSearchArray[indexPath.row])
                }
                else{
                    self.studentArray[indexPath.row].setValue(alert.textFields?.first?.text!, forKey: "fullName")
                    self.updateTeacher(student: self.studentArray[indexPath.row])
                }
                
                //Save the coreData
                self.saveContex()
                self.studentList.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: false)
        })
        
        //Set up action for deletion of a student. Putting up a alert for confirmation
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { [self] (action, indexPath) in
            var studentName:String
            if(searching){
                studentName = self.studentSearchArray[indexPath.row].fullName!
            }
            else{
                studentName = self.studentArray[indexPath.row].fullName!
            }
            let alert = UIAlertController(title: "", message: "Are you sure you want to delete " + studentName + "?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (updateAction) in
                if(searching){
                    
                    if(teacher?.selectedStudent == self.studentSearchArray[indexPath.row].fullName){
                        teacher!.setValue("", forKey: "selectedStudent")
                    }
                    
                    context.delete(self.studentSearchArray[indexPath.row])
                }
                else{
                    
                    if(teacher?.selectedStudent == self.studentArray[indexPath.row].fullName){
                        teacher!.setValue("", forKey: "selectedStudent")
                    }
                    
                    context.delete(self.studentArray[indexPath.row])
                }
                
                //Save the change to coreData
                self.saveContex()
                self.studentList.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: false)
        })

        return [deleteAction, editAction]
    }
    
    //When the user is using the search bar, change the table and toggle set the searching bool to true
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        studentSearchArray = studentArray.filter({$0.fullName!.prefix(searchText.count) == searchText})
        searching = true
        studentList.reloadData()
    }
}
