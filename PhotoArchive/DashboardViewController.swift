//
//  DashboardViewController.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 1/26/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class DashboardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // Text labels which display the status and permission
    @IBOutlet weak var tagsStatusText: UITextField!
    @IBOutlet weak var permissionStatusText: UITextField!

    // Collection view to display all images in the upload queue
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Sets the size of the images in the cell thumbnails -- Current defaults set in the interface builder
    let thumbnailSize = CGSize(width: 80, height: 80)
    
    // All objects to be uploaded
    var uploadObjects = [UploadObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagsStatusText.text = "Syncing..."

        //Pull Contexts from DB and save to global variable
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        let client = delegate.client!;
        
        let contextTable = client.table(withName: "Context");
        
        contextTable.read(completion: {
            (result, error) in
            if let err = error {
            } else if let contextResults = result?.items {
                for context in contextResults {
                    global.shared.dbContexts.append(
                        Context(
                            id: context["id"] as! String,
                            descriptor: context["descriptor"] as! String
                        )
                    )
                }
                
                self.tagsStatusText.text = "Up To Date"
            }
        })
        
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(DashboardViewController.applicationDidBecomeActive(_:)),
            name: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Hides the navigation controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hides the navigation controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // Loads 'UploadObjects' from persistent memory
        if (PersistenceManager.loadNSArray(.UploadObjects) as? [UploadObject]) != nil {
            uploadObjects = PersistenceManager.loadNSArray(.UploadObjects) as! [UploadObject]
        }
        
        // Reloads Dashboard collection view
        collectionView.reloadData()
        
        // Updates permissions
        updatePermissions()
        
        view.backgroundColor = ThemeManager.applyBackground(theme: UserDefaults.standard.object(forKey: UD.themeIndex) as! Int)
    }
    
    // Function is specifically called if the application is interrupted
    @objc private func applicationDidBecomeActive(_ notification: NSNotification) {
        
        // Updates permissions
        updatePermissions()
    }
    
    // Asks your data source object for the number of items in the specified section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // The amount of objects to be displayed
        return uploadObjects.count
    }
    
    // Asks your data source object for the cell that corresponds to the specified item in the collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Establish current object of this cell
        let object = uploadObjects[indexPath.row]
        
        // Cell configuration
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dashboardCell", for: indexPath) as! DashboardCollectionViewCell

        // Establish FileManager object
        let fileMngr = FileManager.default
        
        // Establish path to 'Documents'
        let docURL = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // Gets location of the image
        let thumbnailPath = docURL.appendingPathComponent(object.thumbnailLocation)
        
        // Imports image
        let image = UIImage(contentsOfFile: thumbnailPath.path)!
        
        // Adds image to cell
        cell.imageView.image = image
        
        // Returns the cell to be loaded
        return cell
        
    }
    
    // Tells the delegate that the item at the specified index path was selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Performs the segue to view the main object
        self.performSegue(withIdentifier: "dashboardShowImage", sender: self)
    }
    
    
    // MARK: - Navigation
    
    /**
     Prepares for a segue transition from the Dashboard to the ImageViewer.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Gets the indexPath of the selected cell
        let indexPath = collectionView.indexPathsForSelectedItems![0]
        
        // Establishes next view controller to be 'DashboardImageViewController'
        let nextViewController = segue.destination as! DashboardImageViewController
        
        // Passes in the obect to be displayed
        nextViewController.uploadObject = uploadObjects[indexPath.row]
    }
    
    // Prepares for a segue transition from the Attribute pages
    @IBAction func unwindToDashboardViewController(segue:UIStoryboardSegue) {}
    
    
    // MARK: - User Functions
    
    /**
        Check to see if wifi is available.
     
        - Returns: Bool: true if wifi is active; false if it is not
     */
    func isWIFIOn() -> Bool {
        
        // Checks to see what the user has set on the Settings page
        // Executes if user has only wifi turned to on
        if UserDefaults.standard.object(forKey: UD.isWIFIOnly) as! Bool {
            
            // Establish object to check status of wifi
            let reachability = Reachability()!
            
            // Executes if wifi is connected
            if reachability.isReachableViaWiFi {
                
                // Returns true
                return true
            }
            // Executes if wifi is not connected
            else {
                
                // Returns false
                return false
            }
        }
        // Executes if user is willing to upload over any connection
        else {
            
            // Returns true
            return true
        }
    }
    
    /**
     Check to see if GPS is available.
     
     - Returns: Bool: true if GPS is active; false if it is not
     */
    func isGPSOn() -> Bool {
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            }
        }
        else {
            return false
        }
    }
    
    /**
     Check to see if Photos are available.
     
     - Returns: Bool: true if Photos are active; false if it is not
     */
    func isPhotosOn() -> Bool {
        
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            return true
        }
        else {
            return false
        }
    }
    
    /**
     Check to see if Camera is available.
     
     - Returns: Bool: true if Camera is active; false if it is not
     */
    func isCameraOn() -> Bool {
        
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) ==  AVAuthorizationStatus.authorized
        {
            return true
        }
        else {
            return false
        }
    }
    
    /**
        This should be called whenever there is a check to make sure the permissions are set up correctly.
     */
    func updatePermissions() {
        
        // Executes if the wifi is not turned on
        if !isWIFIOn() {
        
            // Informs the user that wifi is turned off
            permissionStatusText.text = "Wifi is off"
            
        }
        // Executes if the GPS is not turned on within the application
        else if !isGPSOn() {
            
            // Informs the user that GPS is turned off
            permissionStatusText.text = "GPS is turned off"
        }
        // Executes if the GPS is not turned on within the application
        else if !isPhotosOn() {
            
            // Informs the user that there is no access to iPhone photos
            permissionStatusText.text = "No photos access"
        }
        // Executes if the GPS is not turned on within the application
        else if !isCameraOn() {
            
            // Informs user that camera functionality is not allowed
            permissionStatusText.text = "No camera access"
        }
        // Executes if everything is set up correctly
        else {
            permissionStatusText.text = "Correct"
        }
    }
}
