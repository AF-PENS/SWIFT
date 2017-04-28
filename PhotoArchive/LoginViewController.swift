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
            
            // Sets up the application for the user
            setup(user: inputUsername.text!)
            
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
    
    // MARK: - User Functions
    
    /**
     Sets up the environment for the user. 
     Takes into consideration if this is the first time the application is being used, if this is the same user logging in from before or if this is a new user logging in.
     
     - Parameter username:   The username of the user.
     */
    func setup(user: String) {
        
        // Establish defaults object to load persistent data
        let defaults = UserDefaults.standard
        
        // Gets the pervious username, if there is one
        let perviousUser = defaults.object(forKey: UD.username) as? String
        
        // Executes if this is the first time a user has ever used the application
        if perviousUser == nil {
            
            // Save the user to defaults
            defaults.set(user, forKey: UD.username)
            
            // Create new directory in the 'Documents' directory
            // Establish FileManager object
            let fileMngr = FileManager.default
            
            // Establish path to 'Documents'
            let docPath = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            // Establish path for 'CameraImages' in 'Documents'
            let cameraImagesPath = docPath.appendingPathComponent("CameraImages").path
            
            // Create the 'CameraImages' Folder
            do {
                try fileMngr.createDirectory(atPath: cameraImagesPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating 'CameraImages' directory.")
            }
            
            // Establish path for 'UploadImages' in 'Documents'
            let uploadImagesPath = docPath.appendingPathComponent("UploadImages").path
            
            // Create the 'UploadImages' Folder
            do {
                try fileMngr.createDirectory(atPath: uploadImagesPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating 'UploadImages' directory.")
            }
        }
        // Executes if this application has been used before
        else {
            // Executes if current user is not previous user
            if user != perviousUser {
            
                // Save the new user to defaults
                defaults.set(user, forKey: UD.username)
                
                // Deleting everything in the 'CameraImages' and 'UploadImages' directories
                // Establish FileManager object
                let fileMngr = FileManager.default
                
                // Establish path to 'Documents'
                let docPath = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0]
                
                // Establish path for 'CameraImages' in 'Documents'
                let cameraImagesPath = docPath.appendingPathComponent("CameraImages").path
                
                // Delete everything in 'CameraImages' Folder
                do {
                    let filePaths = try fileMngr.contentsOfDirectory(atPath: cameraImagesPath)
                    for filePath in filePaths {
                        try fileMngr.removeItem(atPath: cameraImagesPath + "/" + filePath)
                    }
                } catch {
                    print("Error deleting files in 'CameraImages' directory")
                }
                
                // Establish path for 'UploadImages' in 'Documents'
                let uploadImagesPath = docPath.appendingPathComponent("UploadImages").path
                
                // Delete everything in 'UploadImages' Folder
                do {
                    let filePaths = try fileMngr.contentsOfDirectory(atPath: uploadImagesPath)
                    for filePath in filePaths {
                        try fileMngr.removeItem(atPath: uploadImagesPath + "/" + filePath)
                    }
                } catch {
                    print("Error deleting files in 'UploadImages' directory")
                }
            }
            // Executes if current user is previous user
            else {
                // Do nothing... 
            }
        }
    }
}
