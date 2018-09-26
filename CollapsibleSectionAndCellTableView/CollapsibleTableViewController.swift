//
//  CollapsibleTableViewController.swift
//  CollapsibleSectionAndCellTableView
//
//  Created by Charles on 26/09/18.
//  Copyright © 2018 Sky Network Television Limited. All rights reserved.
//

import UIKit

class CollapsibleTableViewController: UITableViewController {

    var categoryArray: CategoryArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //read datasource from json
        categoryArray = readCategoryArrayFromJson()
        
        //Auto resizing the height of the cell
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(CollapsibleTableViewCell.self, forCellReuseIdentifier:String(describing: CollapsibleTableViewCell.self))
        self.title = "Search Result"
    }
    
    private func readCategoryArrayFromJson() -> CategoryArray? {
        if let path = Bundle.main.path(forResource: "search_crime", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let categoryArray = try JSONDecoder().decode(CategoryArray.self, from: data)
                
                return categoryArray
            } catch let error {
                print("parse error:\(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path")
        }
        
        return nil
    }
}

//
//  MARK: - View Controller DataSource and Delegate
//
extension CollapsibleTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray[section].collapsed ? 0 : categoryArray[section].events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CollapsibleTableViewCell.self), for:indexPath)
        
        let event = categoryArray[indexPath.section].events[indexPath.row]
        cell.textLabel?.text = event.title
        cell.detailTextLabel?.text = String(describing: event.relatedEvents?.count)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // Header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let identifier = String(describing: CollapsibleTableViewHeader.self)
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? CollapsibleTableViewHeader ??
            CollapsibleTableViewHeader(reuseIdentifier:identifier)
        
        header.textLabel?.text = categoryArray[section].category
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
}

extension CollapsibleTableViewController: CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !categoryArray[section].collapsed
        
        // Toggle collapse
        categoryArray[section].collapsed = collapsed
        
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
}
