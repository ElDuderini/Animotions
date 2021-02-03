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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateChart(chart: lessonChart)
        generateChart(chart: freeplayChart)
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
