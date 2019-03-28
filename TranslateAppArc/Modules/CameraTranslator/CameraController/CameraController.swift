//
//  CameraController.swift
//  TranslateApp
//
//  Created by PS Shortcut on 13/02/2019.
//  Copyright © 2019 Panagiotis Siapkaras. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class CameraController : NSObject {
    
    //MARK: - Properties
    //Session
    var captureSession : AVCaptureSession?
    
    //Cameras
    var frontCamera : AVCaptureDevice?
    var rearCamera : AVCaptureDevice?
    
    var currentCameraPosition : CameraPosition?
    var frontCameraInput: AVCaptureInput?
    var rearCameraInput : AVCaptureInput?
    var photoOutput: AVCapturePhotoOutput?
    
    var previewLayer : AVCaptureVideoPreviewLayer?
 
    //Errors
    enum CameraControllerError : Swift.Error{
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCameraAvailable
        case unknown
    }
    
    enum CameraPosition {
        case front
        case rear
    }
    
    
    var flashMode = AVCaptureDevice.FlashMode.off
    
    var photoCaptureCompletionBlock : ((UIImage?,Error?) -> ())?
    
    //MARK: - Functions
    
    func prepare(completionForPrepare: @escaping (_ error:Error?) -> ()){
        
        func createCaptureSession() { captureSession = AVCaptureSession() }
        
        func configureCaptureDevices() throws {
            
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
            
            let cameras = session.devices
            if cameras.isEmpty {
                throw CameraControllerError.noCameraAvailable
            }
            
            for camera in cameras {
                if camera.position == .front{
                    self.frontCamera = camera
                }
                if camera.position == .back{
                    self.rearCamera = camera
                    try camera.lockForConfiguration()
                    camera.focusMode = .continuousAutoFocus
                    camera.unlockForConfiguration()
                }
                //Check for Crashing
                
            }
            
            
        }
        
        func configureDeviceInputs() throws {
            
            guard let captureSession = self.captureSession else {
                throw CameraControllerError.captureSessionIsMissing
            }
            
            if let rearCamera = rearCamera{
                rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
                
                if captureSession.canAddInput(rearCameraInput!){
                    captureSession.addInput(rearCameraInput!)
                    currentCameraPosition = .rear
                }else if let frontCamera = frontCamera{
                    frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                    
                    if captureSession.canAddInput(frontCameraInput!){
                        captureSession.addInput(frontCameraInput!)
                        currentCameraPosition = .front
                    }else{
                        throw CameraControllerError.inputsAreInvalid
                    }
                }else{
                    throw CameraControllerError.noCameraAvailable
                }
            }
            
        }
        
        func configurePhotoOutput() throws {
            
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            self.photoOutput = AVCapturePhotoOutput()
            self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])], completionHandler: nil)
            
            if captureSession.canAddOutput(self.photoOutput!){
                captureSession.addOutput(self.photoOutput!)
            }
            
            captureSession.startRunning()
            
        }
        
        DispatchQueue(label: "prepare").async {
            do{
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
            }catch{
                DispatchQueue.main.async {
                    completionForPrepare(error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completionForPrepare(nil)
            }
        }
        
    }
    
    func displayPreview(on view: UIView)throws {
        guard let captureSession = self.captureSession,captureSession.isRunning else {
            throw CameraControllerError.captureSessionIsMissing
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer!.frame = view.frame
        
    }
    
//    func switchToRearCamera() throws {
//
//        guard let inputs = self.captureSession?.inputs as? [AVCaptureInput], let frontCameraInput = self.frontCameraInput,inputs.contains(frontCameraInput),let rearCamera = self.rearCamera else{
//            throw CameraControllerError.invalidOperation
//        }
//
//
//    }
    
    func captureImage(completion:@escaping (UIImage?,Error?) -> ()){
        
        guard let captureSession = self.captureSession, captureSession.isRunning else {
            completion(nil,CameraControllerError.captureSessionIsMissing)
            return
        }
        
        let settings = AVCapturePhotoSettings()
        settings.flashMode = self.flashMode
        
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
        self.photoCaptureCompletionBlock = completion
        
    }
    
    func autofocus(focusPoint : CGPoint){
        if let device = rearCamera{
            do{
                try device.lockForConfiguration()
                device.isFocusModeSupported(.continuousAutoFocus)
                device.focusPointOfInterest = focusPoint
                device.focusMode = .autoFocus
                device.exposurePointOfInterest = focusPoint
                
                device.exposureMode = .continuousAutoExposure
                device.unlockForConfiguration()
            }catch{
                print("Error autofocus \(error)")
            }
        }
    }
    
}

extension CameraController : AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            self.photoCaptureCompletionBlock?(nil,error)
        }else if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil), let image = UIImage(data: data){
            self.photoCaptureCompletionBlock?(image,nil)
        }else{
            self.photoCaptureCompletionBlock?(nil,CameraControllerError.unknown)
        }
        
    }
    
}
