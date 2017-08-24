//
//  AccountViewController.swift
//  MigraineKiller
//
//  Created by Carmen Zhuang on 2017-07-09.
//  Copyright © 2017 Shelly. All rights reserved.
//

import UIKit
import Firebase
import HealthKit

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var avatarView: UIView!
    
    
    @IBAction func LogoutButton(_ sender: Any) {
        handleLogout()
    }
    
    func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError { print(logoutError) }
        let loginController = storyboard?.instantiateViewController(withIdentifier: "LoginViewID") as! LoginViewController
        present(loginController, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // private let myArray: NSArray = ["Email", "Sex", "Date Of Birth", "Profile","Setting"]
    private var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reload()
        
        
    }
    func reload() {
        
        let imageName = getProfileImage()
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.backgroundColor = UIColor.lightGray
        imageView.frame = CGRect(x: 123, y: 100, width: image!.size.width, height: image!.size.height)
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = CGFloat(30)
        
        // set up for subview when profile image is clicked
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        view.addSubview(imageView)
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height * 13
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.backgroundColor = UIColor.clear
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
        
    }
    
    
    func imageTapped(_ sender:AnyObject) {
        var imageName = "avatar\(sender.view.tag).png"
        sender.view.backgroundColor = UIColor.darkGray
        let defaults = UserDefaults.standard
        defaults.set(imageName, forKey: defaultsKeys.profileImage)
        
        avatarView.isHidden = true
        reload()
    }
    
    
    func getProfileImage() -> String {
        let defaults = UserDefaults.standard
        if let profileImageName = defaults.string(forKey: defaultsKeys.profileImage) {
            print(profileImageName)
            return profileImageName
        }
        return "avatar1.png"
    }
    
    
    func profileImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        // set up for pop up
        avatarView = UIView(frame: CGRect(x: 0, y: 80, width: 500, height: 530))
        avatarView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        avatarView.accessibilityScroll(UIAccessibilityScrollDirection.down)
        
        self.view.addSubview(avatarView)
        
        // display all images
        var avatarImages: Array<UIImageView> = []
        var i: Int = 1
        var j: Int = 1
        var k: Int = 1
        var x: CGFloat = 0
        var y: CGFloat = 0
        while i < 10 {
            
            if (CGFloat(j)*100 <= UIScreen.main.bounds.size.width) {
                x = CGFloat(j-2)*100
                y = CGFloat(k-2)*110
            } else {
                j = 1
                x = CGFloat(j-2)*100
                y = CGFloat(k-1)*110
                k += 1
            }
            
            let avatarOption = UIImage(named: "avatar\(i).png")
            
            
            let avatarOptionView = UIImageView(image: avatarOption)
            print(i)
            avatarOptionView.tag = i
            
            avatarOptionView.backgroundColor = UIColor.lightGray
            avatarOptionView.layer.borderWidth = 5
            avatarOptionView.layer.cornerRadius = CGFloat(30)
            avatarOptionView.layer.borderColor = UIColor.black.cgColor
            
            avatarOptionView.translatesAutoresizingMaskIntoConstraints = false
            avatarImages.append(avatarOptionView)
            
            avatarView.addSubview(avatarOptionView)
            
            
            NSLayoutConstraint.activate([
                avatarOptionView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: x),
                avatarOptionView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: y),
                avatarOptionView.widthAnchor.constraint(equalToConstant: 100),
                avatarOptionView.heightAnchor.constraint(equalToConstant: 100)
                ])
            
            avatarView.isHidden = false
            i += 1
            j += 1
            
            
            // set up for profile image options to be picked
            let tapGestureRecognizerForOptions = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            
            avatarOptionView.isUserInteractionEnabled = true
            avatarOptionView.addGestureRecognizer(tapGestureRecognizerForOptions)
            
        }
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                self.storyboard!.instantiateViewController(withIdentifier: "Profile")
                self.performSegue(withIdentifier: "ProfileSegue", sender: self)
            } else if indexPath.row == 1 {
                self.storyboard!.instantiateViewController(withIdentifier: "Setting")
                self.performSegue(withIdentifier: "SettingSegue", sender: self)
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 3
        }
        else if (section == 1){
            return 2
        }
        return 0
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "Profile"
        }
        else if (section == 1){
            return "Setting"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.darkGray
        
        let headerLabel = UILabel(frame: CGRect(x: 15, y: 5, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.textColor = UIColor.lightGray
        headerLabel.font = UIFont.boldSystemFont(ofSize: 18)
        headerLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeued: AnyObject = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        
        //allocate a table view cell
        let cell = dequeued as! UITableViewCell
        cell.backgroundColor=UIColor.lightGray
        cell.frame = CGRect(x: 0, y: 0, width: myTableView.frame.width, height: 100)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.lightGray
        
        if indexPath.section == 0 {
            cell.isUserInteractionEnabled = false
            if indexPath.row == 0 {
                cell.textLabel?.text = "Email"
            } else if indexPath.row == 1 {
                let profile = healthManager.readProfile()
                cell.textLabel?.text = "Sex - \(getBiologicalSex(biologicalSex: profile.biologicalsex?.biologicalSex))"
            } else if indexPath.row == 2 {
                let dateOfBirth = healthManager.readDateOfBirth()
                cell.textLabel?.text = "Date Of Birth - \(getDateOfBirth(dateOfBirth: dateOfBirth))"
                
                
                
            }
        } else if indexPath.section == 1 {
            let bgColorView = UIView()
            bgColorView.backgroundColor = UIColor(red:0.17, green:0.17, blue:0.17, alpha:1.0)
            cell.selectedBackgroundView = bgColorView
            if indexPath.row == 0 {
                cell.textLabel?.text = "Profile"
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "About"
            }
            
        }
        
        return cell
    }
    
    
    
    let healthManager:HealthKitManager = HealthKitManager()
    let healthStore = HKHealthStore()
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
    
    
    
    
    
    
    
}
