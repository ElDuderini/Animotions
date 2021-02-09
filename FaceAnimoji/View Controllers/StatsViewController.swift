//
//  StatsViewController.swift
//  FaceAnimoji
//
//  Created by Justin Peters on 2/2/21.
//  Copyright © 2021 ashutosh.dingankar. All rights reserved.
//

import UIKit
import CoreData
import Charts

class StatsViewController: UIViewController {

    
    @IBOutlet weak var avgResponseLabel: UILabel!
    
    @IBOutlet weak var lessonQuestionsLabel: UILabel!
    
    @IBOutlet weak var accuracyLabel: UILabel!
    
    @IBOutlet weak var freeplayQuestionsLabel: UILabel!
    
    @IBOutlet weak var lessonChart: LineChartView!
    
    @IBOutlet weak var freeplayChart: LineChartView!
    
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let baseFunc = BaseFunctions()
    
    
    var lessonItems = [LessonData]()
    var freeplayItems = [FreeplayData]()
    
    let avgResponseText = "Avg Response Time: "
    let lessonQuestionText = "Questions awnsered: "
    
    let accuracyText = "Response Accuracy: "
    let freeplayQuestionText = "Questions awnsered: "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lessonItems.removeAll()
        freeplayItems.removeAll()
        
        generateChart(chart: lessonChart)
        generateChart(chart: freeplayChart)
        
        do{
            lessonItems = try context.fetch(NSFetchRequest(entityName: "LessonData"))
        }
        catch{
            print("Unable to retrive lesson data")
        }
        
        if(lessonItems.isEmpty){
            avgResponseLabel.text = avgResponseText + "NA"
            lessonQuestionsLabel.text = lessonQuestionText + "NA"
        }
        else{
            var lessonResponseTime : Float = 0
            var totalQuestions = 0
            
            for lesson in lessonItems{
                totalQuestions += Int(lesson.questionsAnswered)
                lessonResponseTime += lesson.avgTimeForResponse
            }
            
            lessonResponseTime = lessonResponseTime/Float(lessonItems.count)
            lessonResponseTime = Float(round(1000 * lessonResponseTime)/1000)
            
            avgResponseLabel.text = avgResponseText + String(lessonResponseTime) + " seconds"
            lessonQuestionsLabel.text = lessonQuestionText + String(totalQuestions)
            
            setData(chart: lessonChart)
        }
        
        do{
            freeplayItems = try context.fetch(NSFetchRequest(entityName: "FreeplayData"))
        }
        catch{
            print("Unable to retrive freeplay data")
        }
        
        
        if(freeplayItems.isEmpty){
            accuracyLabel.text = accuracyText + "NA"
            freeplayQuestionsLabel.text = freeplayQuestionText + "NA"
        }
        else{
            var sucessRate : Float = 0
            var totalQuestions = 0
            
            for freeplay in freeplayItems{
                totalQuestions += Int(freeplay.questionsAnswered)
                sucessRate += freeplay.sucessRate
            }
            
            sucessRate = sucessRate/Float(freeplayItems.count)
            
            accuracyLabel.text = accuracyText + String(sucessRate) + "%"
            freeplayQuestionsLabel.text = freeplayQuestionText + String(totalQuestions)
            
            setData(chart: freeplayChart)
        }
        // Do any additional setup after loading the view.
    }
    
    func generateChart(chart:LineChartView){
        chart.rightAxis.enabled = false
        chart.backgroundColor = .systemGreen
        
        let yAxis = chart.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 15)
        yAxis.setLabelCount(10, force: false)
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .white
        yAxis.labelPosition = .outsideChart
        
        let xAxis = chart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .boldSystemFont(ofSize: 15)
        xAxis.setLabelCount(10, force: false)
        xAxis.labelTextColor = .white
        
    }
    
    
    func setData(chart:LineChartView){
        
//        var yValues:[ChartDataEntry]
//        var intex = 0
//        
//        if(chart == freeplayChart){
//            for index freeplayItems.count{
//                
//            }
//        }
//        else if(chart == lessonChart){
//            for data in lessonItems{
//                
//            }
//        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        baseFunc.Feedback()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}