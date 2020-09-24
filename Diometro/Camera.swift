import SwiftUI
import AVFoundation

struct CustomCameraView: View {
    
    @Binding var image: Image?
    @Binding var showCamera: Bool
    @Binding var uiImage: UIImage?
    @State var didTapCapture: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            CustomCameraRepresentable(image: self.$image, didTapCapture: $didTapCapture, uiImage: self.$uiImage)
            CaptureButtonView(didTapCapture: self.$didTapCapture, showCamera: self.$showCamera)
        }
    }
}

struct CustomCameraRepresentable: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: Image?
    @Binding var didTapCapture: Bool
    @Binding var uiImage: UIImage?
    
    func makeUIViewController(context: Context) -> AVFoundationImplementation {
        let controller = AVFoundationImplementation()
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ cameraViewController: AVFoundationImplementation, context: Context) {
        
        if(self.didTapCapture) {
            cameraViewController.didTapRecord()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {
        let parent: CustomCameraRepresentable
        
        init(_ parent: CustomCameraRepresentable) {
            self.parent = parent
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            parent.didTapCapture = false
            
            if let imageData = photo.fileDataRepresentation() {
                parent.image = Image(uiImage: UIImage(data: imageData)!)
                parent.uiImage = UIImage(data: imageData)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
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
    @Binding var didTapCapture: Bool
    @Binding var showCamera: Bool
    @ObservedObject var mm : MotionManager = MotionManager()

    var body: some View {
        ZStack{
            VStack(alignment: .center){
                Button(action: { self.showCamera = false }){
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                        .padding(.leading, 300)
                        .padding(.top, 60)
                }
                Spacer()
                Image(systemName: "camera.circle.fill")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .padding(.bottom, 100)
                    .background(Color.white)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white)
                            .scaleEffect(animationAmount)
                            .opacity(Double(2 - animationAmount))
                            .animation(Animation.easeOut(duration: 1)
                                .repeatForever(autoreverses: false))
                    )
                    .onAppear{
                        self.animationAmount = 2
                    }
                    .onTapGesture {
                        if self.mm.z > 0.4 && self.mm.z < 1.2{
                            self.didTapCapture = true
                        }
                    }
            }
            if self.mm.z < 0.4 || self.mm.z > 1.2{
                Text("OLHA PRO CEU")
                    .padding(.bottom, UIScreen.main.bounds.height - 300)
                    .font(.system(size: 50, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .purple, radius: 10)
                    .opacity(animatedShadow ? 0 : 1)
                    .animation(Animation.easeOut(duration: 1).repeatForever(autoreverses: self.mm.z < 0.4 || self.mm.z > 1.2))
                    .onAppear{ self.animatedShadow.toggle()}
            }
        }
    }
}



