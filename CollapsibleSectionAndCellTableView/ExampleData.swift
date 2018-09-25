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

typealias CategoryArray = [CategoryArrayElement]

struct CategoryArrayElement: Codable {
    let category: String
    let events: [Event]
}

struct Event: Codable {
    let id, title, synopsis: String
    let channelNumber: Int
    let start, end: String
    let genres: [Genre]
    let rating: String
    let seriesID: String?
    let relatedEvents: [Event]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, synopsis, channelNumber, start, end, genres, rating
        case seriesID = "seriesId"
        case relatedEvents
    }
}

enum Genre: String, Codable {
    case cartoonsPuppets = "Cartoons/Puppets"
    case culturalDocumentary = "Cultural Documentary"
    case generalEntertainment = "General Entertainment"
    case historicalDocumentary = "Historical Documentary"
    case investigations = "Investigations"
    case kidsFamily = "Kids/Family"
    case movie = "Movie"
    case realityShow = "Reality Show"
    case thriller = "Thriller"
}
