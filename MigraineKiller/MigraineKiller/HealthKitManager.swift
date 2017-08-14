//
//  HealthKitManager.swift
//  MigraineKiller
//
//  Created by Carmen Zhuang on 2017-07-07.
//  Copyright © 2017 Shelly. All rights reserved.
//

import UIKit
import HealthKit

class HealthKitManager {
    
    
    
    let healthKitStore: HKHealthStore = HKHealthStore()
    
    func authorizeHealthKit(completion: ((_ success: Bool, _ error: NSError?) -> Void)!) {
        
        // State the health data type(s) we want to read from HealthKit.
        let healthData = Set(arrayLiteral:
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
                             HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
                             HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureSystolic)!,
                             HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureDiastolic)!,
                             HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
                             HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!,
                             HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.menstrualFlow)!,
                             HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!,
                             HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)!,
                             HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!)
        
        
        
        // Just in case OneHourWalker makes its way to an iPad...
        if !HKHealthStore.isHealthDataAvailable() {
            print("Can't access HealthKit.")
        }
        
        //Request authorization to read and/or write the specific data.
        healthKitStore.requestAuthorization(toShare: nil, read: healthData) { (success, error) -> Void in
            //TODO: Add error popup
            
            //            if( completion != nil ) {
            //                completion(success, error as! NSError)
            //            }
        }
        
    }
    
    func readProfile() -> ( biologicalsex:HKBiologicalSexObject?, bloodtype: HKBloodTypeObject?)
    {
        var error:NSError?
        
        var bloodType: HKBloodTypeObject?
        
        var biologicalSex:HKBiologicalSexObject?
        // 2. Read biological sex
        
        do{
            biologicalSex = try healthKitStore.biologicalSex()
        }catch let error as NSError{
            biologicalSex = nil
            print("\(error) error with sex")
        }
        
        //Get user's blood type
        do{
            bloodType = try healthKitStore.bloodType()
        }catch let error as NSError{
            bloodType = nil
            print("\(error) error with blood type")
        }
        
        // 4. Return the information read in a tuple
        return (biologicalSex, bloodType)
    }
    
    
    func readDateOfBirth() -> (DateComponents?)
    {
        var error:NSError?
        
        var dateOfBirth: DateComponents?
        //var date: Date?
        do{
            dateOfBirth = try healthKitStore.dateOfBirthComponents()
        }catch let error as NSError{
            dateOfBirth = nil
            print("\(error) error with date of birth")
        }
        return (dateOfBirth)
    }
    
    
}

