//
//  Element.swift
//  Netflix Clone
//
//  Created by ithink on 02/09/22.
//

import Foundation

struct ElementResponse: Codable {
    let results: [Element]
}

struct Element: Codable {
    
    let id: Int
    let media_type: String?
    let original_title: String?
    let original_name: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
    
}
