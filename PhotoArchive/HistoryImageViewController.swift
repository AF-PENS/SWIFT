//
//  HistoryImageViewController.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 4/11/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import UIKit

class HistoryImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!

    var image = UIImage()
    
    var imageContexts = [String]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.title!);

        // Do any additional setup after loading the view.
        self.imageView.image = self.image
        
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
}
