//
//  HistoryViewController.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 1/26/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var historyCollectionView: UICollectionView!
    
    var imageArray = [UIImage]();
    
    var blobClient: AZSCloudBlobClient = AZSCloudBlobClient();
    var blobContainer: AZSCloudBlobContainer = AZSCloudBlobContainer();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let account = try! AZSCloudStorageAccount(fromConnectionString: "SharedAccessSignature=sv=2016-05-31&ss=b&srt=o&sp=rw&se=2027-02-24T00:00:00Z&st=2017-02-24T00:00:00Z&spr=https&sig=kChTx0B8faa43g%2F%2F2G5LIWBCOKMxq1eIgqOUn9Ds9s4%3D;BlobEndpoint=https://boephotostore.blob.core.windows.net")
        
        blobClient = account.getBlobClient()
        
        blobContainer = blobClient.containerReference(
            fromName:"photocontainer"
        );
        
        var imagePaths = [String]();
        
        imagePaths.append("user/2017-04-18-17-54-44--10304991.jpeg")
        imagePaths.append("user/2017-04-18-17-54-48--536690126.jpeg")
        imagePaths.append("user/2017-04-19-00-11-54--467650453.jpeg")
        imagePaths.append("user/2017-04-19-00-11-59--10304991.jpeg")
        imagePaths.append("user/2017-04-19-00-12-13--536690126.jpeg")
        imagePaths.append("user/2017-04-19-00-12-17--1516264518.jpeg")
        imagePaths.append("user/2017-04-19-00-46-48--467650453.jpeg")
        imagePaths.append("user/2017-04-19-07-24-41--467650453.png")
        imagePaths.append("user/2017-04-19-11-00-33--467650453.jpeg")
        imagePaths.append("user/2017-04-19-11-02-57--10304991.jpeg")
        imagePaths.append("user/2017-04-19-11-32-55--10304991.png")
        imagePaths.append("user/2017-04-19-22-01-17--467650453.jpeg")
        imagePaths.append("user/2017-04-19-22-01-25--10304991.jpeg")
        imagePaths.append("user/cc6c3dd187fbeb301794ee8880b1183b.jpg")
        imagePaths.append("user/images-1.jpeg")
        imagePaths.append("user/images-2.jpeg")
        imagePaths.append("user/images-3.jpeg")
        imagePaths.append("user/images-4.jpeg")
        imagePaths.append("user/images-5.jpeg")
        imagePaths.append("user/images-6.jpeg")
        imagePaths.append("user/images-7.jpeg")
        imagePaths.append("user/images-8.jpeg")
        imagePaths.append("user/images.jpeg")
        imagePaths.append("user/images.png")
        imagePaths.append("user/IMAGES_2017-04-19-00-41-00_-467650453.jpg")
        imagePaths.append("user/IMAGES_2017-04-19-00-48-17_-467650453.jpg")
        imagePaths.append("user/IMAGES_2017-04-19-10-13-24_-10304991.jpg")
        imagePaths.append("user/IMAGES_2017-04-19-10-37-27_-467650453.jpg")
        imagePaths.append("user/IMAGES_2017-04-19-10-39-30_-10304991.jpg")
        imagePaths.append("user/IMAGES_2017-04-19-10-50-30_-467650453.jpg")
        imagePaths.append("user/IMAGES_2017-04-19-10-57-58_-467650453.jpg")
        imagePaths.append("user/IMAGES_2017-04-19-11-26-22_-467650453.jpg")
        imagePaths.append("user/IMAGES_2017-04-19-11-28-45_-536690126.jpg")
        imagePaths.append("user/IMAGES_2017-04-19-11-36-44_-467650453.jpg")
        imagePaths.append("user/IMAGES_2017-04-19-11-36-57_-536690126.jpg")
        imagePaths.append("user/IMAGES_2017-04-19-21-45-21_-467650453.jpg")
        imagePaths.append("user/IMAGES_2017-04-19-21-54-11_-467650453.jpg")
        imagePaths.append("user/IMAGES_2017-04-19-21-54-29_-10304991.jpg")
        imagePaths.append("user/IMAGES_2017-04-19-21-54-41_-536690126.jpg")
        imagePaths.append("user/IMAGES_2017-04-19-21-58-36_-467650453.jpg")
        imagePaths.append("user/IMG_20160622_121558.jpg")
        imagePaths.append("user/IMG_20161115_150729.jpg")
        imagePaths.append("user/IMG_20170226_232817.jpg")
        imagePaths.append("user/IMG_20170313_002415.jpg")
        imagePaths.append("user/IMG_20170406_012106.jpg")
        imagePaths.append("user/IMG_20170406_012219.jpg")
        imagePaths.append("user/IMG_20170412_140517.jpg")
        imagePaths.append("user/IMG_20170417_145700.jpg")
        imagePaths.append("user/lol.PNG")
        imagePaths.append("user/Nithf7m.jpg")
        imagePaths.append("user/pairprogramming_f0d3ae7ef121e981e150bfcae4ecb995.jpg")
        imagePaths.append("user/received_10212509993448566.jpeg")
        imagePaths.append("user/Screenshot_2017-01-27-09-12-47.png")
        imagePaths.append("user/Screenshot_2017-03-22-01-06-22.png")
        imagePaths.append("user/Screenshot_2017-04-12-13-40-35.png")
        imagePaths.append("user/Screenshot_2017-04-17-13-47-41.png")
        imagePaths.append("user/user7145_pic154_1463771469.jpg")
        
        loadImages(paths: imagePaths);
    }
    
    func loadImages(paths: [String]){
        for path in paths{
            print(path);
            
            let image = blobContainer.blockBlobReference(fromName: path);
            
            image.downloadToData { (error, data) in
                self.imageArray.append(UIImage(data: data!)!)
                
                self.historyCollectionView.reloadData();
                
                print("Downloaded Image");
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
        
        cell.imageView?.image = self.imageArray[indexPath.row]
        
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
