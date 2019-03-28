//
//  CameraTranslatorViewController.swift
//  TranslateAppArc
//
//  Created by PS Shortcut on 27/03/2019.
//  Copyright (c) 2019 Panagiotis Siapkaras. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Photos

protocol CameraTranslatorDisplayLogic: class
{
    func presentLatestImage(image: UIImage)
}

class CameraTranslatorViewController: UIViewController, CameraTranslatorDisplayLogic
{
  var interactor: CameraTranslatorBusinessLogic?
  var router: (NSObjectProtocol & CameraTranslatorRoutingLogic & CameraTranslatorDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = CameraTranslatorInteractor()
    let presenter = CameraTranslatorPresenter()
    let router = CameraTranslatorRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
    //MARK: - Outlets
    @IBOutlet weak var captureView: UIView!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var photoLibraryImageView: UIImageView!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var visionFrameworkButtonContainer: UIView!
    @IBOutlet weak var translationOnDeviceButton: UIButton!
    @IBOutlet weak var translationOnCloudButton: UIButton!
    
    
    //MARK: - Properties
    
    var cameraController = CameraController()
    
    enum textDetectionType {
        case onDevice
        case onCloud
    }
    
    var selectedTextDetextion : textDetectionType = .onDevice
    
  // MARK: View lifecycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        requestPhotosAuthorization()
        configureCameraController()
        photoLibraryButtonnUI()
        visionFrameworkButtonsUI()
    }

    //MARK: - Protocol Functions
    
    func presentLatestImage(image:UIImage) {
        self.photoLibraryImageView.image = image
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let screenSize = captureView.bounds.size
        if let touchPoint = touches.first {
            let x = touchPoint.location(in: captureView).y / screenSize.height
            let y = 1.0 - touchPoint.location(in: captureView).x / screenSize.width
            let focusPoint = CGPoint(x:x,y:y)
            
            let touchMe = touchPoint.location(in: captureView)
            let focusImage = UIImage(named: "imgfocus")
            let focusImageView = UIImageView(image: focusImage)
            focusImageView.center = CGPoint(x: touchMe.x, y: touchMe.y)
            focusImageView.alpha = 1.0
            captureView.addSubview(focusImageView)
            
            UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 10, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
                focusImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { (_) in
                focusImageView.removeFromSuperview()
            }
            
            cameraController.autofocus(focusPoint: focusPoint)
        }
    }
    
    //MARK: - Actions
    
    @IBAction func captureImageButton(_ sender: UIButton) {
        cameraController.captureImage { (image, error) in
            
            guard error == nil else {
                print("Error captureImageButton : \(error!)")
                return
            }
            
            self.imagePreview.image = image
            self.captureView.isHidden = true
            
        }
    }
    
    @IBAction func flashButton(_ sender: UIButton) {
        if cameraController.flashMode == .off{
            cameraController.flashMode = .on
            flashButton.setImage(UIImage(imageLiteralResourceName: "Flash On Icon"), for: .normal)
        }else{
            cameraController.flashMode = .off
            flashButton.setImage(UIImage(imageLiteralResourceName: "Flash Off Icon"), for: .normal)
        }
    }
    //MARK: - Camera Functions
    
    private func configureCameraController(){
        
        cameraController.prepare { (error) in
            
            guard error == nil else {
                print("Error configureCameraController \(error!)")
                return
            }
            
            do{
                try self.cameraController.displayPreview(on: self.captureView)
            }catch{
                print("Failed try configurationCamera: \(error)")
            }
            
        }
    }
    
    //MARK: - Helper Functions
    
    fileprivate func requestPhotosAuthorization() {
        PHPhotoLibrary.requestAuthorization { [weak self] result in
            
            if let self = self {
                if result == .authorized{
                    self.interactor?.getLatestPhoto(for: self.photoLibraryImageView)
                }
            }
        }
    }
    
    private func photoLibraryButtonnUI(){
        photoLibraryImageView.layer.cornerRadius = 8
        photoLibraryImageView.layer.borderWidth = 1.5
        photoLibraryImageView.layer.borderColor =  UIColor.white.cgColor //UIColor.translationRed.cgColor
        photoLibraryImageView.clipsToBounds = true
    }
    
    private func visionFrameworkButtonsUI(){
        visionFrameworkButtonContainer.layer.cornerRadius = visionFrameworkButtonContainer.frame.height / 2
        visionFrameworkButtonContainer.clipsToBounds = true
    }
    
    @IBAction func toggleTextDetectionButtons(){
        if selectedTextDetextion == .onDevice {
            selectedTextDetextion = .onCloud
            translationOnDeviceButton.setImage(UIImage(imageLiteralResourceName: "icnDeviceInActive"), for: .normal)
            translationOnCloudButton.setImage(UIImage(imageLiteralResourceName: "icCloudActive"), for: .normal)
            translationOnDeviceButton.backgroundColor = .clear
            translationOnCloudButton.backgroundColor = UIColor.translationRed
        }else{
            selectedTextDetextion = .onDevice
            translationOnDeviceButton.setImage(UIImage(imageLiteralResourceName: "icnDeviceActive"), for: .normal)
            translationOnCloudButton.setImage(UIImage(imageLiteralResourceName: "icCloudInActive"), for: .normal)
            translationOnDeviceButton.backgroundColor = UIColor.translationRed
            translationOnCloudButton.backgroundColor = UIColor.clear
        }
    }
    
    
}
