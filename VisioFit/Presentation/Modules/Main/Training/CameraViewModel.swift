import AVFoundation
import Combine
import Vision
import Foundation

class CameraViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var session = AVCaptureSession()
    @Published var accuracy: Int = 100
//    @Published var pointsPosition: [CGPoint] = [] Для отрисовки скелета
    @Published var count: Int = 0
    
    private let request = VNDetectHumanBodyPoseRequest()
    private var lastTimeStap = Date()
    private let timeStap = 0.05
    private var currentAnalyzer: ExerciseAnalyzer
    
    init(analyzer: ExerciseAnalyzer) {
        self.currentAnalyzer = analyzer
        super.init()
    }
    
    func start() {
        if !session.inputs.isEmpty {
            if !session.isRunning {
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    self?.setupSession()
                }
            }
            return
        }
        checkPermissions()
    }
    
    func stop() {
        guard session.isRunning else { return }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.stopRunning()
        }
    }
    
    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async { self?.setupSession() }
                }
            }
        default:
            break
        }
    }
    
    func setupSession() {
        session.beginConfiguration()
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera],
                mediaType: .video,
                position: .front
            )
        
        guard let device = deviceDiscoverySession.devices.first,
              let input = try? AVCaptureDeviceInput(device: device) else { return }
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "cameraQueue"))
        
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }
        
        session.commitConfiguration()
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.startRunning()
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard Date().timeIntervalSince(self.lastTimeStap) > self.timeStap else { return }
        
        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .leftMirrored, options: [:])
        
        do {
            try handler.perform([request])
            
            guard let observations = request.results else { return }
            
            var sholders: [CGPoint] = []
            var elbows: [CGPoint] = []
            var wrists: [CGPoint] = []
            for observation in observations {
                let leftShoulder = try observation.recognizedPoint(.leftShoulder)
                sholders.append(leftShoulder.location)
                let rightShoulder = try observation.recognizedPoint(.rightShoulder)
                sholders.append(rightShoulder.location)
                
                let leftElbow = try observation.recognizedPoint(.leftElbow)
                elbows.append(leftElbow.location)
                let rightElbow = try observation.recognizedPoint(.rightElbow)
                elbows.append(rightElbow.location)
                
                let leftWrist = try observation.recognizedPoint(.leftWrist)
                wrists.append(leftWrist.location)
                let rightWrist = try observation.recognizedPoint(.rightWrist)
                wrists.append(rightWrist.location)
            }
            
            
            DispatchQueue.main.async {
//                self.pointsPosition = []
//                self.pointsPosition.append(contentsOf: sholders) Для отрисовки скелета
//                self.pointsPosition.append(contentsOf: elbows)
//                self.pointsPosition.append(contentsOf: wrists)
                
                if Date().timeIntervalSince(self.lastTimeStap) > self.timeStap {
                    
                    let pose = BodyPoseData(shoulders: sholders, elbows: elbows, wrists: wrists)
                    
                    self.currentAnalyzer.analyze(pose: pose)
                    self.count = self.currentAnalyzer.count
                    self.accuracy = self.currentAnalyzer.accuracy
                    
                    self.lastTimeStap = Date()
                }
            }
            
        } catch {
            print("Vision error: \(error)")
        }
    }
    
    
}
