//
//  StatementVC.swift
//  FaceAnimoji
//
//  Created by Justin Peters on 3/8/21.
//  Copyright © 2021 ashutosh.dingankar. All rights reserved.
//

import UIKit
import Dispatch

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
    
    var emotions:[String] = []
    
    let url = URL(string: "http://vern.stage.vernai.com/analyze")
    
    let promptStart = "Create a sentance that has "
    
    var promptValue = ""
    
    var results:BaseResponse?
    
    var student:StudentData?
    
    var correcntResponces = 0
    
    var totalQuestions = 0
    
    var beginTime = clock()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginTime = clock()
        getResponse(textValue: "test")
    }
    
    func getResponse(textValue: String){
        let sem = DispatchSemaphore.init(value: 0)
        let json:[String: Any] = ["text": textValue]
        let jsonData = (try? JSONSerialization.data(withJSONObject: json))!
        
        var request = URLRequest(url: url!)
        request.setValue("XXXXX", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) {(data ,response ,error) in
            
            defer {sem.signal()}
            
            if let error = error{
                print("Error took place")
                print(error)
                return
            }
            guard let data = data else {return}

            do{
                let dataObject = try JSONDecoder().decode(BaseResponse.self, from: data)
                
                if(self.emotions.isEmpty){
                    self.populateEmotions(response: dataObject)
                }
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
        print(correcntResponces/totalQuestions)
        newEntry.setValue(percentRight, forKey: "sucessRate")
        
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func generatePrompt(){
        
        let currentVal = emotions.randomElement()!
        
        if(currentVal == promptValue || currentVal == "humor"){
            generatePrompt()
            return;
        }
        
        promptValue = currentVal
        
        promptLabel.text = promptStart + promptValue
    }
    
    func checkAwnser() -> Bool{
        
        getResponse(textValue: textBox.text)
        
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
    
    func populateEmotions(response:BaseResponse){
        for item in response.scores{
            emotions.append(item.name)
        }
        
        DispatchQueue.main.async{
            self.generatePrompt()
        }
    }
    
    @IBAction func backBtn(_ sender:UIButton){
        BaseFunc.Feedback()
        self.dismiss(animated: true, completion: nil)
        if(totalQuestions != 0){
            print("Content saved")
            saveSessionData()
        }
    }
    
    @IBAction func enterText(_ sender: UIButton) {
        totalQuestions += 1
        if(checkAwnser()){
            answerResponse.text = "Correct!"
            BaseFunc.Feedback()
            generatePrompt()
            textBox.text = ""
            correcntResponces += 1
        }
        else{
            answerResponse.text = "Try again."
        }
    }
    
}
