//
//  ViewController.swift
//  CollapsibleSectionAndCellTableView
//
//  Created by Charles on 25/09/18.
//  Copyright © 2018 Sky Network Television Limited. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if let path = Bundle.main.path(forResource: "search_crime", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let person = jsonResult["person"] as? [Any] {
                    
                }
            } catch let error {
                print("parse error:\(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path")
        }
//        let categoryArray = try? newJSONDecoder().decode(CategoryArray.self, from: jsonData)
        
    }


}

