//
//  CollapsibleTableViewController.swift
//  CollapsibleSectionAndCellTableView
//
//  Created by Charles on 26/09/18.
//  Copyright © 2018 Sky Network Television Limited. All rights reserved.
//

import UIKit

class CollapsibleTableViewController: UITableViewController {
    
    var outterHeaderHeight: CGFloat = 80.0
    
    var categoryArray: CategoryArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //read datasource from json
        categoryArray = readCategoryArrayFromJson()
        
        //Auto resizing the height of the cell
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(CollapsibleTableViewCell.self, forCellReuseIdentifier:String(describing: CollapsibleTableViewCell.self))
        self.title = "CollapsibleSectionAndCellTableView"
    }
    
    private func readCategoryArrayFromJson() -> CategoryArray? {
        if let path = Bundle.main.path(forResource: "search_crime", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let categoryArray = try JSONDecoder().decode(CategoryArray.self, from: data)
                categoryArray.first?.collapsed = false
                
                return categoryArray
            } catch let error {
                print("parse error:\(error)")
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
        if categoryArray[section].collapsed == false {
            return categoryArray[section].events.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CollapsibleTableViewCell.self), for:indexPath) as! CollapsibleTableViewCell
        cell.delegate = self
        let event = categoryArray[indexPath.section].events[indexPath.row]
        cell.event = event
        cell.indexPath = indexPath
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let event = categoryArray[indexPath.section].events[indexPath.row]
        if let relatedEventsCount = event.relatedEvents?.count, relatedEventsCount > 0, event.collapsed == false {
            return CGFloat(relatedEventsCount) * CollapsibleTableViewCell.cellHeight() + CollapsibleTableViewCell.headerHeight()
        } else {
            return CollapsibleTableViewCell.headerHeight()
        }
    }
    
    // OutterHeader
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let identifier = String(describing: CollapsibleTableViewHeader.self)
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? CollapsibleTableViewHeader ??
            CollapsibleTableViewHeader(reuseIdentifier:identifier)
        header.textLabel?.text = categoryArray[section].category
        header.section = section
        header.delegate = self
        header.contentView.backgroundColor = #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return outterHeaderHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

extension CollapsibleTableViewController: CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        // Toggle collapse
        if categoryArray[section].collapsed == false {
            categoryArray[section].collapsed = true
        } else {
            categoryArray[section].collapsed = false
        }
        
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
}

extension CollapsibleTableViewController: CollapsibleTableViewCellDelegate {
    func toggleCellSection(_ cell: CollapsibleTableViewCell, header: SecondaryTableViewHeader, indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
