//
//  HistoryViewController.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 1/26/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import UIKit
import Kingfisher

class HistoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var historyCollectionView: UICollectionView!
    
    var imageArray = [UIImage]();
    var imageTitles = [String]();
    var imagePaths = [String]();
    var thumbnailPaths = [String]();
    
    var imageForSeque: String?
    var titleForSeque: String?
    
    var blobClient: AZSCloudBlobClient = AZSCloudBlobClient();
    var blobContainer: AZSCloudBlobContainer = AZSCloudBlobContainer();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImages();
    }
    
    func loadImages(){
        let sas = "sv=2016-05-31&ss=b&srt=o&sp=rw&se=2027-02-24T00:00:00Z&st=2017-02-24T00:00:00Z&spr=https&sig=kChTx0B8faa43g%2F%2F2G5LIWBCOKMxq1eIgqOUn9Ds9s4%3D"
        
        let account = try! AZSCloudStorageAccount(fromConnectionString: "SharedAccessSignature=" + sas + ";BlobEndpoint=https://boephotostore.blob.core.windows.net")
        
        blobClient = account.getBlobClient()
        
        blobContainer = blobClient.containerReference(
            fromName:"photocontainer"
        );
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        let client = delegate.client!;
        
        let imageTable = client.table(withName: "Image");
        
        let userID = UserDefaults.standard.string(forKey: UD.username)!
        
        let imgQuery = imageTable.query();
        
        imgQuery.order(byDescending: "createdAt");
        
        imgQuery.predicate = NSPredicate(format: "userID == %@", userID);
        
        imgQuery.read(completion: {
            (result, error) in
            if let err = error {
                print("Error ", err);
            } else if let imgResults = result?.items {
                for img in imgResults {
                    let path = img["id"] as! String
                    
                    //add path to titles list
                    self.imageTitles.append(path);
                    
                    var imagePath = path.replacingOccurrences(
                        of: "_",
                        with: "/",
                        options: NSString.CompareOptions.literal,
                        range: path.range(of: "_")
                    )
                    
                    imagePath = self.blobContainer.storageUri.primaryUri.absoluteString
                        + "/"
                        + imagePath
                        + "?"
                        + sas;
                    
                    var thumbnailPath = path.replacingOccurrences(
                        of: "_",
                        with: "/thumbnails/",
                        options: NSString.CompareOptions.literal,
                        range: path.range(of: "_")
                    )
                    
                    thumbnailPath = self.blobContainer.storageUri.primaryUri.absoluteString
                        + "/"
                        + thumbnailPath
                        + "?"
                        + sas;
                    
                    self.imagePaths.append(imagePath);
                    self.thumbnailPaths.append(thumbnailPath);
                }
                
                self.historyCollectionView.reloadData()
            }
        })
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
        
        view.backgroundColor = ThemeManager.applyBackground(theme: UserDefaults.standard.object(forKey: UD.themeIndex) as? Int ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagePaths.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "historyCell", for: indexPath) as! HistoryCollectionViewCell
        
        //prevent user interaction while loading
        cell.isUserInteractionEnabled = false;
        
        
        //here load thumbnails
        let url = URL(string: self.thumbnailPaths[indexPath.row]);
        
        cell.imageView?.kf.indicatorType = .activity
        
        let image = ImageCache.default.retrieveImageInDiskCache(forKey: url!.absoluteString);
        
        if(image == nil){
            cell.imageView?.kf.setImage(with: url, options: [.transition(.fade(0.2)),.forceRefresh],completionHandler: {
                (image, error, cacheType, imageUrl) in
                if(image != nil){
                    cell.isUserInteractionEnabled = true;
                }
            });
        }else{
            cell.imageView.image = image;
            cell.isUserInteractionEnabled = true;
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.imageForSeque = self.imagePaths[indexPath.row]
        
        self.titleForSeque = self.imageTitles[indexPath.row];
        self.performSegue(withIdentifier: "historyShowImageSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "historyShowImageSegue"
        {
            let vc = segue.destination as! HistoryImageViewController
            
            vc.imagePath = self.imageForSeque!;
            vc.title = self.titleForSeque!;
        }
    }
}
