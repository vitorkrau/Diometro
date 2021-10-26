//
//  CameraView.swift
//  Diometro
//
//  Created by Vitor Krau on 24/10/21.
//

import Foundation
import SwiftUI

struct CustomCameraView: View {
    
    @Binding var showCamera: Bool
    @Binding var uiImage: UIImage?
    @State var av = AVFoundationImplementation()
    var timeManager: TimeManager
    
    var body: some View {
        ZStack(alignment: .center) {
            CustomCameraRepresentable(uiImage: self.$uiImage, av: self.$av)
            CaptureButtonView(showCamera: self.$showCamera, av1: self.$av, timeManager: timeManager)
        }
    }
}
