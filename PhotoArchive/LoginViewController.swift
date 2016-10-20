//
//  LoginViewController.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 10/19/16.
//  Copyright © 2016 AF-PENS. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // remmeber me uiswitch
    @IBOutlet weak var rememberMeButton: UISwitch!
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        //verifies login
        
        
        // if user who just logged in, is not the user previously logged in
        
        // if login is successful and switch is on
        if rememberMeButton.isOn {
            // remember the user for a certain amount of time
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
