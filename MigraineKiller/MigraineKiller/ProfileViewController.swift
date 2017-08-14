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
    let calender:Calendar = Calendar.current
    
    //store the result:
    var sleepArray: [Double] = []
    var sleepAve: Double = 0
    var walkArray: [Double] = []
    var walkAve: Double = 0
    

    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var bloodTypeLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let monthLength = -30;
//        let dayLength = -3;
        
        updateInfo()
        
//        sleepArray = getSleepAnalysis(length: monthLength)
        
        
        //getDistanceWalkingRunning(length: monthLength)
//        getThreeDaysTotalStepCount(length: monthLength)
//        getAverageStepCount(length: monthLength)
//        getBloodPressure(length: monthLength)
//        getMenstruation(length: monthLength)
//        getAverageHeartRate(length: monthLength)
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
    
}
