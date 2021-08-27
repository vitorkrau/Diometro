import SwiftUI
import AVFoundation


struct CustomCameraView: View {
    
    @Binding var showCamera: Bool
    @Binding var uiImage: UIImage?
    @State var av = AVFoundationImplementation()
    
    var body: some View {
        ZStack(alignment: .center) {
            CustomCameraRepresentable(uiImage: self.$uiImage, av: self.$av)
            CaptureButtonView(showCamera: self.$showCamera, av1: self.$av)
        }
    }
}

struct CustomCameraRepresentable: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var uiImage: UIImage?
    @Binding var av: AVFoundationImplementation
    
    func makeUIViewController(context: Context) -> AVFoundationImplementation {
        let controller = av
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ cameraViewController: AVFoundationImplementation, context: Context) {}
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {
        let parent: CustomCameraRepresentable
        
        init(_ parent: CustomCameraRepresentable) { self.parent = parent }
        
    }
}

class CustomCameraController: UIViewController {
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    //DELEGATE
    var delegate: AVCapturePhotoCaptureDelegate?
    
    func didTapRecord() {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: delegate!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
    }
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        for device in deviceDiscoverySession.devices {
            switch device.position {
            case AVCaptureDevice.Position.front:
                self.frontCamera = device
            case AVCaptureDevice.Position.back:
                self.backCamera = device
            default:
                break
            }
        }
        
        self.currentCamera = self.backCamera
    }
    
    func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }
    
    func setupPreviewLayer(){
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        self.cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    func startRunningCaptureSession(){
        captureSession.startRunning()
    }
}

struct CaptureButtonView: View {
    @State private var animationAmount: CGFloat = 1
    @State private var animatedShadow = false
    @Binding var showCamera: Bool
    @Binding var av1: AVFoundationImplementation
    @ObservedObject var mm: MotionManager = MotionManager()

    var body: some View {
        ZStack(alignment: .center){
            VStack{
                Button(action: {
                        self.showCamera = false
                        self.av1.stopSession()
                }){
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                        .padding(.leading, 300)
                        .padding(.top, 60)
                }
                Spacer()
            }
            if self.mm.z < 0.4 || self.mm.z > 1.2 {
                lookAtTheSky()
            }
            else{
                if self.av1.predictionLabel != "Sky" {
                    lookAtTheSky()
                }
                else{
                    setOverlay(timeOfTheDay: Time.instance.getTimeOfTheDay())
                }
            }
            Spacer()
        }
    }
    
    fileprivate func setOverlay(timeOfTheDay: String) -> some View{
        return
            Text(timeOfTheDay)
            .font(.system(size: 70, weight: .heavy, design: .rounded))
            .foregroundColor(.white)
            .shadow(color: .gray, radius: 5)
    }
    
    
    fileprivate func lookAtTheSky() -> some View{
        return
            Text("MIRE PRO CÉU")
                .font(.system(size: 36, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .black, radius: 10)
                .opacity(animatedShadow ? 0 : 1)
                .animation(Animation.easeOut(duration: 1).repeatForever(autoreverses: true))
                .onAppear{ self.animatedShadow.toggle() }
    }
}



