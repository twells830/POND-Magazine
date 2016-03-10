//
//  listPage.swift
//  HitList
//
//  Created by Tanner Wells on 2/7/16.
//  Copyright © 2016 RazeWare. All rights reserved.
//

import Foundation
import Gloss

public struct listPage: Decodable {
    
    // 1
    public let count: Int?
    public let ver: String?
    public let items: [item]?
    
    // 2
    public init?(json: JSON) {
        count = "count" <~~ json
        ver = "thisversionrun" <~~ json
        items = "items" <~~ json
        
    }
}