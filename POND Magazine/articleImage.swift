//
//  articleImage.swift
//  HitList
//
//  Created by Tanner Wells on 2/7/16.
//  Copyright © 2016 RazeWare. All rights reserved.
//

import Foundation
import Gloss

public struct articleImage: Decodable {
    
    // 1
    public let src: String?
    // 2
    public init?(json: JSON) {
        src = "src" <~~ json
    }
}