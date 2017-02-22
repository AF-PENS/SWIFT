//
//  TaggingViewController.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 1/26/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import UIKit
import Photos

class TaggingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var appCollectionView: UICollectionView!
    
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    let appImageArray = [UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder")]
    
    var galleryImageArray = [UIImage]()
    
    var tagButtonArray = [UIButton]()
    
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
    //////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        appCollectionView.delegate = self
        appCollectionView.dataSource = self
        self.view.addSubview(appCollectionView)
        
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        self.view.addSubview(galleryCollectionView)
        grabPhotos()
        
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        self.view.addSubview(tagCollectionView)
        
        //setting button placeholders for testing
        ///////////////////////
        
        tagButtonArray.append(UIButton())
        tagButtonArray.append(UIButton())
        tagButtonArray.append(UIButton())
        tagButtonArray.append(UIButton())
        tagButtonArray.append(UIButton())
        tagButtonArray.append(UIButton())
        tagButtonArray.append(UIButton())
        tagButtonArray.append(UIButton())
        tagButtonArray.append(UIButton())
        tagButtonArray.append(UIButton())
        ///////////////////////
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
            
//            cell.imageView?.image = self.imageArray[indexPath.row]
            cell.tagButton? = self.tagButtonArray[indexPath.row]
            
            return cell
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
