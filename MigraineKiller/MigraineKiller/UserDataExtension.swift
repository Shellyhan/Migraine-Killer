//
//  UserDataExtension.swift
//  MigraineKiller
//
//  Created by Xue Han on 2017-07-21.
//  Copyright © 2017 Shelly. All rights reserved.
//

import Foundation
import UIKit
import HealthKit

extension ResultViewController {
    
    //for dynamic data:
    func getSleepAnalysis(length: Int, doneStuffBlock: (Double) -> ()) -> Double {
        
        var duration:Double = 0
        
        // define the object type
        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
            // use a sortDescriptor to get the recent data first
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            
            let date = NSDate() as Date
            let cal = Calendar(identifier: Calendar.Identifier.gregorian)
            let newDate = cal.date(byAdding: .hour, value: length, to: date)
            
            let predicate = HKQuery.predicateForSamples(withStart: newDate, end: NSDate() as Date, options: .strictStartDate)
            
            
            // create uery with a block completion to execute
            let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: 100, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) -> Void in
                
                if error != nil {
                    print("sleep analysis is nil")
                    return
                }
                if let result = tmpResult {
                    // print
                    for item in result {
                        if let sample = item as? HKCategorySample {
                            
                            if (sample.value == HKCategoryValueSleepAnalysis.asleep.rawValue) {
                                duration += sample.endDate.timeIntervalSince(sample.startDate)
                            }
                            
                        }
                        
                    }
                    duration = duration/60
                    print("\(duration)------\(length)")
                    self.resultDataArray.append(duration)
                    
                }
            }
            // execute our query
            healthStore.execute(query)
        } else {
            fatalError("Something went wrong retrieving sleep analysis")
        }

        doneStuffBlock(duration)
        return duration
    }
    
    
//    
//    //for dynamic data:
//    func getSleepAnalysis(length: Int) {
//        // define the object type
//        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
//            // use a sortDescriptor to get the recent data first
//            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
//            
////            let date = NSDate() as Date
////            let cal = Calendar(identifier: Calendar.Identifier.gregorian)
////            let newDate = cal.date(byAdding: .hour, value: length, to: date)
//            
//            var totalTime = Int()
//            
//            let endDate = Date()
//            let startDate = NSCalendar.current.date(byAdding: .day, value: length, to: endDate)
//            
//            let pred = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
//            
//            // create query with a block completion to execute
//            let query = HKSampleQuery(sampleType: sleepType, predicate: pred, limit: 1, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) -> Void in
//                
//                if error != nil {
//                    print("sleep analysis is nil")
//                    return
//                }
//                if let result = tmpResult {
//                    // print
//                    for item in result {
//                        if let sample = item as? HKCategorySample {
//                            if (sample.value == HKCategoryValueSleepAnalysis.asleep.rawValue) {
//                                
//                                let duration = self.calender.dateComponents([.minute], from: sample.startDate, to: sample.endDate)
//                                
////                                print("Healthkit sleep: \(sample.startDate) \(sample.endDate) - duration is: \(duration.minute!)")
//                                
//                                totalTime += duration.minute!
//                            }
//                        }
//                    }
//                    
//                    print("-----------sleep time:")
//                    print(totalTime)
//                }
//            }
//            // execute our query
//            healthStore.execute(query)
//        } else {
//            fatalError("Something went wrong retrieving sleep analysis")
//        }
//    }
//
    
    
    
//    func getAverageStepCount(length: Int, completionHandler: CompletionHandler) -> Double {
    func getAverageStepCount(length: Int) -> Double {
        var total: Double = 0
        var dailyAVG: Double = 0
        //  Perform the Query
        let endDate = Date()
        let startDate = NSCalendar.current.date(byAdding: .day, value: length, to: endDate)!

        let stepSampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        let query = HKSampleQuery(sampleType: stepSampleType!, predicate: predicate, limit: 10, sortDescriptors: nil, resultsHandler: {
            (query, results, error) in
            if results == nil {
                print("something went wrong in step count")
                return
            }
            
            DispatchQueue.main.async() {
                
                for steps in results as! [HKQuantitySample]
                {
                    // add values to dailyAVG
                    total += steps.quantity.doubleValue(for: HKUnit.count())
                    let aaa = steps.quantity.doubleValue(for: HKUnit.count())
                    print("------\(aaa)")
                }
                dailyAVG = total / Double((results?.count)!)
                print("average step count: \(dailyAVG)------\(length)")
            }
        })
        healthStore.execute(query)
//        completionHandler(true)
        return dailyAVG
    }
    

//    
//    
//    func getTotalStepCount(length: Int) {
//        //  Perform the Query
//        if let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) {
//            
////            let date = NSDate() as Date
////            let cal = Calendar(identifier: Calendar.Identifier.gregorian)
////            let newDate = cal.date(byAdding: .day, value: length, to: date)
//            
//            let endDate = Date()
//            let startDate = NSCalendar.current.date(byAdding: .day, value: length, to: endDate)
//            var totalStep = Double()
//            
//            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
//            
//            let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: [.cumulativeSum]) { (query, statistics, error) -> Void in
//                
//                if error != nil {
//                    print("something went wrong in step count")
//                } else if let quantity = statistics?.sumQuantity() {
//                    let steps = quantity.doubleValue(for: HKUnit.count())
//                    
////                    print ("Steps =  \(steps) steps")
//                    totalStep = steps
//                    print("------------steps:")
//                    print(totalStep)
//                }
//            }
//            healthStore.execute(query)
//        } else {
//            fatalError("Something went wrong retrieving step count")
//        }
//        
//        
//    }
//    
//    //why need 2?:
//    func getAverageStepCount(length: Int) {
//        //  Perform the Query
//        let endDate = Date()
//        let startDate = NSCalendar.current.date(byAdding: .month, value: length, to: endDate)
//        
//        
//        let stepSampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
//        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
//        
//        let query = HKSampleQuery(sampleType: stepSampleType!, predicate: predicate, limit: 0, sortDescriptors: nil, resultsHandler: {
//            (query, results, error) in
//            if results == nil {
//                print("something went wrong in step count")
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
    
    
    func getBloodPressure(length: Int) -> (Double, Double) {
        var totalSystolic:Double = 0
        var totalDiastolic:Double = 0
        var systolicAVG:Double = 0
        var diastolicAVG:Double = 0
        guard let type = HKQuantityType.correlationType(forIdentifier: HKCorrelationTypeIdentifier.bloodPressure),
            let systolicType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureSystolic),
            let diastolicType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureDiastolic) else {
                // display error, etc...
                print("something went wrong in blood pressure")
                return (systolicAVG, diastolicAVG)
        }
        
        let endDate = Date()
        var startDate = NSCalendar.current.date(byAdding: .day, value: length, to: endDate)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: true)
        let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor])
        { (query, results, error ) -> Void in
            
            if let dataList = results as? [HKCorrelation] {
                for data in dataList
                {
                    if let data1 = data.objects(for: systolicType).first as? HKQuantitySample,
                        let data2 = data.objects(for: diastolicType).first as? HKQuantitySample {
                        
                        let value1 = data1.quantity.doubleValue(for: HKUnit.millimeterOfMercury())
                        let value2 = data2.quantity.doubleValue(for: HKUnit.millimeterOfMercury())
                        
                        totalSystolic += value1
                        totalDiastolic += value2
                    }
                }
                systolicAVG = totalSystolic / Double(dataList.count)
                diastolicAVG = totalDiastolic / Double(dataList.count)
                print("systolic AVG: \(systolicAVG)------\(length)")
                print("diastolic AVG: \(diastolicAVG)")
                
            }
        }
        healthStore.execute(query)
        return (systolicAVG, diastolicAVG)
    }
    
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
//        let startDate = NSCalendar.current.date(byAdding: .day, value: length, to: endDate)
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
//                        
//                        print("blood pressure: \(value1) / \(value2)")
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
    
    func getMenstruation() -> Double{
        var periodBool = 0
        // define the object type
        if let menstruationType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.menstrualFlow) {
            
            // use a sortDescriptor to get the recent data first
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            
            // create uery with a block completion to execute
            let query = HKSampleQuery(sampleType: menstruationType, predicate: nil, limit: 3, sortDescriptors: [sortDescriptor]) { (query, results, error) -> Void in
                
                if error != nil {
                    print("menstruation flow is nil")
                    return
                }
                if let result = results {
                    // print
                    for item in result {
                        if let sample = item as? HKCategorySample {
                            print("Menstruation: \(sample.startDate)")
                            
                            if (sample.startDate <= Calendar.current.date(byAdding: .day, value: -2, to: Date())!) {
                                periodBool = 1
                            }
                        }
                    }
                }
            }
            // execute our query
            healthStore.execute(query)
        } else {
            fatalError("Something went wrong retrieving menstruation flow")
        }
        return Double(periodBool)
        
    }

//
//    func getMenstruation(length: Int) {
//        // define the object type
//        if let menstruationType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.menstrualFlow) {
//            
//            // use a sortDescriptor to get the recent data first
//            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
//            
//            // create uery with a block completion to execute
//            let query = HKSampleQuery(sampleType: menstruationType, predicate: nil, limit: length, sortDescriptors: [sortDescriptor]) { (query, results, error) -> Void in
//                
//                if error != nil {
//                    print("menstruation flow is nil")
//                    return
//                }
//                if let result = results {
//                    // print
//                    for item in result {
//                        if let sample = item as? HKCategorySample {
////                            print("Menstruation: \(sample.startDate)")
//                            print("-------period")
//                            print(item)
//                        }
//                    }
//                }
//            }
//            // execute our query
//            healthStore.execute(query)
//        } else {
//            fatalError("Something went wrong retrieving menstruation flow")
//        }
//    }
}
