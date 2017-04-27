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
    
    let imageArray = [UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder"), UIImage(named: "imagePlaceholder")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
