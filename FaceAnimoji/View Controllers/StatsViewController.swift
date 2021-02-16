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
            var sucessRate : Double = 0
            var totalQuestions = 0
            
            for freeplay in freeplayItems{
                totalQuestions += Int(freeplay.questionsAnswered)
                sucessRate += freeplay.sucessRate
            }
            
            sucessRate = sucessRate/Double(freeplayItems.count)
            
            accuracyLabel.text = accuracyText + String(sucessRate) + "%"
            freeplayQuestionsLabel.text = freeplayQuestionText + String(totalQuestions)
            
            setData(chart: freeplayChart)
        }
        // Do any additional setup after loading the view.
    }
    
    func generateChart(chart:LineChartView){
        
        chart.rightAxis.enabled = false
        chart.backgroundColor = .systemGreen
        chart.animate(yAxisDuration: 2)
        
        let yAxis = chart.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 15)
        yAxis.setLabelCount(5, force: false)
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .white
        yAxis.labelPosition = .outsideChart
        
        
        let xAxis = chart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .boldSystemFont(ofSize: 0)
        xAxis.labelTextColor = .white
        
    }
    
    
    func setData(chart:LineChartView){
        
        var entries = [ChartDataEntry]()
        var index = 1

        if(chart == freeplayChart){
            
            for data in freeplayItems{
                let xAxis = index
                index += 1
                
                let yAxis = Double(data.sucessRate)
                let entry = ChartDataEntry(x: Double(xAxis), y: yAxis)
                entries.append(entry)
            }

            let dataSet = LineChartDataSet(entries: entries, label: "Sucess rate %")
            dataSet.mode = .linear
            dataSet.drawCirclesEnabled = false
            dataSet.lineWidth = 2.8
            dataSet.drawFilledEnabled = true
            dataSet.drawValuesEnabled = false
            
            

            let data = LineChartData(dataSet: dataSet)

            freeplayChart.data = data
            
            let percentFormat = NumberFormatter()
            percentFormat.numberStyle = .percent
            percentFormat.percentSymbol = "%"
            
            freeplayChart.xAxis.valueFormatter = DefaultAxisValueFormatter(formatter: percentFormat )

        }
        else if(chart == lessonChart){
            
            for data in lessonItems{
                let xAxis = index
                index += 1
                
                let yAxis = Double(data.avgTimeForResponse)
                let entry = ChartDataEntry(x: Double(xAxis), y: yAxis)
                entries.append(entry)
            }
            
            let dataSet = LineChartDataSet(entries: entries, label: "Average response time in seconds")
            dataSet.mode = .linear
            dataSet.drawCirclesEnabled = false
            dataSet.lineWidth = 2.8
            dataSet.drawFilledEnabled = true
            dataSet.drawValuesEnabled = false

            let data = LineChartData(dataSet: dataSet)

            lessonChart.data = data
        }
    }
    
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        baseFunc.Feedback()
    }
    
    @IBAction func exportData(_ sender: Any){
        baseFunc.Feedback()
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        var file_name = "lessonData.csv"
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        var fileURL = path.appendingPathComponent(file_name)
        
        var csvLesson = "Session Number,Session Date,Questions Answered,Session Length,Average Response Time\n"
        
        var num = 0
        
        for lesson in lessonItems{
            num += 1
            csvLesson.append("\(num),\(df.string(from: lesson.sessionDate ?? Date())),\(lesson.questionsAnswered),\(lesson.timeSpent),\(lesson.avgTimeForResponse)\n")
        }
        
        do{
            try csvLesson.write(to: fileURL, atomically: true, encoding: .utf8)
            print("Exported Lessons")
        }
        catch{
            print("Unable to export lesson data")
        }
        
        file_name = "freePlayData.csv"
        fileURL = path.appendingPathComponent(file_name)
        
        var csvfreePlay = "Session Number,Session Date,Questions Answered,Session Length,Sucess Rate\n"
        
        num = 0
        
        for freeplay in freeplayItems{
            num += 1
            csvfreePlay.append("\(num),\(df.string(from: freeplay.sessionDate ?? Date() )),\(freeplay.questionsAnswered),\(freeplay.timeSpent),\(freeplay.sucessRate)\n")
        }
        
        do{
            try csvfreePlay.write(to: fileURL, atomically: true, encoding: .utf8)
            print("Exported Freeplay")
        }
        catch{
            print("Unable to export freeplay data")
        }
        
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
