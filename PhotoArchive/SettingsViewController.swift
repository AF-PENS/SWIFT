//
//  SettingsViewController.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 1/26/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var imageExpiresIn: UITextField!
    @IBOutlet weak var autoImageDeleteOutlet: UISwitch!
    @IBOutlet weak var wifiOnlyOutlet: UISwitch!
    
    var defaults = UserDefaults()
    
    @IBAction func autoImageDeleteAction(_ sender: Any) {
        
        let tempString = imageExpiresIn.text!
        let tempInt = Int(tempString)
        
        if autoImageDeleteOutlet.isOn == true && tempInt == nil {
            autoImageDeleteOutlet.isOn = false
        }
        
        defaults.set(autoImageDeleteOutlet.isOn, forKey: UD.isAutoImageExpires)
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        defaults.set(false, forKey: UD.rememberMe)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func imageExpiresInEditingDidEndAction(_ sender: Any) {
        
        let tempString = imageExpiresIn.text!
        let tempInt = Int(tempString)
        
        if tempInt != nil {
            defaults.set(tempInt, forKey: UD.imageExpiresIn)
            let tempInt = defaults.object(forKey: UD.imageExpiresIn) as! Int
            imageExpiresIn.text = String(tempInt)
        }
        else {
            autoImageDeleteOutlet.isOn = false
            defaults.set(autoImageDeleteOutlet.isOn, forKey: UD.isAutoImageExpires)
            
            imageExpiresIn.text = "X"
        }

    }
    
    @IBAction func wifiOnlyAction(_ sender: Any) {
        
        if wifiOnlyOutlet.isOn {
            wifiOnlyOutlet.isOn = false
        }
        else {
            wifiOnlyOutlet.isOn = true
        }
        
        defaults.set(wifiOnlyOutlet.isOn, forKey: UD.isWIFIOnly)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
        
        // Establish defaults object to load persistent data
        defaults = UserDefaults.standard
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // Gets whether automatic image delete is turned on
        autoImageDeleteOutlet.isOn = defaults.object(forKey: UD.isAutoImageExpires) as! Bool
        
        // Gets how many days an image will expire in
        let tempInt = defaults.object(forKey: UD.imageExpiresIn) as! Int
        imageExpiresIn.text = String(tempInt)
        
        // Sets the wifi only setting
        wifiOnlyOutlet.isOn = defaults.object(forKey: UD.isWIFIOnly) as! Bool
        
        view.backgroundColor = ThemeManager.applyBackground(theme: UserDefaults.standard.object(forKey: UD.themeIndex) as? Int ?? 0)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
