//
//  ChartAxisFormatter.swift
//  FaceAnimoji
//
//  Created by Justin Peters on 2/9/21.
//  Copyright © 2021 ashutosh.dingankar. All rights reserved.
//

import Foundation
import Charts

//This is an unsed document. It was made to chart time on a axis for the charts API. Found it to be unneeded and didn't work out when I tried to do it.
class ChartAxisFormetter : NSObject {
    fileprivate var dateFormatter:DateFormatter?
    fileprivate var referenceTimeInterval:TimeInterval?
    
    convenience init(referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter) {
        self.init()
        self.referenceTimeInterval = referenceTimeInterval
        self.dateFormatter = dateFormatter
    }
}

extension ChartAxisFormetter : AxisValueFormatter{
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let dateFormatter = dateFormatter,
              let referenceTimeInterval = referenceTimeInterval
        else {
            return ""
        }
        
        let date = Date(timeIntervalSince1970: value * 3600 * 24 + referenceTimeInterval)
        return dateFormatter.string(from: date)
    }
}
