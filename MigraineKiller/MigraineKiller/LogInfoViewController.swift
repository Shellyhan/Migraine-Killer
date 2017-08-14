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
//    variables to setup the view:
    let tealColor = UIColor(red: 0/255, green: 128/255, blue: 128/255, alpha: 0.5)
    var durationPickerData: [[String]] = [[String]]()
//    variables to store the results:
    let painL = "1"
    let painA = ["1", "2", "3"]
    let stressL = "5"
    let emo = ["1", "2", "3"]
    let date = "2017/07/14"
    let time = "morning"
    var dura = "5" // 5 * 30mins
    let location = "vancouver"
    let note = "hererererererere"
    
    
    

    @IBAction func fakebuttonSUBMIT(_ sender: Any) {
        getData()

    }
    
    @IBOutlet weak var area1: UIButton!
    @IBOutlet weak var area2: UIButton!
    @IBOutlet weak var area3: UIButton!
    @IBOutlet weak var area4: UIButton!
    @IBOutlet weak var area5: UIButton!
    @IBOutlet weak var area6: UIButton!
    
    @IBAction func setArea1Button(_ sender: Any) {
        area1.backgroundColor? = tealColor
    }
    
    @IBAction func setArea2Button(_ sender: Any) {
        area2.backgroundColor? = tealColor
    }

    @IBOutlet weak var durationPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect data:
        self.durationPicker.dataSource = self
        self.durationPicker.delegate = self
        
        // Input data into the Array:
        durationPickerData = [["0", "1 day", "2 days", "3 days", "4 days", "5 days", "6 days"],
                      ["0", "1 hour", "2 hours", "3 hours", "4 hours", "5 hours", "6 hours"],
                      ["5 min", "10 min", "15 min", "20 min", "30 min", "40 min", "50 min"]]
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getData(){
        
        //goes into the submit button action
        
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
            "note": note] as [String : Any]
        
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
