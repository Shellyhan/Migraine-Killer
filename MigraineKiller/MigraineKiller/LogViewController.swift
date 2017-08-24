//
//  LogViewController.swift
//  MigraineKiller
//
//  Created by Xue Han on 2017-07-07.
//  Copyright © 2017 Shelly. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {
    
    @IBOutlet weak var LogButton: UIButton!
    
    let healthManager:HealthKitManager = HealthKitManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogButton.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
        getHealthKitPermission()
        
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
    
}
