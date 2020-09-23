//
//  CameraView.swift
//  Diometro
//
//  Created by Vitor Krau on 18/09/20.
//

import Foundation
import SwiftUI

struct CameraView1: UIViewControllerRepresentable {
    
    @Binding var showCameraView: Bool
    @Binding var pickedImage: Image?
    @Binding var screen: Int
    
    func makeCoordinator() -> CameraView1.Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView1>) -> UIViewController {
        let cameraViewController = UIImagePickerController()
        cameraViewController.delegate = context.coordinator
        cameraViewController.sourceType = .camera
        cameraViewController.allowsEditing = false
        
        return cameraViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CameraView1>) {
        
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: CameraView1
        
        init(_ cameraView: CameraView1) {
            self.parent = cameraView
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            parent.pickedImage = Image(uiImage: uiImage)
            parent.showCameraView = false
            parent.screen = 1
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.showCameraView = false
        }
    }
}
