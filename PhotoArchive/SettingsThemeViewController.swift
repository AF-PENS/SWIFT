//
//  SettingsThemeViewController.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 5/3/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import UIKit

class SettingsThemeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        segmentOutlet.selectedSegmentIndex = UserDefaults.standard.object(forKey: UD.themeIndex) as! Int
        
        view.backgroundColor = ThemeManager.applyBackground(theme: UserDefaults.standard.object(forKey: UD.themeIndex) as! Int)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var segmentOutlet: UISegmentedControl!
    
    @IBAction func segmentAction(_ sender: Any) {
        
        UserDefaults.standard.set(segmentOutlet.selectedSegmentIndex, forKey: UD.themeIndex)
        

        self.viewWillAppear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated);

        
        ThemeManager.applyTheme(theme: segmentOutlet.selectedSegmentIndex)

        view.backgroundColor = ThemeManager.applyBackground(theme: UserDefaults.standard.object(forKey: UD.themeIndex) as! Int)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }

    @IBAction func applyAction(_ sender: Any) {
        
        
        self.dismiss(animated: true, completion: nil)
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
