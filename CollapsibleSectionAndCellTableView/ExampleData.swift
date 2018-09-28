//
//  ExampleData.swift
//  CollapsibleSectionAndCellTableView
//
//  Created by Charles on 25/09/18.
//  Copyright © 2018 Sky Network Television Limited. All rights reserved.
//
// To parse the JSON, add this file to your project and do:
//
//   let categoryArray = try? newJSONDecoder().decode(CategoryArray.self, from: jsonData)

import Foundation

typealias CategoryArray = [Category]

class Category: Codable {
    let category: String
    let events: [Event]
    var collapsed: Bool?
}

class Event: Codable {
    let id, title, synopsis: String
    let channelNumber: Int
    let start, end: String
    let genres: [String]
    let rating: String?
    let seriesID: String?
    let relatedEvents: [Event]?
    var collapsed: Bool?
}
