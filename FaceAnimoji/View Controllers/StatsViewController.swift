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
        //var referenceTimeInterval : TimeInterval = 0
        //var dateObjects = [Date]()
        var index = 1
        

        if(chart == freeplayChart){
            
            for data in freeplayItems{
                let xAxis = index
                index += 1
                
                let yAxis = Double(data.sucessRate)
                let entry = ChartDataEntry(x: Double(xAxis), y: yAxis)
                entries.append(entry)
            }
//
//            if(freeplayItems.count == 0){
//                return
//            }
//
//            for date in freeplayItems{
//                dateObjects.append(date.sessionDate ?? Date())
//            }
//
//            if let minTimeInterval = (dateObjects.map{$0.timeIntervalSince1970}).min() {
//                referenceTimeInterval = minTimeInterval
//            }
//
//            let formatter = DateFormatter()
//            formatter.dateStyle = .medium
//            formatter.timeStyle = .none
//            formatter.locale = Locale.current
//
//            let xValuesNumberFormatter = ChartAxisFormetter(referenceTimeInterval: referenceTimeInterval, dateFormatter: formatter)
//            freeplayChart.xAxis.valueFormatter = xValuesNumberFormatter
//
//            for index in 0...freeplayItems.count - 1{
//                let timeInterval = dateObjects[index].timeIntervalSince1970
//                let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
//
//                let yValue = Double(freeplayItems[index].sucessRate)
//                let entry = ChartDataEntry(x: xValue, y: yValue)
//                print(index)
//                entries.append(entry)
//            }
//
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
