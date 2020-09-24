//
//  AV.swift
//  Diometro
//
//  Created by Vitor Krau on 24/09/20.
//

import AVFoundation
import UIKit
import SwiftUI
import CoreML


class AVFoundationImplementation: UIViewController {
    
    var captureSession: AVCaptureSession?
    var rearCamera: AVCaptureDevice?
    var rearCameraInput: AVCaptureDeviceInput?
    var videoPreviewOutput: AVCaptureVideoDataOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var photoOutput: AVCapturePhotoOutput?
    var predictionLabel: String = ""
    var resizedImage: UIImage?
    var delegate: AVCapturePhotoCaptureDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func didTapRecord() {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: delegate!)
    }
    
    
    
    func setup(){
        self.captureSession = AVCaptureSession()
        let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)

        self.rearCamera = session.devices.first
        if let rearCamera = self.rearCamera {
            try? rearCamera.lockForConfiguration()
            rearCamera.focusMode = .autoFocus
            rearCamera.unlockForConfiguration()
            self.rearCameraInput = try? AVCaptureDeviceInput(device: rearCamera)
            
            if let rearCameraInput = rearCameraInput{
                // always make sure the AVCaptureSession can accept the selected input
                if ((captureSession?.canAddInput(rearCameraInput)) != nil) {
                // add the input to the current session
                captureSession?.addInput(rearCameraInput)
                }
            }
        }
        
        if let captureSession = captureSession {
            // create the preview layer with the configuration you want
            self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            self.videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.videoPreviewLayer?.connection?.videoOrientation = .portrait

            // then add the layer to your current view
            view.layer.insertSublayer(self.videoPreviewLayer!, at: 0)
            self.videoPreviewLayer?.frame = self.view.frame
            self.videoPreviewOutput = AVCaptureVideoDataOutput()
            self.videoPreviewOutput!.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer"))
            
            // always make sure the AVCaptureSession can accept the selected output
            if captureSession.canAddOutput(self.videoPreviewOutput!) {
                self.photoOutput = AVCapturePhotoOutput()
                self.photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
                captureSession.addOutput(self.photoOutput!)
              // add the output to the current session
                captureSession.addOutput(self.videoPreviewOutput!)
            }
        
        }
        self.captureSession?.startRunning()
        
    }

}

extension AVFoundationImplementation: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection){
            connection.videoOrientation = .portrait
            if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
                let ciImage = CIImage(cvImageBuffer: imageBuffer)
                let img = UIImage(ciImage: ciImage).resizeTo(CGSize(width: 299, height: 299))
                if let uiImage = img {
                    let pixelBuffer = uiImage.buffer()!
                    let output = try? Sky(configuration: MLModelConfiguration()).prediction(image: pixelBuffer)
                    DispatchQueue.main.async { [self] in
                        self.resizedImage = uiImage
                        self.predictionLabel = output?.classLabel ?? "I don't know! 😞"
                        print(self.predictionLabel)
                    }
                }
            }
        }

}

extension UIImage {
    func buffer() -> CVPixelBuffer? {
        return UIImage.buffer(from: self)
    }
    static func buffer(from image: UIImage) -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
    
    func resizeTo(_ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
