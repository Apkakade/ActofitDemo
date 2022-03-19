//
//  LocationService.swift
//  ActofitDemoApp
//
//  Created by Apple on 19/03/22.
//
import UIKit
import Foundation
import CoreLocation

protocol LocationServiceDelegate {
    func locationService(_ service: LocationService, didMonitorEntering region: CLRegion)
    func locationService(_ service: LocationService, didMonitorExiting region: CLRegion)
    func locationService(_ service: LocationService, didDetermine state: CLRegionState, for region: CLRegion)
}
extension LocationServiceDelegate {
    func locationService(_ service: LocationService, didMonitorEntering region: CLRegion) {
    }
    
    func locationService(_ service: LocationService, didMonitorExiting region: CLRegion) {
    }
    
    func locationService(_ service: LocationService, didDetermine state: CLRegionState, for region: CLRegion) {
    }
}

class LocationService: NSObject {

    static let shared = LocationService()
    var delegate: LocationServiceDelegate?
    let monitoringRegionRadius: Double = 30.0
    
    private var monitoredCoordinate: CLLocationCoordinate2D? {
        didSet {
            if let coordinate = monitoredCoordinate {
                self.createRegion(coordinate: coordinate)
            }
        }
    }
    
    var location: CLLocation? {
        get {
            return manager?.location
        }
    }
    
    private var permissionChangeCallback:((CLAuthorizationStatus)->())?

    private var manager: CLLocationManager? = CLLocationManager.init()

    private override init() {
        super.init()
    }
    
    class func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
    }
    
    func startUpdating() {
        manager?.requestAlwaysAuthorization()
        manager?.allowsBackgroundLocationUpdates = true
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.delegate = self
        manager?.distanceFilter = 10
        manager?.startMonitoringSignificantLocationChanges()
        if let region = manager?.monitoredRegions.first(where: { $0.identifier == "GymLocation" }) {
            manager?.requestState(for: region)
        }
    }

    func stopUpdating() {
        manager?.stopUpdatingLocation()
    }
    
    func startMonitoring(coordinate: CLLocationCoordinate2D) {
        self.monitoredCoordinate = coordinate
    }
    
    func requestLocation(completion: ((CLAuthorizationStatus)->())?) {
        self.permissionChangeCallback = completion
        manager?.requestAlwaysAuthorization()
        manager?.allowsBackgroundLocationUpdates = true
        manager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func authorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    private func createRegion(coordinate: CLLocationCoordinate2D) {
        
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            let regionRadius = monitoringRegionRadius
            let region = CLCircularRegion(center: CLLocationCoordinate2D(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude),
                                          radius: regionRadius,
                                          identifier: "")
            
            region.notifyOnExit = true
            region.notifyOnEntry = true
            
            //Send your fetched location to server
            
            //Stop your location manager for updating location and start regionMonitoring
            manager?.stopUpdatingLocation()
            manager?.startMonitoring(for: region)
        }
        else {
            print("System can't track regions")
        }
    }

}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered Region")
        delegate?.locationService(self, didMonitorEntering: region)
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited Region")
        delegate?.locationService(self, didMonitorExiting: region)
        self.manager?.stopMonitoring(for: region)

        //Start location manager and fetch current location
        self.manager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        switch state {
        case .inside:
            break
        case .outside, .unknown:
            if UIApplication.shared.applicationState == .active {
                //send location to server
            } else {
                //App is in BG/ Killed or suspended state
                //send location to server

                //Make region and again the same cycle continues.
                if let coordinate = monitoredCoordinate {
                    self.createRegion(coordinate: coordinate)
                }
            }
        default:
            print("state unsupported")
            break
        }
        delegate?.locationService(self, didDetermine: state, for: region)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.permissionChangeCallback?(status)
    }

}
