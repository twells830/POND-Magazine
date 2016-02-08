//
//  fLink.swift
//  HitList
//
//  Created by Tanner Wells on 2/7/16.
//  Copyright © 2016 RazeWare. All rights reserved.
//

import Foundation
import Gloss

public struct FLink: Decodable {
    
    // 1
    public let href: String?
    public let text: String?
    
    // 2
    public init?(json: JSON) {
        href = "href" <~~ json
        text = "text" <~~ json
        
    }
}