//
//  ResultViewController.swift
//  MigraineKiller
//
//  Created by Xue Han on 2017-08-17.
//  Copyright © 2017 Shelly. All rights reserved.
//

import UIKit
import HealthKit
import Firebase
import Charts

class ResultViewController: UIViewController {
    
    var resultDataArray = [Double]()
    typealias CompletionHandler = (_ success:Bool) -> Void
    
    var fake: [Double] = [0.45, 0.21, 0.34, 0.4, 0.1]
    
    var pieChartEntry = [ChartDataEntry]()
    
    let healthManager:HealthKitManager = HealthKitManager()
    let healthStore = HKHealthStore()
    let calender:Calendar = Calendar.current
    
    @IBOutlet weak var ChartPie1: PieChartView!
    
    
    let handler: (Double) -> () = { (input) in
        print("here!!!, \(input)")
    }
    
    //store the result from HK:
    
    var sleepData: Double = 0
    var sleepAve: Double = 0
    var walkData: Double = 0
    var walkAve: Double = 0
    var bloodPressureH: Double = 0
    var bloodPressureHAve: Double = 0
    var bloodPressureL: Double = 0
    var bloodPressureLAve: Double = 0
    var period: Double = 0
    let nameString1: [String] = ["Sleep", "Excesise", "Coffee Intake", "Blood Pressure", "Menstruation"]
    
    //store the result from weather:
    
//    let nameString2: [String] = ["Temperature", "Pressure", "Humidity"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        getHKData()
//        getWeatherData()
        self.ChartPie1.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
        generateChart()
        
    }
    
    func generateChart() {
        let yse = fake.enumerated().map { x, y in return PieChartDataEntry(value: y, label: nameString1[x]) }

        let data = PieChartData()
        let ds1 = PieChartDataSet(values: yse, label: "")

        ds1.colors = ChartColorTemplates.colorful()
        
        data.addDataSet(ds1)

        let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
//        let centerText: NSMutableAttributedString = NSMutableAttributedString(string: "Health Kit\nData 1")
//        centerText.setAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 15.0)!, NSParagraphStyleAttributeName: paragraphStyle], range: NSMakeRange(0, centerText.length))
//        centerText.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 13.0)!, NSForegroundColorAttributeName: UIColor.gray], range: NSMakeRange(10, centerText.length - 10))
//        centerText.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-LightItalic", size: 13.0)!, NSForegroundColorAttributeName: UIColor(red: 51 / 255.0, green: 181 / 255.0, blue: 229 / 255.0, alpha: 1.0)], range: NSMakeRange(centerText.length - 19, 19))
//        
//        self.ChartPie1.centerAttributedText = centerText

        self.ChartPie1.backgroundColor = UIColor(white: 1, alpha: 0)
        self.ChartPie1.holeColor = UIColor(white: 1, alpha: 0)
        self.ChartPie1.data = data

        self.ChartPie1.chartDescription?.text = "Numbers are the accumulative weight"
    }
    
    func getHKData() {
        sleepData = getSleepAnalysis(length: -1, doneStuffBlock: handler)
        sleepAve = getSleepAnalysis(length: -30, doneStuffBlock: handler)
//        walkData = getAverageStepCount(length: -1)
//        walkAve = getAverageStepCount(length: -30)
//        (bloodPressureH, bloodPressureL) = getBloodPressure(length: -1)
//        (bloodPressureHAve, bloodPressureLAve) = getBloodPressure(length: -30)
//        period = getMenstruation()
        
//        let sleepDelta = abs(sleepData - sleepAve)/sleepAve
//        let walkDelta = abs(walkData - walkAve)/walkAve
//        let bloodHDelta = abs(bloodPressureH - bloodPressureHAve)/bloodPressureHAve
//        let bloodLDelta = abs(bloodPressureL - bloodPressureLAve)/bloodPressureLAve
//        self.resultDataArray.append(sleepDelta)
//        self.resultDataArray.append(walkDelta)
//        self.resultDataArray.append(bloodHDelta)
//        self.resultDataArray.append(bloodLDelta)
//        self.resultDataArray.append(period)
//
//        if (sleepDelta >= 0.4) || (walkDelta >= 0.5) || (bloodDelta >= 0.3) || (bloodPressure >= 139) || (period){
//        
//        }
    }

//    func getWeatherData() {
//    
//    }

    
    
    
}
