//
//  Language.swift
//  TranslateAppArc
//
//  Created by PS Shortcut on 22/03/2019.
//  Copyright © 2019 Panagiotis Siapkaras. All rights reserved.
//

import Foundation

struct Language : Codable {
    
    let language : String
    let name : String
    let isFromSelected :Bool?
    let isToSelected :Bool?
    
}
