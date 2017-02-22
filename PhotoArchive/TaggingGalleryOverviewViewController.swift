//
//  TaggingGalleryOverviewViewController.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 2/14/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import UIKit
import Photos

//class TaggingGalleryOverviewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
class TaggingGalleryOverviewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    
    
    var galleryImageArray = [UIImage]()
    
    
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
                
                if index > 150 {
                    index = 150
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
        
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        self.view.addSubview(galleryCollectionView)
        grabPhotos()
        
        
        //setting button placeholders for testing
        ///////////////////////
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // for the inapp images and buttons
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.galleryImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // creates the cell to display the image
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaggingGalleryOverviewCollectionViewCell", for: indexPath) as! TaggingGalleryOverviewCollectionViewCell
        
        cell.imageView?.image = self.galleryImageArray[indexPath.row]
        
        return cell
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

