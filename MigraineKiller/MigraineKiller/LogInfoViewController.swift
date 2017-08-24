//
//  LogInfoViewController.swift
//  MigraineKiller
//
//  Created by Xue Han on 2017-07-07.
//  Copyright © 2017 Shelly. All rights reserved.
//

import UIKit
import Firebase

class LogInfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  
    var painA: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0]
    var foodIntake: [Int] = [0,0,0,0,0]
    var painL = 1
    var stressL = 1
    var date = "2017/07/14"
    var emo = 0
    var time = "morning"
    var dura = "5" // 5 * 30mins
    var location = "vancouver"
    var note = "Empty"
    
    //DUration picker:
    var durationPickerData: [[String]] = [[String]]()
    

    @IBOutlet var PainAreaButtons: [UIButton]!
    @IBOutlet var FoodIntakeButtons: [UIButton]!
    
    @IBOutlet var EmojiButtons: [UIButton]!
    
    @IBOutlet weak var durationPicker: UIPickerView!

    @IBAction func painLBar(_ sender: UISlider) {
        painL = Int(sender.value)
        print(painL)
    }

    
    @IBAction func letStressLBar(_ sender: UISlider) {
        stressL = Int(sender.value)
        print(stressL)
    }
    
    @IBAction func emo1(sender: AnyObject) {
        guard let button = sender as? UIButton else{
            return
        }
        setbackground(inputnum: button.tag)
    }
    
    @IBAction func DatePicker(_ sender: UIDatePicker) {
//        date = formatter.string(from: sender.date)
        date = formatter.string(from: (sender.date))
    }
    
    @IBAction func PainAction(sender: Any) {
        guard let button = sender as? UIButton else{
            return
        }

        if(painA[button.tag] == 0) {
            painA[button.tag] = 1
            PainAreaButtons[button.tag].backgroundColor = UIColor.lightGray.withAlphaComponent(0.65)
            PainAreaButtons[button.tag].isOpaque = false
        } else {
            painA[button.tag] = 0
            button.backgroundColor = UIColor.darkGray.withAlphaComponent(0.65)
        }
    }



    @IBAction func PickFood(_ sender: Any) {
        guard let button = sender as? UIButton else{
            return
        }
        if(foodIntake[button.tag] == 0) {
            foodIntake[button.tag] = 1
            FoodIntakeButtons[button.tag].layer.cornerRadius = 5


            FoodIntakeButtons[button.tag].backgroundColor = UIColor.lightGray.withAlphaComponent(0.65)
            FoodIntakeButtons[button.tag].isOpaque = false
        } else {
            foodIntake[button.tag] = 0
            button.backgroundColor = UIColor.darkGray.withAlphaComponent(0)
            
        }
    }
    
    @IBAction func SubmitLog(_ sender: Any) {
        getData()
    }
    
    @IBOutlet weak var SubmitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect data:
        self.durationPicker.dataSource = self
        self.durationPicker.delegate = self
        
        // Input data into the Array:
        durationPickerData = [["0", "1 day", "2 days", "3 days", "4 days", "5 days", "6 days"],
                              ["0", "1 hour", "2 hours", "3 hours", "4 hours", "5 hours", "6 hours"],
                              ["5 min", "10 min", "15 min", "20 min", "30 min", "40 min", "50 min"]]
    }
    
    
    func setbackground(inputnum: Int) {
        
        EmojiButtons[inputnum].layer.cornerRadius = 100
        EmojiButtons[inputnum].backgroundColor = UIColor.blue
        emo = inputnum
        
        for i in 0..<EmojiButtons.count{
            if i != inputnum {
                EmojiButtons[i].backgroundColor = UIColor.clear
            }
        }
    }
    
    //MARK: UIPicker methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return durationPickerData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return durationPickerData[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.dura = durationPickerData[component][row]
    }
    
    
    func getData(){
        
        //get the user info
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        
        /*
         let UsersRef = ref.child("HeadacheLog").child(uid!)
         UsersRef.observeSingleEvent(of: .value, with: { (snapshot) in //print(snapshot)
         }, withCancel: nil)
         */
        
        //create log reference:
        let LogRef = ref.child("HeadacheLog").child(uid!)
        let LogKey = LogRef.childByAutoId().key
        
        //create the log:
        let logContent = [
            "date": date,
            "time": time,
            "duration": dura,
            "location": location,
            "painLevel": painL,
            "stressLevel": stressL,
            "painArea": painA,
            "emotion": emo,
            "note": note,
            "foodIntake": foodIntake] as [String : Any]
        
        //insert the log:
        let logUpdates = ["\(LogKey)": logContent]
        LogRef.updateChildValues(logUpdates)
        
        //display log details --- debug:
        LogRef.child(LogKey).observeSingleEvent(of: .value, with: { (snapshot) in
            
            print("----------event info--------------")
            print(snapshot)
        }, withCancel: nil)
        
        /*
         let alertController = UIAlertController(title: "Create New Event", message: "Successfully created a new event", preferredStyle: .alert)
         let defaultAction = UIAlertAction(title: "OK", style: .default, handler: skipBack)
         alertController.addAction(defaultAction)
         present(alertController, animated: true, completion: nil)
         */
        
    }
    
    //set the date and time format:
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
}
