//
//  DashboardViewController.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 1/26/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var tagsStatusText: UITextField!
    @IBOutlet weak var permissionStatusText: UITextField!

    @IBOutlet weak var collectionView: UICollectionView!
    
    let imageArray = [UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tagsStatusText.text = "Checking"
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
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dashboardCell", for: indexPath) as! DashboardCollectionViewCell
        
        cell.imageView?.image = self.imageArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "dashboardShowImage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "dashboardShowImage"
        {
            let indexPaths = self.collectionView.indexPathsForSelectedItems!
            let indexPath = indexPaths[0] as NSIndexPath
            
            let vc = segue.destination as! DashboardImageViewController
            vc.image = self.imageArray[indexPath.row]!            
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
