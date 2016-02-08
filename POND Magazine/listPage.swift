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
    public let newData: Bool?
    public let thisVer: String?
    public let results: Results?
    
    // 2
    public init?(json: JSON) {
        count = "count" <~~ json
        newData = "newdata" <~~ json
        thisVer = "thisversionrun" <~~ json
        results = "results" <~~ json
        
    }
}