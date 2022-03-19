//
//  Location.swift
//  ActofitDemoApp
//
//  Created by Apple on 19/03/22.
//

import Foundation
import CoreLocation
import UIKit

class BackgroundLocationManager :NSObject, CLLocationManagerDelegate {

    static let instance = BackgroundLocationManager()
    static let BACKGROUND_TIMER = 300.0 // restart location manager every 150 seconds
    static let UPDATE_SERVER_INTERVAL = 60 * 60

    let locationManager = CLLocationManager()
    var timer:Timer?
    var currentBgTaskId : UIBackgroundTaskIdentifier?
    var lastLocationDate : Date = Date()

    private override init(){
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.activityType = .other;
        locationManager.distanceFilter = kCLDistanceFilterNone;
     
            locationManager.allowsBackgroundLocationUpdates = true
        

        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    @objc func applicationEnterBackground(){
      
        start()
    }

    func start(){
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
           // if #available(iOS 9, *){
             //   locationManager.requestLocation()
            //} else {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.requestAlwaysAuthorization()
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
                
            //}
        } else {
                locationManager.requestAlwaysAuthorization()
        }
    }
    @objc func restart (){
        timer?.invalidate()
        timer = nil
        start()
    }

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case CLAuthorizationStatus.restricted: break
            //log("Restricted Access to location")
        case CLAuthorizationStatus.denied: break
            //log("User denied access to location")
        case CLAuthorizationStatus.notDetermined: break
            //log("Status not determined")
        default:
            //log("startUpdatintLocation")
           
                locationManager.startUpdatingLocation()
          
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
   
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate

        latitude = locValue.latitude
        longitude = locValue.longitude
        
        if(timer==nil){
            // The locations array is sorted in chronologically ascending order, so the
            // last element is the most recent
            guard let location = locations.last else {return}

            beginNewBackgroundTask()
            locationManager.stopUpdatingLocation()
            let now = Date()
            if(isItTime(now: now)){
                //TODO: Every n minutes do whatever you want with the new location. Like for example sendLocationToServer(location, now:now)
                readData()
            }
        }
    }
    
    func readData()
    {
        do {
            let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("LocationNew.txt")
            
            guard let outputStream = OutputStream(url: fileURL, append: true) else {
                print("Unable to open file")
                return
            }

            outputStream.open()
            let text = "Address - latitute : \(latitude) , longitute : \(longitude)\n"
            print(text)
            try outputStream.write(text)
            outputStream.close()
        } catch {
            print(error)
        }
    }

    

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
       
        beginNewBackgroundTask()
        locationManager.stopUpdatingLocation()
    }

    func isItTime(now:Date) -> Bool {
        let timePast = now.timeIntervalSince(lastLocationDate)
        let intervalExceeded = Int(timePast) > BackgroundLocationManager.UPDATE_SERVER_INTERVAL
        return intervalExceeded;
    }

    func sendLocationToServer(location:CLLocation, now:Date){
        //TODO
    }

    func beginNewBackgroundTask(){
        var previousTaskId = currentBgTaskId;
        currentBgTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            
        })
        if let taskId = previousTaskId{
            UIApplication.shared.endBackgroundTask(taskId)
            previousTaskId = UIBackgroundTaskIdentifier.invalid
        }

        timer = Timer.scheduledTimer(timeInterval: BackgroundLocationManager.BACKGROUND_TIMER, target: self, selector: #selector(self.restart),userInfo: nil, repeats: false)
    }
}
