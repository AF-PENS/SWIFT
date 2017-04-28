//
//  LoginViewController.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 1/26/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // Outlets on screen
    @IBOutlet weak var inputUsername: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    
    // Action 'Login' button on screen
    @IBAction func loginButton(_ sender: Any) {
        
        // Executes if login was correct
        // Currently, to log in, leave input fields blank
        if inputUsername.text == "" && inputPassword.text == "" {
            
            // Opens up the main storyboard
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            // Sets up a connection to the main tab controller
            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
            
            // Segues to the Dashboard View
            self.present(resultViewController, animated:true, completion:nil)
        }
        // Executes if login was not correct
        else {
            // Creates an alert to notify the user the login was incorrect
            let alert = UIAlertController(title: "Alert", message: "Please enter correct Information", preferredStyle: UIAlertControllerStyle.alert)
            
            // Creates the button prompt for the alert
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            // Present the alert to the user
            self.present(alert, animated: true, completion: nil)
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
