//
//  MyTabBarController.swift
//  TranslateAppArc
//
//  Created by PS Shortcut on 01/04/2019.
//  Copyright © 2019 Panagiotis Siapkaras. All rights reserved.
//

import UIKit

class MyTabBarController : UITabBarController,UITabBarControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
//        if let textTrasnaltor = viewController as? TextTranslatorViewController{
//            //textTrasnaltor.callFromCameraController()
//        }
//        
//        if let cameraController = viewController as? CameraTranslatorViewController{
//            print("Camera View Controller")
//            
//        }
        
    }
    
}
