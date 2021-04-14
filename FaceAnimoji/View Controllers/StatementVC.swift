//
//  StatementVC.swift
//  FaceAnimoji
//
//  Created by Justin Peters on 3/8/21.
//  Copyright © 2021 ashutosh.dingankar. All rights reserved.
//

import UIKit
import Dispatch

//Create the structs that will be used to parse the Jston string with
struct BaseResponse : Decodable {
    let text: String
    let scores : [ScoreValues]
}

struct ScoreValues : Decodable {
    let name:String
    let value:Float
}

class StatementVC: UIViewController {

    var BaseFunc = BaseFunctions()
    
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var textBox: UITextView!
    @IBOutlet weak var answerResponse: UILabel!
    
    //This array is used to store information of the currently supported emotions/tones
    var emotions:[String] = []
    
    //URL to access the VERN API
    let url = URL(string: "http://vern.stage.vernai.com/analyze")
    
    //The starting prompt for the child to respond to
    let promptStart = "Create a sentance that has "
    
    var promptValue = ""
    
    //A connection needed to parse the json string
    var results:BaseResponse?
    
    //Connection to student data to record session data
    var student:StudentData?
    
    //Values needed to record how many right and wrong anwnsers there were
    var correcntResponces:Double = 0
    var totalQuestions:Double = 0
    
    //Used to track how long the session lasts
    var beginTime = clock()
    
    //Needed to connect to the database
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up the background image for this view
        BaseFunc.setUpBackground(view: self.view, imageName: "BackgroundBlue")
        
        //Set up starting time for the clock
        beginTime = clock()
        
        //Send a message to the API to retrive info on what emotions are currenty supported
        getResponse(textValue: "test")
    }
    
    //This method reaches out to the API to get information about the statement the student wrote or to populate the emotions supported
    func getResponse(textValue: String){
        //This is required to make sure there is a delay till the download of information is complete
        let sem = DispatchSemaphore.init(value: 0)
        
        //populate the json string you want to send to the API
        let json:[String: Any] = ["text": textValue]
        let jsonData = (try? JSONSerialization.data(withJSONObject: json))!
        
        //Establish a request to the API using the data above and from the documentation
        var request = URLRequest(url: url!)
        request.setValue("4ZVOx63rWCo10XdervQdUhxzKNlft9FB:5PFmDN6jrR8KpI3wMrT1depx5pEZwCVqCslBZA2rcdnqALuUHKC54l4SIH9P0UTB", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        //Starts the web request to get data from the API
        let task = URLSession.shared.dataTask(with: request) {(data ,response ,error) in
            
            //Set up a signal to have the program delay to finish the download
            defer {sem.signal()}
            
            //Populate data variable if no errors are encountered
            if let error = error{
                print("Error took place")
                print(error)
                return
            }
            guard let data = data else {return}

            //Using the information, populate the values you get from the text value sent to the API
            do{
                let dataObject = try JSONDecoder().decode(BaseResponse.self, from: data)
                
                //If the emotions array is empty, then perform population of the values
                if(self.emotions.isEmpty){
                    self.populateEmotions(response: dataObject)
                }
                //If that array is not empty, then return the full results
                else{
                    self.results = dataObject
                }
            }
            catch let jsonErr{
                print("Error serializing Json:", jsonErr)
            }
        }
        
        task.resume()
        
        sem.wait()
    }
    
    //Save information about the session performance of the student
    //See other examples for a full explination of how this works
    func saveSessionData(){
        let newEntry = WritingData(context: self.context)
        
        newEntry.setValue(correcntResponces, forKeyPath: "questionsAnswered")
        newEntry.setValue(Date(), forKey: "sessionDate")
        
        let timeInController = Double(clock() - beginTime) / Double(CLOCKS_PER_SEC)
        newEntry.setValue(timeInController, forKey: "timeSpent")
        
        newEntry.setValue(student!, forKey: "student")
        
        let percentRight = (correcntResponces/totalQuestions) * 100
        print(correcntResponces)
        print(totalQuestions)
        print((correcntResponces/totalQuestions) * 100)
        newEntry.setValue(percentRight, forKey: "sucessRate")
        
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //Method used to generate a question for the student to respond to
    func generatePrompt(){
        
        let currentVal = emotions.randomElement()!
        
        //If selecting an element from the array randomly returns a privously used value or an undesired value, then call the method again and cancel the current instance of it
        if(currentVal == promptValue || currentVal == "humor" || currentVal == "incongruity"){
            generatePrompt()
            return;
        }
        
        //Populate the prompt value
        promptValue = currentVal
        
        //Populate the label text for the child to see
        promptLabel.text = promptStart + promptValue
    }
    
    //Method used to check if the user made a satisfactory statement
    func checkAwnser() -> Bool{
        
        //Get a response from the API based on the text the student wrote
        getResponse(textValue: textBox.text)
        
        //Create a for loop that checks for the prompt value, then checks to see if that prompt value goes over 51 points based on the API response
        for item in results!.scores{
            if(item.name == promptValue){
                print(item.value)
                if(item.value >= 51){
                    return true;
                }
            }
        }
        
        return false;
    }
    
    //Populate the emotions array using the response from the API
    func populateEmotions(response:BaseResponse){
        for item in response.scores{
            emotions.append(item.name)
        }
        
        DispatchQueue.main.async{
            self.generatePrompt()
        }
    }
    
    //Return to main menu and save session data
    @IBAction func backBtn(_ sender:UIButton){
        BaseFunc.Feedback()
        self.dismiss(animated: true, completion: nil)
        if(totalQuestions != 0){
            print("Content saved")
            saveSessionData()
        }
    }
    
    //Press the enter button to check if you got the right awnser
    @IBAction func enterText(_ sender: UIButton) {
        totalQuestions += 1
        //If the student got the right awnser, clear the text box, provide feedback, generate a new prompt and add points
        if(checkAwnser()){
            answerResponse.text = "Correct!"
            BaseFunc.Feedback()
            generatePrompt()
            textBox.text = ""
            correcntResponces += 1
            let addedPoints = student!.points + 30
            student!.setValue(addedPoints, forKey: "points")
        }
        //If the awnser is wrong, let the user know to try again
        else{
            answerResponse.text = "Try again."
        }
    }
    
}
