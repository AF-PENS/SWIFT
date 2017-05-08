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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.imageView.image = self.image
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
