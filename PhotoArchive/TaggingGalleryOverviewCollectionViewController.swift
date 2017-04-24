//
//  TaggingGalleryOverviewCollectionViewController.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 4/23/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

private let reuseIdentifier = "TaggingGalleryOverviewCollectionViewCell"

class TaggingGalleryOverviewCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var titleCount: UINavigationItem!
    @IBOutlet var deselectButtonOutlet: UIBarButtonItem!
    @IBOutlet var selectButtonOutlet: UIBarButtonItem!
    var sharing = false
    
    var fetchResult: PHFetchResult<PHAsset>!
    var assetCollection: PHAssetCollection!
    
    fileprivate let imageManager = PHCachingImageManager()
    fileprivate var thumbnailSize: CGSize!

    var selectedAsset: PHAsset!
    var selectedAssetCollection: PHAssetCollection!
    
    @IBAction func selectButton(_ sender: Any) {
        
        // checks if sharing is being turned on or off first
        if sharing {
            sharing = false
        }
        else {
            sharing = true
        }
        
        // if sharing was just turned on
        if sharing {
            
            // clear out the right navigation bar, then add in 'select' and 'deselect' buttons
            navigationItem.rightBarButtonItems?.removeAll()
            navigationItem.rightBarButtonItems?.append(selectButtonOutlet)
            navigationItem.rightBarButtonItems?.append(deselectButtonOutlet)
            titleCount.title = "\(globalObject.sharedInstance.GalleryImages.count) selected"
            
            collectionView?.allowsMultipleSelection = true
        }
        // if sharing was just turned off
        else {
            navigationItem.rightBarButtonItems?.removeAll()
            navigationItem.rightBarButtonItems?.append(selectButtonOutlet)
            titleCount.title = ""
            
            collectionView?.allowsMultipleSelection = false
        }
        
    }
    @IBAction func deselectAllButton(_ sender: Any) {
        globalObject.sharedInstance.GalleryImages.removeAll()
        titleCount.title = "\(globalObject.sharedInstance.GalleryImages.count) selected"
        collectionView?.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Determine the size of the thumbnails to request from the PHCachingImageManager
        let scale = UIScreen.main.scale
        let cellSize = (collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        thumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
        
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchResult = PHAsset.fetchAssets(with: allPhotosOptions)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItems?.removeAll()
        navigationItem.rightBarButtonItems?.append(selectButtonOutlet)
        titleCount.title = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let destination = segue.destination as? TaggingGalleryOverviewImageViewViewController
        
        let indexPaths = collectionView?.indexPathsForSelectedItems
        let indexPath = indexPaths?[0]
        destination?.asset = fetchResult.object(at: (indexPath?.item)!)
        destination?.assetCollection = assetCollection
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return fetchResult.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let asset = fetchResult.object(at: indexPath.item)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TaggingGalleryOverviewCollectionViewCell
    
        // Configure the cell
    
        // Request an image for the asset from the PHCachingImageManager.
        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            // The cell may have been recycled by the time this handler gets called;
            // set the cell's thumbnail image only if it's still showing the same asset.
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.thumbnailImage = image
            }
        })
        
        if globalObject.sharedInstance.GalleryImages.contains(asset) {
            cell.layer.borderWidth = 3
            cell.layer.borderColor = UIColor.green.cgColor
        }
        else {
            cell.layer.borderWidth = 0
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // only execute if sharing is currently on
        if sharing {
            let asset = fetchResult.object(at: indexPath.row)
            
            // executes if global does not contain the asset
            if !globalObject.sharedInstance.GalleryImages.contains(asset) {
                globalObject.sharedInstance.GalleryImages.append(asset)
            }
            // executes if global does contain the asset
            else {
                globalObject.sharedInstance.GalleryImages.remove(at: globalObject.sharedInstance.GalleryImages.index(of: asset)!)
            }
            
            titleCount.title = "\(globalObject.sharedInstance.GalleryImages.count) selected"
            collectionView.reloadItems(at: [indexPath])
        }
        else {
            performSegue(withIdentifier: "TaggingGalleryOverviewImageViewSegue", sender: self)
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
