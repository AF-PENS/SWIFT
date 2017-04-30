//
//  TaggingViewController.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 1/26/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import UIKit
import Photos
import ImageIO

class TaggingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Three main collection views on the view
    @IBOutlet weak var appCollectionView: UICollectionView!         // Responsible for images taken within application
    @IBOutlet weak var galleryCollectionView: UICollectionView!     // Responsible for images taken outside application
    @IBOutlet weak var tagCollectionView: UICollectionView!         // Responsible for contexts selected
    
    // Outlet displays how many images and contexts are about to be uploaded
    @IBOutlet weak var uploadButtonOutlet: UIButton!
    
    // Three arrays which contain images/contexts for three main collection views
    var appImageArray = [UIImage]()         // Responsible for holding images for appCollectionView
    var galleryImageArray = [UIImage]()     // Responsible for holding images for galleryCollectionView
    var tagArray = [String]()               // Responsible for holding contexts for tagCollectionView
    
    // Variable to pass to the TaggingSelected View Controllers
    // Set to '-1' because indexPaths can never have a row that is negative
    var selectedTagContext = -1
    
    // Sets the size of the images in the cell thumbnails -- Current defaults set in the interface builder
    let thumbnailSize = CGSize(width: 80,height: 80)
    
    // Action which pairs up the selected contexts with the selected images
    @IBAction func uploadButton(_ sender: Any) {
        
        // Creates an alert to notify user if images/contexts have not been selected -- Will not save anything
        // Executes if the user has not selected any contexts or images
        if global.shared.tagContexts.count == 0 &&
            global.shared.appImages.count + global.shared.galleryImages.count == 0 {
            
            // Create alert
            let alert = UIAlertController(title: "Images and Tags", message: "There are currently no selected images or tags. Please select an image or tag and upload again.", preferredStyle: UIAlertControllerStyle.alert)
            
            // Add the 'OK' button
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                
                // Dismiss the alert once user aknowledges
                alert.dismiss(animated: true, completion: nil)
                
                // Returns the control back to the Tagging view controller
                return
            }))
            
            // Present the alert
            self.present(alert, animated: true, completion: nil)
        }
        // Executes if the user has not selected any contexts
        else if global.shared.tagContexts.count == 0 {
            
            // Create alert
            let alert = UIAlertController(title: "Tags", message: "There are currently no selected tags. Please select a tag and upload again.", preferredStyle: UIAlertControllerStyle.alert)
            
            // Add the 'OK' button
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            
                // Dismiss the alert once user aknowledges
                alert.dismiss(animated: true, completion: nil)
                
                // Returns the control back to the Tagging view controller
                return
            }))
            
            // Present the alert
            self.present(alert, animated: true, completion: nil)
        }
        // Executes if the user has not selected any images
        else if global.shared.appImages.count + global.shared.galleryImages.count == 0 {
            
            // Create alert
            let alert = UIAlertController(title: "Images", message: "There are currently no selected images. Please select an image and upload again.", preferredStyle: UIAlertControllerStyle.alert)
            
            // Add the 'OK' button
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            
                // Dismiss the alert once user aknowledges
                alert.dismiss(animated: true, completion: nil)
                
                // Returns the control back to the Tagging view controller
                return
            }))
            
            // Present the alert
            self.present(alert, animated: true, completion: nil)
        }
        // Executes if there are images and contexts selected
        else {
            
            // Grabs the images and contexts, combines them together and sends them to the Upload Queue
            createUploadObjects()
        }
    }
    
    // Prepares for a segue transition from the Attribute pages
    @IBAction func unwindToTaggingViewController(segue:UIStoryboardSegue) {}
    
    // Do any additional setup after loading the view
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Dispose of any resources that can be recreated
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Hides the navigation controller
    override func viewWillDisappear(_ animated: Bool) {
        
        // Hides the embedded navigation bar at the top of the controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        
        // Forces the view to disapear
        super.viewWillDisappear(animated)
    }
    
    // Hides the navigation controller
    override func viewWillAppear(_ animated: Bool) {
        
        // Hides the embedded navigation bar at the top of the controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

        // Forces the view to appear
        super.viewWillAppear(animated)
        
        // Generates images for 'appCollectionView'
        generateAppImages()
        
        // Generates images for 'galleryImageArray'
        generateGalleryImages()
        
        // Generates contexts for 'tagArray'
        generateContexts()
        
        // Refreshes the upload button
        refreshUploadButton()
    }
    
    // Asks your data source object for the number of items in the specified section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Executes if the current collection view is 'appCollectionView'
        if collectionView == appCollectionView {
            
            // Returns the total count
            return appImageArray.count
        }
        // Executes if the current collection view is 'galleryCollectionView'
        else if collectionView == galleryCollectionView {
            
            // Returns the total count
            return galleryImageArray.count
        }
        // Executes if the current collection view is 'tagCollectionView'
        else if collectionView == tagCollectionView {
            
            // Returns the total count
            return tagArray.count
        }
        // Executes if the current collection view is unknown
        else {
            
            // Returns 0, becaue this should never execute
            return 0
        }
    }
    
    // Asks your data source object for the cell that corresponds to the specified item in the collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Executes if the current collection view is 'appCollectionView'
        if collectionView == appCollectionView {
            
            // Creates reusable 'TaggingAppCell' cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaggingAppCell", for: indexPath) as! TaggingAppCollectionViewCell

            // Sets the image variable within cell to display the correct image
            cell.thumbnailImage = appImageArray[indexPath.row]
            
            // Returns the cell
            return cell
        }
        // Executes if the current collection view is 'galleryCollectionView'
        else if collectionView == galleryCollectionView {
            
            // Creates reusable 'TaggingGalleryCell' cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaggingGalleryCell", for: indexPath) as! TaggingGalleryCollectionViewCell
            
            // Sets the image variable within cell to display correct image
            cell.thumbnailImage = galleryImageArray[indexPath.row]
            
            // Returns the cell
            return cell
        }
        // Executes if the current collection view is 'tagCollectionView'
        else if collectionView == tagCollectionView {
            
            // Creates reusable 'TaggingTagCell' cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaggingTagCell", for: indexPath) as! TaggingTagCollectionViewCell
            
            // Sets the string variable within the cell to display correct context title
            cell.title.text = tagArray[indexPath.row]
            
            return cell
        }
        // Executes if the current collection view is unknown
        else {
            
            // Creates reusable default cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reusableCell", for: indexPath) 
            
            // Returns default cell, because this should never execute
            return cell
        }
    }
    
    // Asks the delegate for the size of the specified item’s cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Executes if the current collection view is 'tagCollectionView'
        if collectionView == tagCollectionView {
            
            // Creates a new label
            let label =  UILabel()
            
            // Sets the number of lines in the label
            label.numberOfLines = 0
            
            // Grabs the appropriate string from 'tagArray' which is currently being displayed in the cell
            label.text = tagArray[indexPath.row]
            
            // Resize the label within the cell to fit the text
            label.sizeToFit()
            
            // Returns the correct cell dimension -- pads the left/right insets of the cell
            return CGSize(width: label.frame.width+10, height: label.frame.height+10)
        }
        // Executes if the current collection view is not 'tagCollectionView'
        else {
            
            // Returns current set size in the beginning of the view controller
            return thumbnailSize
        }
    }
    
    // Tells the delegate that the item at the specified index path was selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Executes if the current collection view is 'tagCollectionView'
        if collectionView == tagCollectionView {
            
            // Grabs the current selected context to pass to the next view controller
            selectedTagContext = indexPath.row
            
            // Performs a segue to the next view controller
            performSegue(withIdentifier: "TaggingSelectedContextsAttributesSegue", sender: self)
        }
    }
    
    // MARK: - Navigation
     
    // Prepares a segue to send data to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TaggingSelectedContextsAttributesSegue" {
            let vc = segue.destination as! TaggingSelectedContextsAttributesTableViewController
            vc.context = selectedTagContext
        }
    }
    
    // MARK: - User Functions
    
    /**
     Creates the objects which will be sent to the upload queue.
     */
    func createUploadObjects() {
        
//        var uploadObjects = [UploadObject]()
//        
//        for i in 0..<global.shared.galleryImages.count {
////            let temp = UploadObject(context: global.shared.tagContexts, imageLocalIdentifier: global.shared.galleryImages[i].localIdentifier, isAppImage: false, isGalleryImage: true)
////            uploadObjects.append(temp)
//        }
//        
//        for i in 0..<global.shared.appImages.count {
////            let temp = UploadObject.init(context: global.shared.tagContexts, imageLocalIdentifier: global.shared.appImages[i], isAppImage: true, isGalleryImage: false)
////            uploadObjects.append(temp)
//        }
//        
//        global.shared.tagContexts.removeAll()
//        global.shared.galleryImages.removeAll()
//        global.shared.appImages.removeAll()
//        
//        uploadButtonOutlet.setTitle("Upload \(global.shared.galleryImages.count + global.shared.appImages.count) Images with \(global.shared.tagContexts.count) Tags", for: UIControlState.normal)
//        uploadButtonOutlet.titleLabel?.textAlignment = .center
//        
//        var values = [UploadObject]()
//        
//        if (PersistenceManager.loadNSArray(.UploadObjects) as? [UploadObject]) != nil {
//            values = PersistenceManager.loadNSArray(.UploadObjects) as! [UploadObject]
//        }
//        
//        for object in uploadObjects {
//            values.append(object)
//        }
//        
//        PersistenceManager.saveNSArray(values as NSArray, path: .UploadObjects)
    }
    
    /**
     Generates the images taken by the application's camera from internal storage and places them in 'appCollectionView'
     */
    func generateAppImages() {
        
        // Removes all images from 'appImageArray' in case new images were taken
        appImageArray.removeAll()
        
        // Establish FileManager object
        let fileMngr = FileManager.default
        
        // Establish path to 'Documents'
        let docPath = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // Establish URL for 'CameraImages' in 'Documents'
        let cameraImagesURL = docPath.appendingPathComponent("CameraImages")
        
        // Establish URL for 'Thumbnail' in 'CameraImages'
        let cameraThumbnailURL = URL(string: cameraImagesURL.appendingPathComponent("Thumbnail").path)!
        
        // Cycles through every file in 'CameraImages' directory and adds them to the 'appImageArray'
        do {
            // Grabs every file in 'Thumbnail' directory in 'CameraImages' directory
            let files = try fileMngr.contentsOfDirectory(at: cameraThumbnailURL, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants)
            
            // Sorts the files to display the most recent first
            let sortedFiles = files.sorted(by: { s1, s2 in s1.absoluteString > s2.absoluteString })
            
            // Sets the amount of cells to display on the horizontal scroll
            var itemDisplay = 15
            
            // Checks to see if 'files' contains less items than 'itemDisplay'
            if files.count < itemDisplay {
                itemDisplay = sortedFiles.count
            }
            
            // Cycles through every single file
            for i in 0..<itemDisplay {
                
                // Creates an image and appends it to 'appImageArray'
                let image = UIImage(contentsOfFile: sortedFiles[i].path)!
                
                // Append in image to 'appImageArray'
                appImageArray.append(image)
            }
        } catch  {
            print("Eroor attempting to get images from 'CameraImages' Directory")
        }
        
        // Reloads data in 'appCollectionView'
        appCollectionView.reloadData()
    }
    
    /**
     Generates the images from iPhone Photo Library to display them in 'galleryCollectionView'.
     */
    func generateGalleryImages() {
        
        // Clears out the elements in 'galleryImageArray' in order to not create duplicates and display if new images
        galleryImageArray.removeAll()
        
        // Creates an Image Manager object to pull images from iPhone Photos
        let imageMngr = PHImageManager.default()
        
        // Sets the options for the image request
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true             // Loads the images synchronously
        requestOptions.deliveryMode = .fastFormat       // Loads the images as quickly as possible -- no need for quality for thumbnails
        
        // Sets the options for how the images will be fetched from iPhone Photos
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]    // Sorts in descending order
        
        // Fetches all of the images which
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        // Sets the amount of cells to display on the horizontal scroll
        var itemDisplay = 15
        
        // Checks to see if 'fetchResult' contains less items than 'itemDisplay'
        if fetchResult.count < itemDisplay {
            itemDisplay = fetchResult.count
        }
        
        // Loops through every item in the fetchResult
        for i in 0..<itemDisplay {

            // Requests the images from the Image Manager
            imageMngr.requestImage(for: fetchResult.object(at: i), targetSize: thumbnailSize, contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, info) in
                
                // Appends an image to 'galleryImageArray'
                self.galleryImageArray.append(image!)
            })
        }
        
        // Reloads data in 'galleryCollectionView'
        galleryCollectionView.reloadData()
    }
    
    /**
     Generates the contexts that were selected to display them in 'tagCollectionView'.
    */
    func generateContexts() {
        
        // Clears out the elements in tagArray in order to not create duplicates
        tagArray.removeAll()
        
        // Cycles through every context in the global contexts attribute
        for context in 0..<global.shared.tagContexts.count {
            
            // Appends new contexts to 'tagArray'
            tagArray.append(global.shared.tagContexts[context].id)
        }
        
        // Reloads data in 'tagCollectionView'
        tagCollectionView.reloadData()
    }
    
    /**
     Refreshes the label within the 'uploadButton' to inform the user how many images/contexts they are about to upload.
     */
    func refreshUploadButton() {
        
        // Sets the new label to be: "Upload ___ Images with ___ Tags"
        uploadButtonOutlet.setTitle("Upload \(global.shared.galleryImages.count + global.shared.appImages.count) Images with \(global.shared.tagContexts.count) Tags", for: UIControlState.normal)
        
        // Aligns the text in 'uploadButton'
        uploadButtonOutlet.titleLabel?.textAlignment = .center
    }
}
