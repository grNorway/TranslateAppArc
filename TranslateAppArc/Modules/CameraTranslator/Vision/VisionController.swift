//
//  VisionController.swift
//  TranslateAppArc
//
//  Created by PS Shortcut on 28/03/2019.
//  Copyright © 2019 Panagiotis Siapkaras. All rights reserved.
//

import UIKit
import Firebase
import Vision

public enum DetectionModelType {
    case onDevice
    case onCloud
}

class VisionController {
    
    //Properties
    
//    enum detectionModelType {
//        case onDevice
//        case onCloud
//    }
    
    //Firebase Properties
    lazy var vision = Vision.vision()
    var textRecognizer : VisionTextRecognizer!
    
    func detectText(image:UIImage,detectionModel:DetectionModelType,completion: @escaping (String?,Error?) -> ()){
        switch detectionModel{
        case .onDevice:
            textRecognizer = vision.onDeviceTextRecognizer()
        case .onCloud:
            textRecognizer = vision.cloudTextRecognizer()
        }
        
        let visionImage = VisionImage(image: image)
        
        textRecognizer.process(visionImage) { (result, error) in
            
            guard error == nil else{
                print("Error on Vision Process : \(error!)")
                DispatchQueue.main.async {
                    completion(nil,error!)
                }
                return
            }

            guard let result = result else {
                let userInfo = [NSLocalizedDescriptionKey: "No results"]
                DispatchQueue.main.async {
                    completion(nil,NSError(domain: "detectTextVisionController", code: 0, userInfo: userInfo))
                }
                
                return
            }
            
            let detectedText = result.text
            DispatchQueue.main.async {
                completion(detectedText,nil)
            }
            
        }
    }
    
    
}
