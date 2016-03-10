//
//  bItem.swift
//  HitList
//
//  Created by Tanner Wells on 2/7/16.
//  Copyright © 2016 RazeWare. All rights reserved.
//

import Foundation
import Gloss
public struct item: Decodable {
    
    // 1
    public let title: String?
    public let subTitle: String?
    public let imageURL: String?
    public let articleURL: String?
    public let url: String?
    public let index: Int?
    public let featured: String?
    // 2
    public init?(json: JSON) {
        title = "title" <~~ json
        subTitle = "subtitle" <~~ json
        imageURL = "imageURL" <~~ json
        articleURL = "articleURL" <~~ json
        index = "index" <~~ json
        url = "URL" <~~ json
        featured = "feautred" <~~ json
    }
}