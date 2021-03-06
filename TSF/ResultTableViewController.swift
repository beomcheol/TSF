//
//  ResultTableViewController.swift
//  TSF
//
//  Created by j2h on 2017. 2. 25..
//  Copyright © 2017년 j2h. All rights reserved.
//

import UIKit
import InstagramKit

class ResultTableViewController: UITableViewController {
    
    var data:[InstagramMedia] = []
    
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

 

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as! ResultCell

        // Configure the cell...
        cell.media = data[indexPath.row]
        
        

        return cell
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
    @IBAction func followAll(_ sender: Any) {
//         guard let data = self.data else {
//            return
//        }
        
        follow(self.data)
        
    }
    
    func follow(_ items: [InstagramMedia]?) {
        guard var items = items, let item = items.popLast() else {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            return
        }
        
        InstagramEngine.shared().followUser(item.user.id, withSuccess: { [weak self] _ in
            self?.follow(items)
        }, failure: { (err, code) in
            return
        })

    }

}


extension ResultTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let tag = textField.text {
            InstagramEngine.shared().getMediaWithTagName(tag, withSuccess: { (items, pageInfo) in
                
                var filteredItems = [InstagramMedia]()
                var dic = [String:Bool]()

                for item in items {
                    if dic[item.user.id] != true {
                        dic[item.user.id] = true
                        filteredItems.append(item)
                    }
                }
                self.data = filteredItems
                self.tableView.reloadData()
            }, failure: nil)
        }
    
        return true
    }
}
