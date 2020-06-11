//
//  NewsFeed.swift
//  NewsApp
//
//  Created by Barrett on 2020-05-29.
//  Copyright © 2020 Barrett Arbour. All rights reserved.
//

import Foundation

struct NewsFeed: Codable {
    
    var status:String = "" //default value
    var totalResults:Int = 0
    var articles:[Article]?
    
}
