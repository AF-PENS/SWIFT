//
//  LoginViewController.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 1/26/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//
//  NOTE: Look for the 'DEBUG MODE' notes.
//

import UIKit

class LoginViewController: UIViewController {

    // Outlets on screen
    @IBOutlet weak var inputUsername: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    
    // Action 'Login' button on screen
    @IBAction func loginButton(_ sender: Any) {
        
        // Continues executing if login was correct
        // Currently, to log in, leave input fields blank
        if !(inputUsername.text == "" && inputPassword.text == "") {
            
            // Creates an alert to notify user login was incorrect
            let alert = UIAlertController(title: "Alert", message: "Please enter correct Information", preferredStyle: UIAlertControllerStyle.alert)
            
            // Creates button prompt for the alert
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                
                // Dismiss alert once user acknowledges
                alert.dismiss(animated: true, completion: nil)
            }))
            
            // Present alert to the user
            self.present(alert, animated: true, completion: nil)
            
            // Return to the Login view
            return
        }
        
        // Establish defaults object to load persistent data
        let defaults = UserDefaults.standard
        
        // Gets the pervious username, if there is one
        let previousUser = defaults.object(forKey: UD.username) as? String
        
        // Executes if this is the first time a user has ever used the application
        if previousUser == nil {
            
            // Sets up the application for first time use
            setupFirstTime(user: inputUsername.text!)
            
            // Presents the main view controller to the rest of the application
            presentMain()
        }
        // Executes if this application has been used before
        else {
            // Executes if current user is not previous user
//            if inputUsername.text! != previousUser {
            
            
                
            // ----- START DEBUG MODE -----
            // DELETE DEBUG MODE IN PRODUCTION
            // Will not execute this entire if statement
            // Delete this block for normal functionality
            // Uncomment line 62 for normal functionality
            if false {
            // DELETE DEBUG MODE IN PRODUCTION
            // ----- END DEBUG MODE -----
                
                
                
                // Alert to inform the user that because current user is not the previous user, all information on the application will be erased. Provide the option of cancelling the login process.
                // Create alert
                let alert = UIAlertController(title: "Different User", message: "This app is detecting that the user currently logging in is not the previous user which logged in last. Proceeding will erase all pending uploads and internal images.", preferredStyle: UIAlertControllerStyle.alert)
                
                // Add 'Proceed' button
                alert.addAction(UIAlertAction(title: "Proceed", style: UIAlertActionStyle.destructive, handler: { action in
                    
                    // Dismiss the alert once user aknowledges
                    alert.dismiss(animated: true, completion: nil)
                    
                    // Erase previous user's data
                    self.setupNewUser(user: self.inputUsername.text!)
                    
                    // Presents the main view controller to the rest of the application
                    self.presentMain()
                }))
                
                // Add 'Cancel' button
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { action in
                    
                    // Dismiss the alert once user aknowledges
                    alert.dismiss(animated: true, completion: nil)
                    
                    // Return to the Login view
                    return
                }))
                
                // Present the alert
                self.present(alert, animated: true, completion: nil)
            }
            // Executes if current user is previous user
            else {
                
                // Load as normal because current user is previous user
                presentMain()
            }
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
     Presents the next view to the main application.
    */
    func presentMain() {
        // Opens up the main storyboard
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        // Sets up a connection to the main tab controller
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        
        // Segues to the Dashboard View
        self.present(resultViewController, animated:true, completion:nil)
    }
    
    /**
     Sets up the environment for the user. Assumes the application has never been used.
     
     - Parameter user: The username of the user.
     */
    func setupFirstTime(user: String) {
        // Establish defaults object to load persistent data
        let defaults = UserDefaults.standard
        
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
    
    /**
     Sets up the environment for a new user. Assumes that the application has been already used on this device.
     
     - Parameter user: The username of the user.
     */
    func setupNewUser(user: String) {
        
        // Establish defaults object to load persistent data
        let defaults = UserDefaults.standard
                
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
}
