//
//  HistoryImageViewController.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 4/11/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import UIKit
import Kingfisher

class HistoryImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!

    var imagePath: String?;
    
    var imageContexts = [String]();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        //load full image from kingfisher
        let url = URL(string: self.imagePath!);
        
        self.imageView?.kf.indicatorType = .activity
        
        let image = ImageCache.default.retrieveImageInDiskCache(forKey: url!.absoluteString);
        
        if(image == nil){
            self.imageView?.kf.setImage(with: url, options: [.transition(.fade(0.2)),.forceRefresh]);
        }else{
            self.imageView.image = image;
        }
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        let client = delegate.client!;
        
        let icavTable = client.table(withName: "ICAV");
        
        let icavQuery = icavTable.query();
        icavQuery.predicate = NSPredicate(format: "imageID == %@", self.title!);
        icavQuery.selectFields = ["contextID"]
        
        icavQuery.read(completion: {
            (result, error) in
            if let err = error {
                
            } else if let contextResults = result?.items {
                print(contextResults.count);
                
                for row in contextResults {
                    let context = row["contextID"] as! String;
                    
                    if(!self.imageContexts.contains(context)){
                        self.imageContexts.append(context)
                    }
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = ThemeManager.applyBackground(theme: UserDefaults.standard.object(forKey: UD.themeIndex) as? Int ?? 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "historyShowTagsSeque"
        {
            let vc = segue.destination as! HistoryTagTableViewController
            
            vc.contexts = imageContexts;
            vc.imageTitle = self.title;
        }
    }
}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "historyShowTagsSeque"
        {
            let vc = segue.destination as! HistoryTagTableViewController
            
            print(imageContexts);
            
            vc.contexts = imageContexts;
            vc.imageTitle = self.title;
        }
    }
}*/
