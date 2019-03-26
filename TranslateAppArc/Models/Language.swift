//
//  Language.swift
//  TranslateAppArc
//
//  Created by PS Shortcut on 22/03/2019.
//  Copyright © 2019 Panagiotis Siapkaras. All rights reserved.
//

import Foundation

struct Language : Codable {
    
    let languageCode : String
    let name : String
//    var isFromSelected :Bool!
//    var isToSelected :Bool!
    
    enum CodingKeys : String, CodingKey{
        case name
        case languageCode = "language"
    }
}
