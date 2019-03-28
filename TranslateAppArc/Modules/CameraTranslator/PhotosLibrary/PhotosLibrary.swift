//
//  PhotosLibrary.swift
//  TranslateAppArc
//
//  Created by PS Shortcut on 27/03/2019.
//  Copyright © 2019 Panagiotis Siapkaras. All rights reserved.
//

import UIKit
import Photos

class PhotosLibrary {
    
    func fetchLatestPhoto(target : UIImageView,completion: @escaping (UIImage) -> ()){
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1
        
        let fetchResult : PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        if fetchResult.count > 0 {
            DispatchQueue.main.async {
                PHImageManager.default().requestImage(for: fetchResult.object(at: 0), targetSize: target.frame.size, contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, nil) in
                    
                    if let image = image {
                        completion(image)
                    }
                    
                })
            }
        }
    }
    
}
