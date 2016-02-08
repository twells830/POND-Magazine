//
//  results.swift
//  HitList
//
//  Created by Tanner Wells on 2/7/16.
//  Copyright © 2016 RazeWare. All rights reserved.
//

import Foundation
import Gloss

public struct Results: Decodable {
    
    // 1
    public let top: [fItem]?
    public let body: [bItem]?
    
    // 2
    public init?(json: JSON) {
        top = "Top" <~~ json
        body = "Body" <~~ json
        
    }
}