

import UIKit
import GooglePlaces
import GoogleMaps
import CoreLocation
import SwiftGifOrigin



var formatted_address  : String!

class SetLocationByMapViewController: UIViewController , CLLocationManagerDelegate, GMSMapViewDelegate,UITextViewDelegate {

    var locationManager : CLLocationManager!
    @IBOutlet weak var setDeliveryLocation : UITextView!
    @IBOutlet weak var mapView : GMSMapView!
    var selectedPinocde : String!


    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

            //locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        if CLLocationManager.locationServicesEnabled() {
          switch (CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
              print("No access")
            
            case .authorizedAlways, .authorizedWhenInUse:
              print("Access")

          }
         
        } else {
           
            print("Location services are not enabled")
        }
        
        
     
             var currentLoc: CLLocation!
             if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
             CLLocationManager.authorizationStatus() == .authorizedAlways) {
                currentLoc = locationManager.location
                if currentLoc != nil
                {
                print(currentLoc.coordinate.latitude)
                print(currentLoc.coordinate.longitude)
                 getAddressFromLatLon(pdblLatitude: currentLoc.coordinate.latitude, withLongitude: currentLoc.coordinate.longitude)
                }else{
                   getAddressFromLatLon(pdblLatitude: 10.8505, withLongitude: 76.2711)
                }
  
             }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {

           self.locationManager.stopUpdatingLocation()
           print("ERRORS: " + error.localizedDescription )

       }
    
    override func viewWillAppear(_ animated: Bool) {
       
                        self.mapView?.isMyLocationEnabled = true
                       self.mapView.settings.scrollGestures = true
                       self.mapView.settings.zoomGestures = true
        
      
      
    }
    
    
   
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

            let location = locations.first
            let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
            self.locationManager.stopUpdatingLocation()
            print ("ta da")
            var latitude = center.latitude
            var longitude = center.longitude

          getAddressFromLatLon(pdblLatitude: latitude, withLongitude: longitude)
        } // END: locationManager delegate didUpdateLocations
    
    
    

        func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
                self.locationManager.startUpdatingLocation()
           
        }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D)
          {
              
              print("Tapped at coordinate: " + String(coordinate.latitude) + " "
                  + String(coordinate.longitude))
              
             // getAddressForLatLng(latitude: String(coordinate.latitude), longitude: String(coordinate.longitude))
             getAddressFromLatLon(pdblLatitude: Double(coordinate.latitude), withLongitude: Double(coordinate.longitude))
          }
        
    
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double) {
           var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
           let lat: Double = pdblLatitude
           //21.228124
           let lon: Double = pdblLongitude
           //72.833770
           let ceo: CLGeocoder = CLGeocoder()
           center.latitude = lat
           center.longitude = lon
           
           let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
           
           ceo.reverseGeocodeLocation(loc, completionHandler:
               {(placemarks, error) in
                   if (error != nil)
                   {
                       print("reverse geodcode fail: \(error!.localizedDescription)")
                   }
                   let pm = placemarks! as [CLPlacemark]
               
                   if pm.count > 0 {
                       let pm = placemarks![0]
                       print(pm.country)
                
                       print(pm.locality)
                       print(pm.subLocality)
                       print(pm.thoroughfare)
                       print(pm.postalCode)
                       print(pm.subThoroughfare)
                       var addressString : String = ""
                       if pm.name != nil{
                         addressString = addressString + pm.name! + ", "
                       }
                       if pm.subLocality != nil {
                           addressString = addressString + pm.subLocality! + ", "
                       }
                       if pm.thoroughfare != nil {
                           addressString = addressString + pm.thoroughfare! + ", "
                       }
                       if pm.locality != nil {
                           addressString = addressString + pm.locality! + ", "
                       }
                       if pm.country != nil {
                           addressString = addressString + pm.country! + ", "
                       }
                       if pm.postalCode != nil {
                           addressString = addressString + pm.postalCode! + " "
                        self.selectedPinocde = pm.postalCode
                       }
                       if pm.administrativeArea != nil {
                           addressString = addressString + pm.administrativeArea! + ", "
                       }
                      
                       var postalAddr = String()

                       let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 12.0)
                       
                       self.mapView?.animate(to: camera)
                 
                       
                       
                      // self.AddressLbl.text = addressString
                       
                       print(addressString)
                       print(postalAddr)
                    
                       self.view.addSubview(self.mapView)
                       self.mapView?.isMyLocationEnabled = true
                    self.mapView.settings.scrollGestures = true
                    self.mapView.settings.zoomGestures = true
                    
                       self.mapView.clear()
                       
                       let marker = GMSMarker()
                       marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                  
                       let uiimageview = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
                       let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 40, height: 40))
                       let imgeview1 = UIImageView(frame: CGRect(x: 0 , y: 20, width: 50, height: 50))
                       
                       let image = self.imageWithImage(image: UIImage(named :"pin_markar.png")! , scaledToSize: CGSize(width:40, height: 40))
                     
                      let Gif = UIImage.gif(name: "ripple_gif")
                   
                     imageView.image = image
                       imgeview1.image = Gif
                       
                           uiimageview.addSubview(imageView)
                           uiimageview.addSubview(imgeview1)
                       
                       marker.iconView = uiimageview
                       marker.title = addressString
                       marker.snippet = pm.country
                       marker.map = self.mapView
                    
                    self.setDeliveryLocation.text = "\(addressString) latitute : \(lat) , Longitute : \(lon)"
                       
                   }
           })
           
       }
    
    
       func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
           UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
           image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
           
           let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
           UIGraphicsEndImageContext()
           return newImage
       }
  
    

}
