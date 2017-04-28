//
//  TaggingViewController.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 1/26/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import UIKit
import Photos

class TaggingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Three main collection views on the view
    @IBOutlet weak var appCollectionView: UICollectionView!         // Responsible for images taken within application
    @IBOutlet weak var galleryCollectionView: UICollectionView!     // Responsible for images taken outside application
    @IBOutlet weak var tagCollectionView: UICollectionView!         // Responsible for contexts selected
    
    // Outlet displays how many images and contexts are about to be uploaded
    @IBOutlet weak var uploadImagesAndTagsButtonOutlet: UIButton!
    
    // Three arrays which contain images/contexts for three main collection views
    var appImageArray = [UIImage]()         // Responsible for holding images for appCollectionView
    var galleryImageArray = [UIImage]()     // Responsible for holding images for galleryCollectionView
    var tagButtonArray = [String]()         // Responsible for holding contexts for tagCollectionView
    
    // Variable to pass to the TaggingSelected View Controllers
    // Set to '-1' because indexPaths can never have a row that is negative
    var selectedTagContext = -1
    
    // Action which pairs up the selected contexts with the selected images
    @IBAction func uploadImagesAndTagsButton(_ sender: Any) {
        
        // Creates an alert to notify user if images/contexts have not been selected -- Will not save anything
        // Executes if the user has not selected any contexts
        if global.shared.tagContexts.count == 0 {
            
            // Create alert
            let alert = UIAlertController(title: "Tags", message: "There are currently no selected tags. Please select a tag and upload again.", preferredStyle: UIAlertControllerStyle.alert)
            
            // Add the 'OK' button
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // Present the alert
            self.present(alert, animated: true, completion: nil)
        }
        // Executes if the user has not selected any images
        else if global.shared.appImages.count + global.shared.galleryImages.count == 0 {
            
            // Create alert
            let alert = UIAlertController(title: "Images", message: "There are currently no selected images. Please select an image and upload again.", preferredStyle: UIAlertControllerStyle.alert)
            
            // Add the 'OK' button
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // Present the alert
            self.present(alert, animated: true, completion: nil)
        }
        // Executes if the user has not selected any contexts or images
        else if global.shared.tagContexts.count == 0 ||
            global.shared.appImages.count + global.shared.galleryImages.count == 0{
            
            // Create alert
            let alert = UIAlertController(title: "Images and Tags", message: "There are currently no selected images or tags. Please select an image or tag and upload again.", preferredStyle: UIAlertControllerStyle.alert)
            
            // Add the 'OK' button
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // Present the alert
            self.present(alert, animated: true, completion: nil)
        }
        
        var uploadObjects = [UploadObject]()
        
        for i in 0..<global.shared.galleryImages.count {
            let temp = UploadObject(context: global.shared.tagContexts, imageLocalIdentifier: global.shared.galleryImages[i].localIdentifier, isAppImage: false, isGalleryImage: true)
            uploadObjects.append(temp)
        }
        
        for i in 0..<global.shared.appImages.count {
            let temp = UploadObject.init(context: global.shared.tagContexts, imageLocalIdentifier: global.shared.appImages[i], isAppImage: true, isGalleryImage: false)
            uploadObjects.append(temp)
        }
        
        global.shared.tagContexts.removeAll()
        global.shared.galleryImages.removeAll()
        global.shared.appImages.removeAll()
        
        uploadImagesAndTagsButtonOutlet.setTitle("Upload \(global.shared.galleryImages.count + global.shared.appImages.count) Images with \(global.shared.tagContexts.count) Tags", for: UIControlState.normal)
        uploadImagesAndTagsButtonOutlet.titleLabel?.textAlignment = .center
        
        var values = [UploadObject]()
        
        if (PersistenceManager.loadNSArray(.UploadObjects) as? [UploadObject]) != nil {
            values = PersistenceManager.loadNSArray(.UploadObjects) as! [UploadObject]
        }
        
        for object in uploadObjects {
            values.append(object)
        }
        
        PersistenceManager.saveNSArray(values as NSArray, path: .UploadObjects)
        
    }
    // prepares for a segue transition from the Attribute pages
    @IBAction func unwindToTaggingViewController(segue:UIStoryboardSegue) { }
    
    ///////////////////////////////////////
    func grabPhotos(){
        
        let imgManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .fastFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        if let fetchResult : PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions){

            if fetchResult.count > 0{
                var index = fetchResult.count
                
                if index > 15 {
                    index = 15
                }
                for i in 0..<index{
                    let asset =  fetchResult.object(at: i) /*as! PHAsset*/
                    
                    imgManager.requestImage(for: fetchResult.object(at: i) /*as! PHAsset*/, targetSize: CGSize(width: 80,height: 80), contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, error) in
                        self.galleryImageArray.append(image!)
                    })
                }
            }
            else{
                print("you got no photos")
                /*self.collectionView?.reloadData()*/
            }
        }
    }
    
    // Generates the buttons which contain the newly added contexts
    func generateContextButtons() {
        
        // Clears out the elements in tagButtonArray in order to not create duplicates
        tagButtonArray.removeAll()
        
        for context in 0..<global.shared.tagContexts.count {
            tagButtonArray.append(global.shared.tagContexts[context].id)
        }
    }
    
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Collection view for the images taken within the application
        appCollectionView.delegate = self
        appCollectionView.dataSource = self
//        self.view.addSubview(appCollectionView)
        
        // Collection view for the images taken outside the application
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
//        self.view.addSubview(galleryCollectionView)
        grabPhotos()
        
        // Collection view for context buttons
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
//        self.view.addSubview(tagCollectionView)
        generateContextButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Hides the navigation controller
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }
    
    // Hides the navigation controller
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        generateContextButtons()
        tagCollectionView.reloadData()
        uploadImagesAndTagsButtonOutlet.setTitle("Upload \(global.shared.galleryImages.count + global.shared.appImages.count) Images with \(global.shared.tagContexts.count) Tags", for: UIControlState.normal)
        uploadImagesAndTagsButtonOutlet.titleLabel?.textAlignment = .center
        
        appImageArray.removeAll()
        
        // Get the document directory url
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            
            // if you want to filter the directory contents you can do like this:
            let files = directoryContents.filter{ $0.pathExtension == "jpg" }
            
            for file in files {

                appImageArray.append(UIImage(contentsOfFile: file.path)!)
                
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        appCollectionView.reloadData()
    }
    
    // for the inapp images and buttons
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.appCollectionView {
            return self.appImageArray.count
        }
        else if collectionView == self.galleryCollectionView {
            return self.galleryImageArray.count
        }
        else {
            return self.tagButtonArray.count
        }
    }
    
    // creates the cells for the 3 different collection views
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // checks to see which collection view is being called
        if collectionView == self.appCollectionView {
            
            // creates the cell to display the image
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaggingAppCell", for: indexPath) as! TaggingAppCollectionViewCell

            cell.imageView?.image = self.appImageArray[indexPath.row]
            
            return cell
        }
        else if collectionView == self.galleryCollectionView {
            
            // creates the cell to display the image
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaggingGalleryCell", for: indexPath) as! TaggingGalleryCollectionViewCell

            cell.imageView?.image = self.galleryImageArray[indexPath.row]
            
            return cell
        }
        else {
            // creates the cell to display the image
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaggingTagCell", for: indexPath) as! TaggingTagCollectionViewCell
            
            cell.title.text = tagButtonArray[indexPath.row]
            
            return cell
        }
    }
    
    // changes the cell size for the images and the tags
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // resizes the tag context cell based on the lenght of the name of the context
        if collectionView == tagCollectionView {
            
            let label =  UILabel()
            label.numberOfLines = 0
            label.text = tagButtonArray[indexPath.row]
            label.sizeToFit()
            
            return CGSize(width: label.frame.width+10, height: label.frame.height)
        }
        else {
            // current defaults set in interface builder
            return CGSize(width: 70, height: 70)
        }
    }
    
    // gets the selected item to pass
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tagCollectionView {
            let currentCell = collectionView.cellForItem(at: indexPath) as! TaggingTagCollectionViewCell
            selectedTagContext = indexPath.row
            
            performSegue(withIdentifier: "TaggingSelectedContextsAttributesSegue", sender: self)
        }
    }
    
    // prepares a segue to send data to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TaggingSelectedContextsAttributesSegue" {
            let vc = segue.destination as! TaggingSelectedContextsAttributesTableViewController
            vc.context = selectedTagContext
        }
    }
    
//    // prepares for a segue transition from the Attribute pages
//    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
//        // no actual code necessary -- function just must exit in the controller
//    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
