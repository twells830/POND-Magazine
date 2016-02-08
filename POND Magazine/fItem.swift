//
//  fItem.swift
//  HitList
//
//  Created by Tanner Wells on 2/7/16.
//  Copyright © 2016 RazeWare. All rights reserved.
//

import Foundation
import Gloss

public struct fItem: Decodable {
    
    // 1
    public let fTitle: String?
    public let fLink: FLink?
    public let url: String?
    public let index: Int?
    // 2
    public init?(json: JSON) {
        fTitle = "featuredTitle" <~~ json
        fLink = "featuredLink" <~~ json
        url = "url" <~~ json
        index = "index" <~~ json
    }
}