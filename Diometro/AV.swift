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
import Vision

class AVFoundationImplementation: UIViewController, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    static var instance = AVFoundationImplementation()
    var captureSession: AVCaptureSession?
    var rearCamera: AVCaptureDevice?
    var rearCameraInput: AVCaptureDeviceInput?
    var videoPreviewOutput: AVCaptureVideoDataOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var photoOutput: AVCapturePhotoOutput?
    
    @Published var predictionLabel: String = ""
    var resizedImage: UIImage?
    var delegate: AVCapturePhotoCaptureDelegate?
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: Sky(configuration: MLModelConfiguration()).model)
            let request = VNCoreMLRequest(model: model, completionHandler: {   [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }}()
    
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
            rearCamera.focusMode = .continuousAutoFocus
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
    
    func createClassificationsRequest(for image: UIImage) {
        let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue))!
        guard let ciImage = CIImage(image: image)
        else {
            fatalError("Unable to create \(CIImage.self) from \(image).")
        }
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            }catch {
                print("Failed to perform \n\(error.localizedDescription)")
            }
        }
    }
    
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results
            else {
                self.predictionLabel = "Unable to classify image.\n"
                return
            }
            let classifications = results as! [VNClassificationObservation]
            if classifications.isEmpty {
                self.predictionLabel = "Nothing recognized."
            } else {
                classifications.prefix(1).forEach{ classification in
                    if classification.identifier == "Sky" && classification.confidence > 0.95{
                       self.predictionLabel = "Sky"
                    }
                    else{
                       self.predictionLabel = "Not Sky"
                    }
                }
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection){
        connection.videoOrientation = .portrait
        if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            let ciImage = CIImage(cvImageBuffer: imageBuffer)
            let img = UIImage(ciImage: ciImage).resizeTo(CGSize(width: 299, height: 299))
            if let uiImage = img {
                createClassificationsRequest(for: uiImage)
            }
        }
    }
    
}

extension UIImage {
    func resizeTo(_ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}


