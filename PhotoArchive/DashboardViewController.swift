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

    @IBOutlet weak var tagsStatusText: UITextField!
    @IBOutlet weak var permissionStatusText: UITextField!

    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageArray = [UIImage]()
    var fetchResult: PHFetchResult<PHAsset>!
    fileprivate let imageManager = PHCachingImageManager()
    fileprivate var thumbnailSize: CGSize!
    
    var uploadObjects = [UploadObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Determine the size of the thumbnails to request from the PHCachingImageManager
        let scale = UIScreen.main.scale
        let cellSize = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        thumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
        
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
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }
    
    // Hides the navigation controller
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
//        if (PersistenceManager.loadNSArray(.UploadObjects) as? [UploadObject]) != nil {
//            uploadObjects = PersistenceManager.loadNSArray(.UploadObjects) as! [UploadObject]
//        }
        
        let allPhotosOption = PHFetchOptions()
        allPhotosOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        var localIdentifiers = [String]()
        
        for object in uploadObjects {
//            localIdentifiers.append(object.imageLocalIdentifier)
        }
        
        fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: localIdentifiers, options: allPhotosOption)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return uploadObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let object = uploadObjects[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dashboardCell", for: indexPath) as! DashboardCollectionViewCell

        
//        if object.isAppImage {
//            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
//            let url = NSURL(fileURLWithPath: path)
//            let filePath = url.appendingPathComponent(object.imageLocalIdentifier)?.path
//            let fileManager = FileManager.default
//            if fileManager.fileExists(atPath: filePath!) {
//                let image = UIImage(contentsOfFile: filePath!)!
//                cell.imageView.image = image
//            } else {
//                print("FILE NOT AVAILABLE")
//            }
//        }
//        else if object.isGalleryImage {
//            var asset: PHAsset!
//            
//            for i in 0..<fetchResult.count {
//                asset = fetchResult.object(at: i)
//                
//                if uploadObjects[indexPath.row].imageLocalIdentifier == asset.localIdentifier {
//                    break;
//                }
//            }
//            // Request an image for the asset from the PHCachingImageManager.
//            imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
//                // The cell may have been recycled by the time this handler gets called;
//                // set the cell's thumbnail image only if it's still showing the same asset.
//                cell.imageView.image = image
//            })
//        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "dashboardShowImage", sender: self)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        
//        if segue.identifier == "dashboardShowImage"
//        {
//            let indexPaths = self.collectionView.indexPathsForSelectedItems!
//            let indexPath = indexPaths[0] as NSIndexPath
//            
//            let vc = segue.destination as! DashboardImageViewController
//            
//            let object = uploadObjects[indexPath.row]
//            
//            if object.isAppImage {
//                let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
//                let url = NSURL(fileURLWithPath: path)
//                let filePath = url.appendingPathComponent(object.imageLocalIdentifier)?.path
//                let fileManager = FileManager.default
//                if fileManager.fileExists(atPath: filePath!) {
//                    let image = UIImage(contentsOfFile: filePath!)!
//                    vc.image = image
//                } else {
//                    print("FILE NOT AVAILABLE")
//                }
//            }
//            else if object.isGalleryImage {
//                var asset: PHAsset!
//                
//                for i in 0..<fetchResult.count {
//                    asset = fetchResult.object(at: i)
//                    
//                    if uploadObjects[indexPath.row].imageLocalIdentifier == asset.localIdentifier {
//                        break;
//                    }
//                }
//                
//                let allPhotosOption = PHFetchOptions()
//                allPhotosOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//                
//                let tempfetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [asset.localIdentifier], options: allPhotosOption)
//                
//                imageManager.requestImageData(for: tempfetchResult.firstObject!, options: nil, resultHandler: { image,_,_,_ in
//                    print(image!)
//                    // The cell may have been recycled by the time this handler gets called;
//                    // set the cell's thumbnail image only if it's still showing the same asset.
//                    let tempimage = UIImage(data: image!)!
//                    print(tempimage)
//                    vc.imageView.image = tempimage
//                })
//                
////                // Request an image for the asset from the PHCachingImageManager.
////                imageManager.requestImage(for: tempfetchResult.firstObject!, targetSize: imageSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
////                    // The cell may have been recycled by the time this handler gets called;
////                    // set the cell's thumbnail image only if it's still showing the same asset.
////                    vc.image = image!
////                })
//            }
//        }
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
