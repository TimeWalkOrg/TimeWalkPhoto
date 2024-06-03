//
//  ViewController.swift
//  TimeWalkPhoto
//
//  Created by MyMac on 03/06/24.
//

import UIKit
import CoreLocation
import AVFoundation

class ViewController: UIViewController {
    
    // MARK: - IBOulets
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    @IBOutlet weak var lblAltitude: UILabel!
    @IBOutlet weak var lblCompassAngle: UILabel!
    @IBOutlet weak var lblPitch: UILabel!
    @IBOutlet weak var lblZoomFactor: UILabel!
    
    @IBOutlet weak var btnCapture: UIButton!
    
    @IBOutlet weak var viewCamera: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewStack: UIStackView!
    
    // MARK: - Variables
    let locationManager = LocationManager()
    
    var captureSession: AVCaptureSession!
    var cameraOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        checkCameraPermission()
        
        // Set the delegate and request location authorization
        locationManager.onAuthorizationStatusChanged = { [weak self] status in
            self?.handleLocationAuthorizationStatus(status: status)
        }
        
        // Start the location manager
        locationManager.setupLocationManager()
        setUpLocationUpdates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global().async {
            
            if self.captureSession != nil {
                if !self.captureSession.isRunning {
                    self.captureSession.startRunning()
                }
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func btnCaptureAction(_ sender: UIButton) {
        #if !targetEnvironment(simulator)
        DispatchQueue.main.async  {
            
            let settings = AVCapturePhotoSettings()
            let pbpf = settings.availablePreviewPhotoPixelFormatTypes[0]
            settings.previewPhotoFormat = [
                kCVPixelBufferPixelFormatTypeKey as String : pbpf,
                kCVPixelBufferWidthKey as String : self.viewCamera.bounds.size.width,
                kCVPixelBufferHeightKey as String :  self.viewCamera.bounds.height
            ]
            
            self.cameraOutput?.capturePhoto(with: settings, delegate: self)
        }
        #endif
    }

    
    // MARK: - Functions
    private func handleLocationAuthorizationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager.setupLocationManager()
            self.setUpLocationUpdates()
        case .restricted, .denied:
            // Show alert directing the user to settings
            self.lblLatitude.text = "Latitude: "
            self.lblLongitude.text = "Longitude: "
            self.lblAltitude.text = "Altitude: "
            showLocationDisabledAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            // Go to the next screen
            self.checkCameraPermission()
        @unknown default:
            fatalError("Unhandled case")
        }
    }
    
    func setUpUI() {
        let size = CGSize(width: 0, height: 0.5), color: UIColor = .gray
        let radius: CGFloat = 1.5, opacity: Float = 0.4
        
        lblLatitude.addShadow(offset: size, color: color, radius: radius, opacity: opacity)
        lblLongitude.addShadow(offset: size, color: color, radius: radius, opacity: opacity)
        lblAltitude.addShadow(offset: size, color: color, radius: radius, opacity: opacity)
        lblPitch.addShadow(offset: size, color: color, radius: radius, opacity: opacity)
        lblCompassAngle.addShadow(offset: size, color: color, radius: radius, opacity: opacity)
        lblZoomFactor.addShadow(offset: size, color: color, radius: radius, opacity: opacity)
        btnCapture.addShadow(offset: size, color: color, radius: radius, opacity: opacity)
    }
    
    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            requestCameraPermission()
        case .denied, .restricted:
            showPermissionAlert()
        @unknown default:
            fatalError("New case is added in AVCaptureDevice's authorization status.")
        }
    }
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            guard let self = self else { return }
            if granted {
                DispatchQueue.main.async {
                    self.setupCamera()
                }
            } else {
                DispatchQueue.main.async {
                    self.showPermissionAlert()
                }
            }
        }
    }
    
    func setUpLocationUpdates() {
        locationManager.didUpdatePitch = { [weak self] pitch in
            guard let self = self else { return }
            self.lblPitch.text = "Pitch: \(pitch)"
        }
        
        locationManager.didUpdateHeading = { [weak self] heading in
            guard let self = self else { return }
            self.lblCompassAngle.text = "Compass Angle: \(heading)"
        }
        
        locationManager.didUpdateLocation = { [weak self] location in
            guard let self = self else { return }
            let coordinate = location.coordinate
            let altitude = location.altitude + self.locationManager.userHeightAboveGround
            self.lblLatitude.text = "Latitude: \(coordinate.latitude)"
            self.lblLongitude.text = "Longitude: \(coordinate.longitude)"
            self.lblAltitude.text = "Altitude: \(altitude)"
        }
    }
    
    private func showLocationDisabledAlert() {
        let alertController = UIAlertController(title: "Location Access Disabled",
                                                message: "Please enable location access in Settings to use this feature.",
                                                preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: { success in
                    if success {
                        print("Settings opened successfully")
                    } else {
                        print("Failed to open settings")
                    }
                })
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showPermissionAlert() {
        let alertController = UIAlertController(title: "Camera Access Denied", message: "Please grant camera access in Settings to use this feature.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func showImageSavedAlert() {
        let alertController = UIAlertController(title: "Image successfully saved to gallery.", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alertController, animated: true, completion: nil)
    }
    
    func setupCamera() {        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let backCamera = AVCaptureDevice.default(for: .video) else {
            print("Unable to access back camera!")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            cameraOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddInput(input) && captureSession.canAddOutput(cameraOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(cameraOutput)
                setupLivePreview()
            }
        } catch let error {
            print("Error setting up camera: \(error.localizedDescription)")
        }
    }
    
    func setupLivePreview() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        viewCamera.layer.addSublayer(previewLayer)
        previewLayer.frame = viewCamera.bounds
        
        DispatchQueue.global().async {
            self.captureSession.startRunning()
            
            DispatchQueue.main.async {
                self.lblZoomFactor.text = "Zoom Factor: 1.0"
                let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinchGesture(_:)))
                self.view.addGestureRecognizer(pinchGesture)
            }
        }
    }
    
    func stopCaptureSession() {
        self.previewLayer?.removeFromSuperlayer()
        self.previewLayer = nil
        self.captureSession.stopRunning()
        for input in captureSession.inputs {
            self.captureSession.removeInput(input)
        }
        for output in captureSession.outputs {
            self.captureSession.removeOutput(output)
        }
    }
    
    @objc func handlePinchGesture(_ recognizer: UIPinchGestureRecognizer) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            try device.lockForConfiguration()
            let maxZoomFactor: CGFloat = 5.0
            let pinchVelocityDividerFactor: CGFloat = 10.0
            
            let desiredZoomFactor = device.videoZoomFactor + atan2(recognizer.velocity, pinchVelocityDividerFactor)
            let zoomFactor = max(1.0, min(desiredZoomFactor, maxZoomFactor))
            device.videoZoomFactor = zoomFactor
            
            DispatchQueue.main.async {
                self.lblZoomFactor.text = "Zoom Fator: \(String(format: "%0.1f", zoomFactor))"
            }
            
            device.unlockForConfiguration()
        } catch {
            print("Error setting zoom: \(error.localizedDescription)")
        }
    }
}

extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation(), let photoImage = UIImage(data: imageData) else {
            print("Error capturing photo")
            return
        }
        
        DispatchQueue.main.async {
            self.stopCaptureSession()
            let stackImage = self.viewStack.getSnapshotImage()
            
        
            if let detailedImage = photoImage.merge(with: stackImage) {
                UIImageWriteToSavedPhotosAlbum(detailedImage, nil, nil, nil)
            }
            
            UIImageWriteToSavedPhotosAlbum(photoImage, nil, nil, nil)
            self.showImageSavedAlert()
            self.setupCamera()
        }
    }
}

