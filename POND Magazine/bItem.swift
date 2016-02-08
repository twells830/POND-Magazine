//
//  bItem.swift
//  HitList
//
//  Created by Tanner Wells on 2/7/16.
//  Copyright © 2016 RazeWare. All rights reserved.
//

import Foundation
import Gloss
public struct bItem: Decodable {
    
    // 1
    public let title: articleTitle?
    public let subTitle: FLink?
    public let image: articleImage?
    public let index: Int?
    public let url: String?
    // 2
    public init?(json: JSON) {
        title = "articleTitle" <~~ json
        subTitle = "articleSubtitle" <~~ json
        image = "articleImage" <~~ json
        index = "index" <~~ json
        url = "url" <~~ json
    }
}