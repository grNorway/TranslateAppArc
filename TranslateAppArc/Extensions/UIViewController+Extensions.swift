//
//  UIViewController+Extensions.swift
//  TranslateAppArc
//
//  Created by PS Shortcut on 26/03/2019.
//  Copyright © 2019 Panagiotis Siapkaras. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setupButtonsContainer(container:UIView){
        container.layer.cornerRadius = container.frame.height / 2
        container.backgroundColor = .white
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.translationRed.cgColor
    }
    
    func buttonsAppearance(buttonSelected:UIButton,buttonReleased: UIButton){
        buttonUISelected(button: buttonSelected)
        buttonUIRelesed(button: buttonReleased)
    }
    
    func buttonUISelected(button:UIButton){
        button.layer.cornerRadius = button.frame.height / 2
        button.backgroundColor = UIColor.translationRed
        button.setTitleColor(.white, for: .normal)
    }
    
    func buttonUIRelesed(button:UIButton) {
        button.layer.cornerRadius = button.frame.height / 2
        button.backgroundColor = .white
        button.setTitleColor(UIColor.translationRed, for: .normal)
    }
    
}
