//
//  AttributeTableTableViewController.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 4/18/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import UIKit

class AttributeTableTableViewController: UITableViewController, UITextViewDelegate {
    
    // Passed in context
    @IBOutlet weak var contextTitle: UINavigationItem!
    
    // Attribute titles
    var attributes = ["Title Goes Here1", "Title Goes Here2", "Title Goes Here3", "Title Goes Here4", "Title Goes Here5", "Title Goes Here6"]
    
    // Attribute descriptions
    var descriptions = ["Description Goes Here1", "Description Goes Here2", "Description Goes Here3", "Description Goes Here4", "Description Goes Here5", "Description Goes Here6"]
    
    // Attribute answers
    var answers = ["User Types Answer Here1", "User Types Answer Here2", "User Types Answer Here3", "User Types Answer Here4", "User Types Answer Here5", "User Types Answer Here6"]
    
    
    // save button to save the context attributes
    @IBAction func saveButton(_ sender: Any) {
        
        // creates a Context object with the title of the current context
        let tempContext = Context(id: contextTitle.title!)
        
        for index in 0..<attributes.count {
            let tempAttribute = Attribute(id: attributes[index], answer: answers[index])
            tempContext.attributes.append(tempAttribute)
        }
        
        globalObject.sharedInstance.Attributes.append(tempContext)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Only 1 section, there will be no dividers
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // total number of attributes
        return attributes.count
    }

    // Configures the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttributeTableViewCell", for: indexPath) as! AttributeTableViewCell
        
        // displays the title and the description of the attribute
        cell.attributeTitle.text = attributes[indexPath.row]
        cell.attributeDescription.text = descriptions[indexPath.row]
        cell.attributeAnswer.text = answers[indexPath.row]
        
        // cell debug to save textview data
        cell.attributeAnswer.tag = indexPath.row
        cell.attributeAnswer.delegate = self
        
        // prevents the cell from being selectable
        cell.selectionStyle = UITableViewCellSelectionStyle.none

        return cell
    }
    
    // Prevents the cell from being highlighted when selected
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        answers[textView.tag] = textView.text!
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
