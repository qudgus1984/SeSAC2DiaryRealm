//
//  ImageDummyData.swift
//  SeSAC2DiaryRealm
//
//  Created by jack on 2022/08/22.
//

import Foundation

struct ImageDummy {
    
    static let data: [Sample] = [
        Sample(url: "https://images.unsplash.com/photo-1417325384643-aac51acc9e5d?q=75&fm=jpg"),
        Sample(url: "https://images.unsplash.com/photo-1661074677991-707ef0f6ab8f?q=75&fm=jpg"),
        Sample(url: "https://images.unsplash.com/photo-1660866838643-52a55104175b?q=75&fm=jpg"),
        Sample(url: "https://images.unsplash.com/photo-1661084157362-5689c7311a8e?q=75&fm=jpg"),
        Sample(url: "https://images.unsplash.com/photo-1657299156653-d3c0147ba3ee?q=75&fm=jpg"),
        Sample(url: "https://images.unsplash.com/photo-1661074670187-3237f445f10d?q=75&fm=jpg"),
        Sample(url: "https://images.unsplash.com/photo-1661058342020-b9da482750e4?q=75&fm=jpg"),
        Sample(url: "https://images.unsplash.com/photo-1657299156271-d5a435dd65b0?q=75&fm=jpg"),
        Sample(url: "https://images.unsplash.com/photo-1657299156538-e08595d224ca?q=75&fm=jpg"),
        Sample(url: "https://images.unsplash.com/photo-1661091856780-88d7d4091c83?q=75&fm=jpg")
    ]
    
}

struct Sample {
    var url: String
}
