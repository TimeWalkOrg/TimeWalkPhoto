//
//  LocationManager.swift
//  TimeWalkPhoto
//
//  Created by iMac on 03/06/24.
//

import UIKit
import CoreLocation
import CoreMotion

class LocationManager: NSObject {
    
    // MARK: - Variable & Constants
    let locationManager = CLLocationManager()
    let motionManager = CMMotionManager()
    var userHeightAboveGround: Double = 0.0
    var lastLocation =  CLLocation()
    var didUpdateLocation: ((CLLocation)->(Void))?
    var didUpdateHeading: ((CLLocationDirection)->(Void))?
    var didUpdatePitch: ((Double)->(Void))?
    var onAuthorizationStatusChanged: ((_ status: CLAuthorizationStatus) -> (Void))?

    // MARK: - Init()
    override init() {
        super.init()
    }
    
    // MARK: - Functions
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        motionManager.deviceMotionUpdateInterval = 0.1
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates(to: .main) { (data, error) in
                if let validData = data {
                    let pitch = validData.attitude.pitch * 180 / .pi
                    let accuratePitch =  pitch.adjustPitchForOrientation()
                    self.didUpdatePitch?(accuratePitch)
                }
            }
        }
    }
    
    func startUpdates() {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        motionManager.stopDeviceMotionUpdates()
    }
    
    func stopUpdates() {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
        motionManager.startDeviceMotionUpdates()
    }
    
    func promptUserForHeight(viewController: UIViewController) {
        let alert = UIAlertController(title: "Height Above Ground", message: "Please enter the height (in meters) at which you are holding your iPhone.", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.keyboardType = .decimalPad
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if let textField = alert?.textFields?[0], let heightText = textField.text, let height = Double(heightText) {
                self.userHeightAboveGround = height
            }
        }))
        
        viewController.present(alert, animated: true, completion: nil)
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined :
            print("notDetermined")
            break;
        case .restricted, .denied:
            print("No access")
            break;
        case .authorizedAlways, .authorizedWhenInUse:
            setupLocationManager()
            break;
        @unknown default:
            break
        }
        self.onAuthorizationStatusChanged?(manager.authorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let coordinate = location.coordinate
            let altitude = location.altitude
            lastLocation = location
            didUpdateLocation?(location)
            print("Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude), Altitude: \(altitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let compassAngle = newHeading.trueHeading
        didUpdateHeading?(compassAngle)
    }
}
