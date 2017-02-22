//
//  TaggingTableAttributeViewController.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 2/21/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import UIKit

class TaggingTableAttributeViewController: UIViewController {
    
    @IBOutlet weak var contextTitle: UITextField!
    @IBOutlet weak var contextDescription: UITextView!
    
    
    var passedTitle: String!
    var passedTitleDescription: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        contextTitle.text = passedTitle
        contextDescription.text = passedTitleDescription
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let contentSize = self.contextDescription.sizeThatFits(self.contextDescription.bounds.size)
        var frame = self.contextDescription.frame
        frame.size.height = contentSize.height
        self.contextDescription.frame = frame
        
        let aspectRatioTextViewConstraint = NSLayoutConstraint(item: self.contextDescription, attribute: .height, relatedBy: .equal, toItem: self.contextDescription, attribute: .width, multiplier: contextDescription.bounds.height/contextDescription.bounds.width, constant: 1)
        self.contextDescription.addConstraint(aspectRatioTextViewConstraint)
        
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
