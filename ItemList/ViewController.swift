//
//  ViewController.swift
//  ItemList
//
//  Created by Zachary Oxendine on 7/1/20.
//  Copyright © 2020 Zachary Oxendine. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var itemList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Item List"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self,
                                                           action: #selector(trashAllItems))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAllItems)),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
        ]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = itemList[indexPath.row]
        return cell
    }
    
    // check if string is empty
    func isEmptyString(_ item: String) -> Bool {
        if item == "" {
            return true
        } else {
            return false
        }
    }
    
    // check if string is used
    func isUsedString(_ item: String) -> Bool {
        for listItem in itemList {
            if item == listItem {
                return true
            }
        }
        
        return false
    }
    
    // submit alert action
    func submit(_ item: String) {
        let errorTitle: String
        let errorMessage: String
        
        if isEmptyString(item) {
            errorTitle = "Error: Item Not Found"
            errorMessage = "Please submit an item."
        } else if isUsedString(item) {
            errorTitle = "Error: Item Already Listed"
            errorMessage = "Please submit a new item."
        } else {
            let indexPath = IndexPath(row: itemList.count, section: 0)
            
            itemList.append(item)
            tableView.insertRows(at: [indexPath], with: .automatic)
            
            return
        }
        
        let submitAC = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        submitAC.addAction(UIAlertAction(title: "Okay", style: .default))
        present(submitAC, animated: true)
    }
    
    // left bar button item
    @objc func trashAllItems() {
        itemList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    // right bar button item
    @objc func shareAllItems() {
        let shareableItemList = itemList.joined(separator: "\n")
        let activityVC = UIActivityViewController(activityItems: [shareableItemList],
                                                  applicationActivities: [])
        
        activityVC.popoverPresentationController?.barButtonItem = navigationItem.backBarButtonItem
        present(activityVC, animated: true)
    }
    
    // right bar button item
    @objc func addNewItem() {
        let addNewItemAC = UIAlertController(title: "Enter Item:", message: nil,
                                             preferredStyle: .alert)
        addNewItemAC.addTextField()
        
        let submitAlertAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak addNewItemAC] _ in
            guard let item = addNewItemAC?.textFields?[0].text else { return }
            self?.submit(item)
        }
        
        addNewItemAC.addAction(submitAlertAction)
        present(addNewItemAC, animated: true)
    }
}
