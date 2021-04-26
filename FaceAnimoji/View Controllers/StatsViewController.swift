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
import UniformTypeIdentifiers

class StatsViewController: UIViewController, UIDocumentPickerDelegate, UIDocumentInteractionControllerDelegate {

    
    @IBOutlet weak var avgResponseLessonLabel: UILabel!
    
    @IBOutlet weak var lessonQuestionsLabel: UILabel!
    
    @IBOutlet weak var accuracyFreeplayLabel: UILabel!
    
    @IBOutlet weak var freeplayQuestionsLabel: UILabel!
    
    @IBOutlet weak var accuracyWritingLabel: UILabel!
    
    @IBOutlet weak var writingQuestionsLabel: UILabel!
    
    @IBOutlet weak var lessonChart: LineChartView!
    
    @IBOutlet weak var freeplayChart: LineChartView!
    
    @IBOutlet weak var writingChart:LineChartView!
    
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let baseFunc = BaseFunctions()
    
    
    var lessonItems = [LessonData]()
    var freeplayItems = [FreeplayData]()
    var writingItems = [WritingData]()
    
    let avgResponseText = "Avg Response Time: "
    let questionText = "Questions awnsered: "
    let accuracyText = "Response Accuracy: "
    
    var student:StudentData? = nil
    
    //This script utilizes a charts API, more documentation for it can be found here https://github.com/danielgindi/Charts
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseFunc.setUpParticles(View: self.view, Leaves: false)
        baseFunc.setUpBackground(view: self.view, imageName: "BackgroundBlue")
        
        //Clear arrays for repopulation later on
        lessonItems.removeAll()
        freeplayItems.removeAll()
        writingItems.removeAll()
        
        //Set up the charts for future use
        generateChart(chart: lessonChart)
        generateChart(chart: freeplayChart)
        generateChart(chart: writingChart)
        
        //Fetch request for lessonData to populate in a array
        let requestLesson = LessonData.fetchRequest() as NSFetchRequest<LessonData>
        
        let predString = "student == %@"
        
        let pred = NSPredicate(format: predString, student!)
        requestLesson.predicate = pred
        
        do{
            lessonItems = try context.fetch(requestLesson)
        }
        catch{
            print("Unable to retrive data")
        }
        
        //Check to see if the array is empty from the fetch request. If so, then let the user know that no data exists yet
        if(lessonItems.isEmpty){
            avgResponseLessonLabel.text = avgResponseText + "NA"
            lessonQuestionsLabel.text = questionText + "NA"
        }
        //If the array is not empty, then provide the user with information
        else{
            var lessonResponseTime : Float = 0
            var totalQuestions = 0
            
            for lesson in lessonItems{
                totalQuestions += Int(lesson.questionsAnswered)
                lessonResponseTime += lesson.avgTimeForResponse
            }
            
            lessonResponseTime = lessonResponseTime/Float(lessonItems.count)
            lessonResponseTime = Float(round(1000 * lessonResponseTime)/1000)
            
            avgResponseLessonLabel.text = avgResponseText + String(lessonResponseTime) + " seconds"
            lessonQuestionsLabel.text = questionText + String(totalQuestions)
            
            //As long as the data has more than one entry, then populate the chart
            if(lessonItems.count != 1){
                setData(chart: lessonChart)
            }
            
        }
        
        //This section is almost the same as the last fetch, refer to that example
        let requestFreeplay = FreeplayData.fetchRequest() as NSFetchRequest<FreeplayData>
        
        requestFreeplay.predicate = pred
        
        do{
            freeplayItems = try context.fetch(requestFreeplay)
        }
        catch{
            print("Unable to retrive data")
        }
        
        if(freeplayItems.isEmpty){
            accuracyFreeplayLabel.text = accuracyText + "NA"
            freeplayQuestionsLabel.text = questionText + "NA"
        }
        else{
            var sucessRate : Double = 0
            var totalQuestions = 0
            
            for freeplay in freeplayItems{
                totalQuestions += Int(freeplay.questionsAnswered)
                sucessRate += freeplay.sucessRate
            }
            
            sucessRate = sucessRate/Double(freeplayItems.count)
            sucessRate = Double(round(1000 * sucessRate)/1000)
            
            accuracyFreeplayLabel.text = accuracyText + String(sucessRate) + "%"
            freeplayQuestionsLabel.text = questionText + String(totalQuestions)
            
            if(freeplayItems.count != 1){
                setData(chart: freeplayChart)
            }
        }
        
        
        //This section is almost the same as the last fetch, refer to that example
        let requestWriting = WritingData.fetchRequest() as NSFetchRequest<WritingData>
        
        requestFreeplay.predicate = pred
        
        do{
            writingItems = try context.fetch(requestWriting)
        }
        catch{
            print("Unable to retrive data")
        }
        
        if(writingItems.isEmpty){
            accuracyWritingLabel.text = accuracyText + "NA"
            writingQuestionsLabel.text = questionText + "NA"
        }
        else{
            var sucessRate : Double = 0
            var totalQuestions = 0
            
            for writing in writingItems{
                totalQuestions += Int(writing.questionsAnswered)
                sucessRate += writing.sucessRate
            }
            
            sucessRate = sucessRate/Double(writingItems.count)
            sucessRate = Double(round(1000 * sucessRate)/1000)
            
            accuracyWritingLabel.text = accuracyText + String(sucessRate) + "%"
            writingQuestionsLabel.text = questionText + String(totalQuestions)
            
            if(writingItems.count != 1){
                setData(chart: writingChart)
            }
        }
    }
    
    //Set the chart styling
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
    
    //Set the data for the charts
    func setData(chart:LineChartView){
        
        var entries = [ChartDataEntry]()
        var index = 1
        
        //if the chart is for freeplay, then set up entries unique to that chart
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
        //if the chart is for lesson, then set up entries unique to that chart
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
        else if(chart == writingChart){
            
            for data in writingItems{
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

            writingChart.data = data
            
            let percentFormat = NumberFormatter()
            percentFormat.numberStyle = .percent
            percentFormat.percentSymbol = "%"
            
            writingChart.xAxis.valueFormatter = DefaultAxisValueFormatter(formatter: percentFormat )

        }
    }
    
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        baseFunc.Feedback()
    }
    
    //Call this method to export lesson and freeplay data for the student associated with a particular teacher
    @IBAction func exportData(_ sender: Any){
        baseFunc.Feedback()
        
        //Set up the date format for when the user did their session
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        //Set up the filename and destination for where the CSV doc will be saved
        var file_name = (student?.teacher?.username)! + " " + (student?.fullName)! + " lessonData.csv"
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        var fileURL = path.appendingPathComponent(file_name)
        
        //Set up the column titles for the spreadsheet
        var csvLesson = "Session Number,Session Date,Questions Answered,Session Length,Average Response Time\n"
        
        var num = 0
        
        //Populate the rows of the table
        for lesson in lessonItems{
            num += 1
            csvLesson.append("\(num),\(df.string(from: lesson.sessionDate ?? Date())),\(lesson.questionsAnswered),\(lesson.timeSpent),\(lesson.avgTimeForResponse)\n")
        }
        
        //Try to export data for CSV
        do{
            try csvLesson.write(to: fileURL, atomically: true, encoding: .utf8)
            print("Exported Lessons")
        }
        catch{
            print("Unable to export lesson data")
        }
        
        //This is pratically the same for the lessonData CSV, refer to the prior example for an explaination
        file_name = (student?.teacher?.username)! + " " + (student?.fullName)! + " freePlayData.csv"
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
        
        //This is pratically the same for the lessonData CSV, refer to the prior example for an explaination
        file_name = (student?.teacher?.username)! + " " + (student?.fullName)! + " writingData.csv"
        fileURL = path.appendingPathComponent(file_name)
        
        var csvWriting = "Session Number,Session Date,Questions Answered,Session Length,Sucess Rate\n"
        
        num = 0
        
        for writing in writingItems{
            num += 1
            csvWriting.append("\(num),\(df.string(from: writing.sessionDate ?? Date() )),\(writing.questionsAnswered),\(writing.timeSpent),\(writing.sucessRate)\n")
        }
        
        do{
            try csvWriting.write(to: fileURL, atomically: true, encoding: .utf8)
            print("Exported writing")
            let alert = UIAlertController(title: "Data sucessfully exported", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Share files", style: .default, handler: {action in self.OpenFolder()}))
            self.present(alert, animated: false)
        }
        catch{
            print("Unable to export writing data")
        }
        
    }
    
    func OpenFolder(){
        print("Folder opened")
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentView = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.data])
        documentView.directoryURL = path
        documentView.delegate = self
        documentView.allowsMultipleSelection = false
        self.present(documentView, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL){
        print("Opened File")
        let controller = UIDocumentInteractionController(url: url)
        controller.delegate = self
        controller.presentPreview(animated: true)
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    
}
