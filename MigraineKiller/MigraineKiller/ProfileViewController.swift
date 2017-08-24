//
//  HistoryViewController.swift
//  MigraineKiller
//
//  Created by Carmen Zhuang on 2017-07-09.
//  Copyright © 2017 Shelly. All rights reserved.
//

import UIKit
import HealthKit

class ProfileViewController: UIViewController {
    
    
    
    let healthManager:HealthKitManager = HealthKitManager()
    let healthStore = HKHealthStore()

    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var bloodTypeLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateInfo()
    
    }
    
    func updateInfo()
    {
        let profile = healthManager.readProfile()
        sexLabel.text = getBiologicalSex(biologicalSex: profile.biologicalsex?.biologicalSex)
        bloodTypeLabel.text = getBloodType(bloodType: profile.bloodtype?.bloodType)
        
        let dateOfBirth = healthManager.readDateOfBirth()
        dateOfBirthLabel.text = getDateOfBirth(dateOfBirth: dateOfBirth)
    }
    
    
    func getBiologicalSex(biologicalSex:HKBiologicalSex?)->String
    {
        var biologicalSexText = "Unknown"
        
        if  biologicalSex != nil {
            
            switch( biologicalSex! )
            {
            case .female:
                biologicalSexText = "Female"
            case .male:
                biologicalSexText = "Male"
            default:
                break;
            }
            
        }
        return biologicalSexText;
    }
    
    func getBloodType(bloodType:HKBloodType?)->String
    {
        var bloodTypeText = "Unknown"
        
        if  bloodType != nil {
            
            switch( bloodType! )
            {
            case .abNegative:
                bloodTypeText = "AB-"
            case .abPositive:
                bloodTypeText = "AB+"
            case .aNegative:
                bloodTypeText = "A-"
            case .aPositive:
                bloodTypeText = "A+"
            case .bNegative:
                bloodTypeText = "B-"
            case .bPositive:
                bloodTypeText = "B+"
            case .oNegative:
                bloodTypeText = "O-"
            case .oPositive:
                bloodTypeText = "O+"
            default:
                break;
            }
            
        }
        return bloodTypeText;
    }
    
    
    
    func getDateOfBirth(dateOfBirth: DateComponents?)->String
    {
        var dateOfBirthDayText = ""
        var dateOfBirthMonthText  = ""
        var dateOfBirthYearText = ""
        var dateOfBirthText = "Unknown"
        
        if  dateOfBirth != nil {
            
            dateOfBirthDayText = String(describing: dateOfBirth!.day!)
            dateOfBirthMonthText  = String(describing: dateOfBirth!.month!)
            dateOfBirthYearText = String(describing: dateOfBirth!.year!)
            dateOfBirthText = dateOfBirthDayText + dateOfBirthMonthText + dateOfBirthYearText
            
        }
        return dateOfBirthText;
        
    }
    
//    
//    
//    func getSleepAnalysis() {
//        // define the object type
//        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
//            // use a sortDescriptor to get the recent data first
//            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
//            
//            let date = NSDate() as Date
//            let cal = Calendar(identifier: Calendar.Identifier.gregorian)
//            let newDate = cal.date(byAdding: .hour, value: -24, to: date)
//            
//            let predicate = HKQuery.predicateForSamples(withStart: newDate, end: NSDate() as Date, options: .strictStartDate)
//
//            
//            // create uery with a block completion to execute
//            let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: 100, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) -> Void in
//                
//                if error != nil {
//                    print("sleep analysis is nil")
//                    return
//                }
//                var duration:Double = 0
//                if let result = tmpResult {
//                    // print
//                    for item in result {
//                        if let sample = item as? HKCategorySample {
//                            let value = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue) ? "InBed" : "Asleep"
//                           
//                            duration += sample.endDate.timeIntervalSince(sample.startDate)
//                            
//                            
//                        }
//                       
//                    }
//                    duration = duration/60
//                    print("\(duration)")
//                }
//            }
//            // execute our query
//            healthStore.execute(query)
//        } else {
//            fatalError("Something went wrong retrieving sleep analysis")
//        }
//    }
//    
//    
//    func getAverageStepCount(length: Int) {
//        //  Perform the Query
//        let endDate = Date()
//        var startDate = Date()
//        if (length == 30) {
//            startDate = NSCalendar.current.date(byAdding: .month, value: -1, to: endDate)!
//        } else {
//            startDate = NSCalendar.current.date(byAdding: .hour, value: -24, to: endDate)!
//        }
//
//        
//        let stepSampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
//        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
//        
//        let query = HKSampleQuery(sampleType: stepSampleType!, predicate: predicate, limit: 0, sortDescriptors: nil, resultsHandler: {
//            (query, results, error) in
//            if results == nil {
//                 print("something went wrong in step count")
//            }
//            
//            DispatchQueue.main.async() {
//                var total:Double = 0
//                var dailyAVG:Double = 0
//                for steps in results as! [HKQuantitySample]
//                {
//                    // add values to dailyAVG
//                    total += steps.quantity.doubleValue(for: HKUnit.count())
//                }
//                dailyAVG = total / Double((results?.count)!)
//                print("average step count: \(dailyAVG)")
//            }
//        })
//        healthStore.execute(query)
//    }
//    
//    
//    
//    func getBloodPressure(length: Int)
//    {
//        guard let type = HKQuantityType.correlationType(forIdentifier: HKCorrelationTypeIdentifier.bloodPressure),
//            let systolicType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureSystolic),
//            let diastolicType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureDiastolic) else {
//                // display error, etc...
//                print("something went wrong in blood pressure")
//                return
//        }
//        
//        let endDate = Date()
//        var startDate = Date()
//        if (length == 30) {
//             startDate = NSCalendar.current.date(byAdding: .month, value: -1, to: endDate)!
//        } else {
//            startDate = NSCalendar.current.date(byAdding: .hour, value: -24, to: endDate)!
//        }
//       
//        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
//        
//        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: true)
//        let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor])
//        { (query, results, error ) -> Void in
//            
//            if let dataList = results as? [HKCorrelation] {
//                var totalSystolic:Double = 0
//                var totalDiastolic:Double = 0
//                var systolicAVG:Double = 0
//                var diastolicAVG:Double = 0
//                for data in dataList
//                {
//                    if let data1 = data.objects(for: systolicType).first as? HKQuantitySample,
//                        let data2 = data.objects(for: diastolicType).first as? HKQuantitySample {
//                        
//                        let value1 = data1.quantity.doubleValue(for: HKUnit.millimeterOfMercury())
//                        let value2 = data2.quantity.doubleValue(for: HKUnit.millimeterOfMercury())
//                        
//                        totalSystolic += value1
//                        totalDiastolic += value2
//                    }
//                }
//                systolicAVG = totalSystolic / Double(dataList.count)
//                diastolicAVG = totalDiastolic / Double(dataList.count)
//                print("systolic AVG: \(systolicAVG)")
//                print("diastolic AVG: \(diastolicAVG)")
//                
//            }
//        }
//        healthStore.execute(query)
//    }
//    
//    
//    func getMenstruation() {
//        // define the object type
//        if let menstruationType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.menstrualFlow) {
//            
//            // use a sortDescriptor to get the recent data first
//            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
//            
//            // create uery with a block completion to execute
//            let query = HKSampleQuery(sampleType: menstruationType, predicate: nil, limit: 30, sortDescriptors: [sortDescriptor]) { (query, results, error) -> Void in
//                
//                if error != nil {
//                    print("menstruation flow is nil")
//                    return
//                }
//                if let result = results {
//                    // print
//                    for item in result {
//                        if let sample = item as? HKCategorySample {
//                            print("Menstruation: \(sample.startDate)")
//                        }
//                    }
//                }
//            }
//            // execute our query
//            healthStore.execute(query)
//        } else {
//            fatalError("Something went wrong retrieving menstruation flow")
//        }
//
//        
//    }
//    
//    
    
    
    
    
    
}
