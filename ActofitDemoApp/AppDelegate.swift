//
//  AppDelegate.swift
//  ActofitDemoApp
//
//  Created by Apple on 18/03/22.
//

import UIKit
import GooglePlaces
import GoogleMaps
import CoreLocation

var latitude: Double = 0.0
var longitude: Double = 0.0
var locationAddress : String!

@main
class AppDelegate: UIResponder, UIApplicationDelegate ,CLLocationManagerDelegate {
    var window: UIWindow?
    var locationManager = CLLocationManager()
    var backgroundUpdateTask: UIBackgroundTaskIdentifier!
    var bgtimer = Timer()
    var current_time = NSDate().timeIntervalSince1970
    var timer = Timer()
    var f = 0
   
   

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        GMSServices.provideAPIKey("") // enter your key here for map
        GMSPlacesClient.provideAPIKey("")
        
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        BackgroundLocationManager.instance.start()
        
        return true
    }
    
                                              
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("Entering foreBackground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Entering Background")
       
    }

    func doBackgroundTask() {

        DispatchQueue.main.async {
            self.beginBackgroundUpdateTask()
            self.StartupdateLocation()
            self.bgtimer = Timer.scheduledTimer(timeInterval:300, target: self, selector: #selector(AppDelegate.bgtimer(_:)), userInfo: nil, repeats: true)
            RunLoop.current.add(self.bgtimer, forMode: RunLoop.Mode.default)
            RunLoop.current.run()
            self.endBackgroundUpdateTask()
        }
    }

    func beginBackgroundUpdateTask() {
        self.backgroundUpdateTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            self.endBackgroundUpdateTask()
        })
    }

    func endBackgroundUpdateTask() {
        UIApplication.shared.endBackgroundTask(self.backgroundUpdateTask)
        self.backgroundUpdateTask = UIBackgroundTaskIdentifier.invalid
    }

    func StartupdateLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while requesting new coordinates")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        latitude = locValue.latitude
        longitude = locValue.longitude
        f+=1
        print("New Coordinates: \(f) ")
        print(latitude)
        print(longitude)
        let fileName = "Location.txt"
        self.readData()
    }

    @objc func bgtimer(_ timer:Timer!){
        sleep(300)
        self.updateLocation()
    }

    func updateLocation() {
        self.locationManager.startUpdatingLocation()
        self.locationManager.stopUpdatingLocation()
    }

    func readData()
    {
        do {
            let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("Location.txt")
            
            guard let outputStream = OutputStream(url: fileURL, append: true) else {
                print("Unable to open file")
                return
            }
            outputStream.open()
            let text = "Address - latitute : \(latitude) , longitute : \(longitude)\n"
            try outputStream.write(text)
            outputStream.close()
        } catch {
            print(error)
        }
    }

    
}

extension OutputStream {
    enum OutputStreamError: Error {
        case stringConversionFailure
        case bufferFailure
        case writeFailure
    }

    func write(_ string: String, encoding: String.Encoding = .utf8, allowLossyConversion: Bool = false) throws {
        guard let data = string.data(using: encoding, allowLossyConversion: allowLossyConversion) else {
            throw OutputStreamError.stringConversionFailure
        }
        try write(data)
    }


    func write(_ data: Data) throws {
        try data.withUnsafeBytes { (buffer: UnsafeRawBufferPointer) throws in
            guard var pointer = buffer.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                throw OutputStreamError.bufferFailure
            }

            var bytesRemaining = buffer.count

            while bytesRemaining > 0 {
                let bytesWritten = write(pointer, maxLength: bytesRemaining)
                if bytesWritten < 0 {
                    throw OutputStreamError.writeFailure
                }

                bytesRemaining -= bytesWritten
                pointer += bytesWritten
            }
        }
    }
}


