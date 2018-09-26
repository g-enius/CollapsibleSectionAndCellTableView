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

class CategoryRaw: Codable {
    let category: String
    let events: [EventRaw]
}

class EventRaw: Codable {
    let id, title, synopsis: String
    let channelNumber: Int
    let start, end: String
    let genres: [String]
    let rating: String
    let seriesID: String?
    let relatedEvents: [EventRaw]?
}

class Category:CategoryRaw {
    var collapsed: Bool = true
}

class Event: EventRaw {
    var collapsed: Bool = true
}
