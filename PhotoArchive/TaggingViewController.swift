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
    
    @IBOutlet weak var appCollectionView: UICollectionView!
    
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    let appImageArray = [UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder")]
    
    var galleryImageArray = [UIImage]()
    
    var tagButtonArray = ["AA Medium Title", "AA Medium Title", "AA Medium Title", "AA Medium Title"]
    
    var selectedTagContext = 0
    @IBOutlet weak var uploadImagesAndTagsButtonOutlet: UIButton!
    
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
        
        for context in 0..<globalObject.sharedInstance.Attributes.count {
            tagButtonArray.append(globalObject.sharedInstance.Attributes[context].id)
        }
    }
    
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Collection view for the images taken within the application
        appCollectionView.delegate = self
        appCollectionView.dataSource = self
        self.view.addSubview(appCollectionView)
        
        // Collection view for the images taken outside the application
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        self.view.addSubview(galleryCollectionView)
        grabPhotos()
        
        // Collection view for context buttons
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        self.view.addSubview(tagCollectionView)
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
        uploadImagesAndTagsButtonOutlet.setTitle("Upload \(globalObject.sharedInstance.GalleryImages.count) Images with \(globalObject.sharedInstance.Attributes.count) Tags", for: UIControlState.normal)
        uploadImagesAndTagsButtonOutlet.titleLabel?.textAlignment = .center
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
            
            return CGSize(width: label.frame.width+4, height: label.frame.height+4)
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
