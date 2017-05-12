//
//  HistoryAttributeTableViewController.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 4/18/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import UIKit

class HistoryAttributeTableViewController: UITableViewController {
    
    // The context we selected on the previous screen
    @IBOutlet weak var contextTitle: UINavigationItem!
    
    var imageTitle: String!;
    
    // Attribute titles
    var attributes = [String]();
    
    // Attribute values
    var values = [String: String]();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        let client = delegate.client!;
        
        let icavTable = client.table(withName: "ICAV");
        
        let icavQuery = icavTable.query();
        icavQuery.predicate = NSPredicate(format: "imageID == %@ and contextID == %@", imageTitle, contextTitle.title!);
        icavQuery.selectFields = ["attributeID", "value"]
        
        icavQuery.read(completion: {
            (result, error) in
            if let err = error {
                
            } else if let attributeResults = result?.items {
                for row in attributeResults {
                    let attribute = row["attributeID"] as! String;
                    let attributeValue = row["value"] as! String;
                    
                    
                    self.updateAttributes(attribute: attribute, value: attributeValue);
                }
            }
        })
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func updateAttributes(attribute: String, value: String){
        print("Attribute: ", attribute);
        print("Value: ", value);
        
        attributes.append(attribute);
        
        attributes = attributes.sorted{$0.localizedCompare($1) == .orderedAscending}
        
        values[attribute] = value;
        
        self.tableView.reloadData();

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
        return attributes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryAttributeTableViewCell", for: indexPath) as! HistoryAttributeTableViewCell
        
        let attribute = attributes[indexPath.row];
        
        // displays the title and the description of the attribute
        cell.attributeTitle.text = attribute;
        cell.attributeDescription.text = ""
        cell.attributeAnswer.text = values[attribute];
        // prevents the cell from being selectable
        cell.selectionStyle = UITableViewCellSelectionStyle.none

        return cell
    }
    
    // Prevents the cell from being highlighted when selected
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
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
