//
//  LogViewController.swift
//  MigraineKiller
//
//  Created by Xue Han on 2017-07-07.
//  Copyright © 2017 Shelly. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {
    
    let healthManager:HealthKitManager = HealthKitManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        getHealthKitPermission()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getHealthKitPermission() {
        
        // Seek authorization in HealthKitManager.swift.
        healthManager.authorizeHealthKit{(authorized, error) -> Void in
            if authorized {
                
                // Get and set the user's height.
                
            } else {
                if error != nil {
                    print(error)
                }
                print("Permission denied.")
            }
        }
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
