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
    
    // All of th objects to be uploaded
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
        
        permissionStatusText.text = "Correct"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Hides the navigation controller
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Hides the navigation controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated);

    }
    
    // Hides the navigation controller
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
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return uploadObjects.count
    }
    
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
                
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Performs the segue to view the main object
        self.performSegue(withIdentifier: "dashboardShowImage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // -- Double check to see if this is necessary --
        if segue.identifier == "dashboardShowImage" {
            let indexPaths = self.collectionView.indexPathsForSelectedItems!
            let indexPath = indexPaths[0] as NSIndexPath
            
            // Establishes next view controller to be 'DashboardImageViewController'
            let vc = segue.destination as! DashboardImageViewController
            
            // Establish FileManager object
            let fileMngr = FileManager.default
            
            // Establish path to 'Documents'
            let docURL = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            // Gets the location of the image from the appropriate 'UploaObject'
            let thumbnailPath = docURL.appendingPathComponent(uploadObjects[indexPath.row].imageLocation)
            
            // Imports the image
            let image = UIImage(contentsOfFile: thumbnailPath.path)!
            
            // Sets the image to be displayed
            vc.image = image
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
