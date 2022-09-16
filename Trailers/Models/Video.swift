//
//  Video.swift
//  Netflix Clone
//
//  Created by ithink on 04/09/22.
//

import Foundation

// TMDB Video Element
struct VideoResponse: Codable {
    let id: Int
    let results: [VideoElement]
}

struct VideoElement: Codable {
    let key: String
}

// YouTube Video Element
struct YouTubeResponse: Codable {
    let items: [VideoItem]
}

struct VideoItem: Codable {
    let id: VideoId
}

struct VideoId: Codable {
    let videoId: String
}
