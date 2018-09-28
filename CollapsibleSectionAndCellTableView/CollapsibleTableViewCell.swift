//
//  CollapsibleTableViewCell.swift
//  CollapsibleSectionAndCellTableView
//
//  Created by Charles on 26/09/18.
//  Copyright © 2018 Sky Network Television Limited. All rights reserved.
//

import UIKit

protocol CollapsibleTableViewCellDelegate {
    func toggleCellSection(_ cell: CollapsibleTableViewCell, header: SecondaryTableViewHeader, indexPath: IndexPath?)
}

class CollapsibleTableViewCell: UITableViewCell {
    var delegate: CollapsibleTableViewCellDelegate?
    var indexPath: IndexPath?
    
    var event: Event? {
        didSet{
            tableView.reloadData()
        }
    }
    let tableView = UITableView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        //Auto resizing the height of the cell
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(SecondaryTableViewCell.self, forCellReuseIdentifier: String(describing: SecondaryTableViewCell.self))
        
        tableView.removeGestureRecognizer(tableView.panGestureRecognizer)
        contentView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tableView]-0-|", options: [], metrics: nil, views: ["tableView": tableView]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[tableView]-0-|", options: [], metrics: nil, views: ["tableView": tableView]))

// not working?
//        let marginGuide = contentView.layoutMarginsGuide
//        tableView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
//        tableView.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
//        tableView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
    }
    
    //init from storyboard
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
// UITableViewDelegate, UITableViewDataSource
//

extension CollapsibleTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = event?.relatedEvents?.count, count > 0, event?.collapsed == false {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SecondaryTableViewCell.self), for: indexPath)
        cell.textLabel?.text = event?.relatedEvents?[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if let count = event?.relatedEvents?.count, event?.collapsed == false && count > 0 {
//            return CGFloat(44 * (count + 1))
//        } else {
//            return 44
//        }
        return 44

//        return UITableView.automaticDimension
    }
    
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let identifier = String(describing: SecondaryTableViewHeader.self)
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? SecondaryTableViewHeader ??
            SecondaryTableViewHeader(reuseIdentifier:identifier)
        
        header.textLabel?.text = event?.title
        header.contentView.backgroundColor = UIColor.lightGray
        header.section = 0
        header.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
}


extension CollapsibleTableViewCell: CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        // Toggle collapse
        if event?.collapsed == false {
            event?.collapsed = true
        } else {
            event?.collapsed = false
        }
        
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
        
        delegate?.toggleCellSection(self, header: header as! SecondaryTableViewHeader, indexPath: indexPath)
    }
}
