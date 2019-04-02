//
//  FromTextToTranslateDelegate.swift
//  TranslateAppArc
//
//  Created by PS Shortcut on 01/04/2019.
//  Copyright © 2019 Panagiotis Siapkaras. All rights reserved.
//

import UIKit

protocol FromTextToTranslateDelegateProtocol: class {
    func updateUItextViewDidChange(text : String)
}

class FromTextToTranslateDelegate : NSObject , UITextViewDelegate {
    
    var delegate : FromTextToTranslateDelegateProtocol?
    
    func textViewDidChange(_ textView: UITextView) {
        
        guard let delegate = delegate else {
            return
        }
        
        delegate.updateUItextViewDidChange(text: textView.text)
        
    }
    
}
