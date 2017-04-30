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
    
    var blobClient: AZSCloudBlobClient = AZSCloudBlobClient();
    var blobContainer: AZSCloudBlobContainer = AZSCloudBlobContainer();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sas = "sv=2016-05-31&ss=b&srt=o&sp=rw&se=2027-02-24T00:00:00Z&st=2017-02-24T00:00:00Z&spr=https&sig=kChTx0B8faa43g%2F%2F2G5LIWBCOKMxq1eIgqOUn9Ds9s4%3D"
        
        let account = try! AZSCloudStorageAccount(fromConnectionString: "SharedAccessSignature=" + sas + ";BlobEndpoint=https://boephotostore.blob.core.windows.net")
        
        blobClient = account.getBlobClient()
        
        blobContainer = blobClient.containerReference(
            fromName:"photocontainer"
        );
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        let client = delegate.client!;
        
        let imageTable = client.table(withName: "Image");
        
        //REPLACE WITH GLOBAL!
        let userID = "user";
        
        let imgQuery = imageTable.query();
        
        imgQuery.order(byDescending: "createdAt");
        
        imgQuery.predicate = NSPredicate(format: "userID == %@", userID);
        
        imgQuery.read(completion: {
            (result, error) in
            if let err = error {
                print("Error ", err);
            } else if let imgResults = result?.items {
                for img in imgResults {
                    var path = img["id"] as! String
                    
                    //add path to titles list
                    self.imageTitles.append(path);
                    
                    path = path.replacingOccurrences(
                        of: "_",
                        with: "/",
                        options: NSString.CompareOptions.literal,
                        range: path.range(of: "_")
                    )
                    
                    path = self.blobContainer.storageUri.primaryUri.absoluteString
                        + "/"
                        + path
                        + "?"
                        + sas;
                    
                    self.imagePaths.append(path);
                    print("Reloading");
                    print(self.imagePaths.count);
                    self.historyCollectionView.reloadData()
                }
                
//                self.loadImages(paths: self.imagePaths);
            }
        })
    }
    
    func loadImages(paths: [String]){
        for path in paths{
            //TODO
            //Add completion handler
            //to update step by step
            
            DispatchQueue.main.async{
                //make sure data is not nil
                if let data = NSData(contentsOf: URL(string: path)!) {
                    let image = UIImage(data: data as Data!);
                    self.imageArray.append(image!);
                }
                
                self.historyCollectionView.reloadData()
            }
        }
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "historyCell", for: indexPath) as! HistoryCollectionViewCell
        
        let url = URL(string: self.imagePaths[indexPath.row]);
        print(url);
        cell.imageView?.kf.setImage(with: url);
        
//        cell.imageView?.image = self.imageArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "historyShowImageSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "historyShowImageSegue"
        {
            let indexPaths = self.historyCollectionView.indexPathsForSelectedItems!
            let indexPath = indexPaths[0] as NSIndexPath
            
            let vc = segue.destination as! HistoryImageViewController
            
            vc.image = self.imageArray[indexPath.row]
            
            vc.title = self.imageTitles[indexPath.row]
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
