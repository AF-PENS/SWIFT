//
//  CameraAttributeTableViewController.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 4/25/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import UIKit

class CameraAttributeTableViewController: UITableViewController, UITextViewDelegate {

    // Passed in context
    @IBOutlet weak var contextTitle: UINavigationItem!
    
    // Attribute titles
    var attributes = [Attribute]();
    
    // save button to save the context attributes
    @IBAction func saveButton(_ sender: Any) {
        
        // creates a Context object with the title of the current context
        let tempContext = Context(id: contextTitle.title!)
        
        for index in 0..<attributes.count {
            let tempAttribute = attributes[index]
            tempContext.attributes.append(tempAttribute)
        }
        
        globalObject.sharedInstance.cameraContexts.append(tempContext)
        
        performSegue(withIdentifier: "unwindToCameraViewController", sender: self)
    }
    
    func updateAttributeList(list: [Attribute]){
        attributes = list;
        
        self.tableView.reloadData()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        let client = delegate.client!;
        
        let attributeTable = client.table(withName: "Attribute");
        
        attributeTable.read(completion: {
            (result, error) in
            if let err = error {
            } else if let attributeResults = result?.items {
                var attributeList = [Attribute]()
                
                for attribute in attributeResults {
                    
                    attributeList.append(
                        Attribute(
                            id: attribute["id"] as! String,
                            question: attribute["question"] as! String,
                            value: ""
                        )
                    )
                }
                
                self.updateAttributeList(list: attributeList);
            }
        })


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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return attributes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CameraAttributeTableViewCell", for: indexPath) as! CameraAttributeTableViewCell
        
        // displays the title and the description of the attribute
        cell.attributeTitle.text = attributes[indexPath.row].id
        cell.attributeDescription.text = attributes[indexPath.row].question
        cell.attributeAnswer.text = attributes[indexPath.row].value
        
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
    
    func textViewDidChange(_ textView: UITextView) {
        attributes[textView.tag].value = textView.text!
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
