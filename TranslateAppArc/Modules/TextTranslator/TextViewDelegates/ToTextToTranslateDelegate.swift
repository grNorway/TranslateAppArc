//
//  ToTextToTranslateDelegate.swift
//  TranslateAppArc
//
//  Created by PS Shortcut on 01/04/2019.
//  Copyright © 2019 Panagiotis Siapkaras. All rights reserved.
//

import UIKit

protocol ToTextToTranslateDelegateProtocol{
    func updateUITexViewDidChange(text:String)
}

class ToTextToTranslateDelegate : NSObject , UITextViewDelegate {
    
    var delegate : ToTextToTranslateDelegateProtocol?
    
    func textViewDidChange(_ textView: UITextView) {
        guard let delegate = delegate else{
            return
        }
        
        delegate.updateUITexViewDidChange(text: textView.text)
    }
    
}
