//
//  TaggingAppOverviewCollectionViewController.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 4/26/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "TaggingAppOverviewCollectionViewCell"

class TaggingAppOverviewCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var titleCounter: UINavigationItem!
    @IBOutlet var deselectButtonOutlet: UIBarButtonItem!
    @IBOutlet var selectButtonOutlet: UIBarButtonItem!
    var selecting = false
    
    let thumbnailSize = CGSize(width: 80, height: 80)
    
    // Establish FileManager object
    let fileMngr = FileManager.default
    
    // Establish path to 'Documents'
    var docURL: URL!
    
    var cameraObjects = [CameraObject]()
    
    @IBAction func selectButton(_ sender: Any) {
        
        // checks if selecting is being turned on or off first
        if selecting {
            selecting = false
        }
        else {
            selecting = true
        }
        
        // if selecting was just turned on
        if selecting {
            
            // clear out the right navigation bar, then add in 'select' and 'deselect' buttons
            navigationItem.rightBarButtonItems?.removeAll()
            navigationItem.rightBarButtonItems?.append(selectButtonOutlet)
            navigationItem.rightBarButtonItems?.append(deselectButtonOutlet)
            titleCounter.title = "\(global.shared.appImages.count) selected"
            
            collectionView?.allowsMultipleSelection = true
        }
            // if selecting was just turned off
        else {
            navigationItem.rightBarButtonItems?.removeAll()
            navigationItem.rightBarButtonItems?.append(selectButtonOutlet)
            titleCounter.title = ""
            
            collectionView?.allowsMultipleSelection = false
        }
        
    }
    @IBAction func deselectAllButton(_ sender: Any) {
        global.shared.appImages.removeAll()
        titleCounter.title = "\(global.shared.appImages.count) selected"
        
        collectionView?.reloadItems(at: (collectionView?.indexPathsForVisibleItems)!)
        collectionView?.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItems?.removeAll()
        navigationItem.rightBarButtonItems?.append(selectButtonOutlet)
        titleCounter.title = ""
        
        docURL = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        
        
        // Checks to see if 'CameraObject' array exists in memory
        if (PersistenceManager.loadNSArray(.CameraObjects) as? [CameraObject]) != nil {
            
            // Loads 'CameraObject' array
            cameraObjects = PersistenceManager.loadNSArray(.CameraObjects) as! [CameraObject]
        }
        
        // Deletes elements which have expired
        for object in cameraObjects {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "y-MM-dd-H-m-ss-SSSS"
            let date = dateFormatter.date(from: object.imageName)!
            let timeInterval = UserDefaults.standard.object(forKey: UD.imageExpiresIn) as! Int
            let expireDate = date.addingTimeInterval(TimeInterval(60 * 60 * 24 * timeInterval))
            
            if Date() > expireDate {
                cameraObjects.remove(at: cameraObjects.index(of: object)!)
            }
        }
        
        // Saves the UploadObjects to memory
        PersistenceManager.saveNSArray(cameraObjects as NSArray, path: .CameraObjects)
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
        let vc = segue.destination as! TaggingAppOverviewImageViewViewController
        
        let indexPaths = collectionView!.indexPathsForSelectedItems!
        let indexPath = indexPaths[0] as NSIndexPath
        
        let object = cameraObjects[indexPath.row]

        // Gets the location of the image
        let fullImagePath = docURL.appendingPathComponent(object.imageLocation)
        
        // Imports the image
        let fullImage = UIImage(contentsOfFile: fullImagePath.path)!
        
        vc.image = fullImage
        
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return cameraObjects.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TaggingAppOverviewCollectionViewCell
    
        let object = cameraObjects[indexPath.row]

        
        // Configure the cell
        
        // Gets the location of the image
        let thumbnailPath = docURL.appendingPathComponent(object.thumbnailLocation)
        
        // Imports the image
        let thumbnailImage = UIImage(contentsOfFile: thumbnailPath.path)!

        cell.imageView.image = thumbnailImage
        
        for cameraObject in global.shared.appImages {
            if object.imageName == cameraObject.imageName {
                cell.layer.borderWidth = 3
                cell.layer.borderColor = UIColor.blue.cgColor
            }
        }
    
        return cell
    }
    
    // Currently broken -- need to fix later
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // only execute if selecting is currently on
        if selecting {
            let object = cameraObjects[indexPath.row]
            
            var contains = false
            var tempObject: CameraObject?
            
            for appObject in global.shared.appImages {
                if object.imageName == appObject.imageName {
                    contains = true
                    tempObject = appObject
                }
            }
            
            if contains {
                global.shared.appImages.remove(at: global.shared.appImages.index(of: tempObject!)!)
            }
            else {
                global.shared.appImages.append(object)
            }
            
            titleCounter.title = "\(global.shared.appImages.count) selected"
            collectionView.reloadItems(at: [indexPath])
            collectionView.reloadData()
        }
        else {
            performSegue(withIdentifier: "TaggingAppOverviewImageViewSegue", sender: self)
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
