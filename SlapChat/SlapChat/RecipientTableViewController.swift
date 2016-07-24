//
//  TableViewController.swift
//  SlapChat
//
//  Created by Flatiron School on 7/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import CoreData

class RecipientTableViewController: UITableViewController {

    
    let dataStore = DataStore.sharedDataStore
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataStore.fetchDataRecipient()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.dataStore.fetchDataRecipient()
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataStore.recipients.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = self.dataStore.recipients[indexPath.row].name
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueToMessages" {
            if let messagesVC = segue.destinationViewController as? MessagesTableViewController {
                if let index = tableView.indexPathForSelectedRow?.row {
                    messagesVC.messages = Array(self.dataStore.recipients[index].messages)
                }
            }
        }
    }

}