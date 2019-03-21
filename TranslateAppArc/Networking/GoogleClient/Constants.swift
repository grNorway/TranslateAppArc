//
//  Constants.swift
//  TranslateAppArc
//
//  Created by PS Shortcut on 21/03/2019.
//  Copyright © 2019 Panagiotis Siapkaras. All rights reserved.
//

import Foundation

struct Constants {
    
    struct GoogleTranslate{
        static let scheme = "https"
        static let host = "translation.googleapis.com"
        static let pathTranslations = "/language/translate/v2"
        static let pathLanguages = "/language/translate/v2/languages"
        
        
        struct parameterKeys {
            static let apiKey = "key"
        }
        
        struct parameterValues {
            static let apikeyValue = "AIzaSyB9KgxiWouUxpXcx4fzC0Tjkkvst4_NPpI"
        }
        
    }
    
}
