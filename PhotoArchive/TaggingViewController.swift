//
//  TaggingViewController.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 1/26/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import UIKit

class TaggingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var appCollectionView: UICollectionView!
    
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    
    let appImageArray = [UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder")]

    let galleryImageArray = [UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder")]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        appCollectionView.delegate = self
        appCollectionView.dataSource = self
        self.view.addSubview(appCollectionView)

        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        self.view.addSubview(galleryCollectionView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // for the inapp images
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.appCollectionView {
            return self.appImageArray.count
        }
        else {
            return self.galleryImageArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "taggingAppCell", for: indexPath) as! TaggingAppCollectionViewCell
       
        if collectionView == self.appCollectionView {
            cell.imageView?.image = self.appImageArray[indexPath.row]
        }
        else {
            cell.imageView?.image = self.galleryImageArray[indexPath.row]
        }

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
