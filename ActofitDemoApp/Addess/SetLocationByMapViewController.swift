

import UIKit
import CoreData
import GooglePlaces
import GoogleMaps
import GooglePlacePicker
import CoreLocation
import Contacts
import SwiftGifOrigin
import SwiftIcons
import SVProgressHUD
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator
import SwiftyJSON
import SDWebImage
import EzPopup

var formatted_address  : String!

class SetLocationByMapViewController: UIViewController , CLLocationManagerDelegate, GMSMapViewDelegate,UITextViewDelegate {

    var locationManager : CLLocationManager!
   
 //   var locManager = CLLocationManager()

    
    @IBOutlet weak var setDeliveryLocation : UITextView!
      
        @IBOutlet weak var AddressLbl : UILabel!
       @IBOutlet weak var ConfirmBtn: UIButton!
        @IBOutlet weak var backBtn: UIButton!
      
       @IBOutlet weak var mapView : GMSMapView!
        @IBOutlet weak var AddressView : UIView!
    
    @IBOutlet weak var confirmLbl: UILabel!
    
    @IBOutlet weak var locationlbl: UILabel!
    var selectedPinocde : String!
    
    var objLocation : DeliveryLocationModelClass!
    var modelArrayDeliveryLocation = [DeliveryLocationModelClass]()
  
    @IBAction func btn_ActionConfirmLocation(_ sender: UIButton) {
           getDeliveryLocations()
         }
    
    let context = AppDelegate().persistentContainer.viewContext
    var cartArray = [MyCartData]()
    
    @IBAction func btn_ActionBack(_ sender: UIButton) {
        self.dismiss(animated: true) {
                  
              }
           self.navigationController?.popViewController(animated: true)
       }
    
    @IBOutlet weak var uiView_noNetwork: UIView!
    var ObjectOrderDetails : OrdersHistoryModelClass!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
                                        let app = UIApplication.shared
                                        let statusBarHeight: CGFloat = app.statusBarFrame.size.height
                                        
                                        let statusbarView = UIView()
                                        statusbarView.backgroundColor = CustomCommonVioletColor
                                        view.addSubview(statusbarView)
                                      
                                        statusbarView.translatesAutoresizingMaskIntoConstraints = false
                                        statusbarView.heightAnchor
                                            .constraint(equalToConstant: statusBarHeight).isActive = true
                                        statusbarView.widthAnchor
                                            .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
                                        statusbarView.topAnchor
                                            .constraint(equalTo: view.topAnchor).isActive = true
                                        statusbarView.centerXAnchor
                                            .constraint(equalTo: view.centerXAnchor).isActive = true
                                      
                                    } else {
                                        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
                                        statusBar?.backgroundColor = CustomCommonVioletColor
                                    }
             
        
            cartArray.removeAll()
              let request = NSFetchRequest<MyCartData>.init(entityName: "MyCartData")
              var  result = try! context.fetch(request)
              cartArray = result
        
        
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
//
//              let location : CLLocation = locationManager!.location!
//              var lat = location.coordinate.latitude
//              var lng = location.coordinate.longitude
//
//              getAddressFromLatLon(pdblLatitude: lat, withLongitude: lng)
            
          }
           // locationManager.requestLocation()
          //  locationManager.startUpdatingLocation()
        } else {
           // locationManager.requestWhenInUseAuthorization()
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
//
        
        uiView_noNetwork.isHidden = true
        AddressLbl.text = langKeyWordForStaticValue.SetYourLocation
        locationlbl.text = langKeyWordForStaticValue.Location
        ConfirmBtn.setTitle(langKeyWordForStaticValue.Confirm, for: .normal)
        confirmLbl.text = langKeyWordForStaticValue.caneditLocation
        
  //      showCurrentLocation()
              
        //      getDeliveryLocations()
        
        
           NotificationCenter.default.addObserver(self, selector: #selector(setlocationID(notification:)), name: .LocationIDSelectionSignUp, object: nil)
        
    }
    
    @objc func setlocationID(notification: NSNotification) {
          
          print(notification.userInfo?["object"])
        objLocation = notification.userInfo?["object"] as! DeliveryLocationModelClass
          //        self.selectCatagory = notification.userInfo["categorie"] as? String
          
        SetAddressApi()
        startTimer()
         // set address api
        
      }
      
//    @objc(locationManager:didFailWithError:)
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: NSError) {
//        print(error.localizedDescription)
//    }
//
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {

           self.locationManager.stopUpdatingLocation()
           print("ERRORS: " + error.localizedDescription )

       }
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
                                        let app = UIApplication.shared
                                        let statusBarHeight: CGFloat = app.statusBarFrame.size.height
                                        
                                        let statusbarView = UIView()
                                        statusbarView.backgroundColor = CustomCommonVioletColor
                                        view.addSubview(statusbarView)
                                      
                                        statusbarView.translatesAutoresizingMaskIntoConstraints = false
                                        statusbarView.heightAnchor
                                            .constraint(equalToConstant: statusBarHeight).isActive = true
                                        statusbarView.widthAnchor
                                            .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
                                        statusbarView.topAnchor
                                            .constraint(equalTo: view.topAnchor).isActive = true
                                        statusbarView.centerXAnchor
                                            .constraint(equalTo: view.centerXAnchor).isActive = true
                                      
                                    } else {
                                        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
                                        statusBar?.backgroundColor = CustomCommonVioletColor
                                    }
             
        
                        self.mapView?.isMyLocationEnabled = true
                       self.mapView.settings.scrollGestures = true
                       self.mapView.settings.zoomGestures = true
        
        startTimer()
      
    }
    
    
    var timerTest : Timer?
         func startTimer()
         {
             if timerTest == nil
             {
                 timerTest =  Timer.scheduledTimer(
                     timeInterval: TimeInterval(1),
                     target      : self,
                     selector    : #selector(self.timerActionTest),
                     userInfo    : nil,
                     repeats     : true)
             }
         }
         
         func stopTimerTest()
         {
             if timerTest != nil
             {
                 timerTest!.invalidate()
                 timerTest = nil
             }
         }
         
         @objc func timerActionTest()
         {
              if Connectivity.isConnectedToInternet {
                self.uiView_noNetwork.isHidden = true
              }else{
                self.uiView_noNetwork.isHidden = false
            }
         }

         override func viewWillDisappear(_ animated: Bool) {
             stopTimerTest()
         }
         override func viewDidDisappear(_ animated: Bool) {
             stopTimerTest()
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

//
//            if status == .authorizedWhenInUse || status == .authorizedAlways {
//                locationManager.startUpdatingLocation()
//                mapView.isMyLocationEnabled = true
//                mapView.settings.myLocationButton = true
//            }
//
//
//
                self.locationManager.startUpdatingLocation()
           
        } // END: locationManager delegate didChangeAuthorizationStatus

   
    
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
                
                       var postalAddr = String()
                       if pm.postalAddress != nil {
                           postalAddr = (pm.postalAddress?.street)! + "," + (pm.postalAddress?.subAdministrativeArea)! + "," + (pm.postalAddress?.subLocality)!  + "," + (pm.postalAddress?.city)! + "," + (pm.postalAddress?.state)! + "," + (pm.postalAddress?.country)!
                           
                           }
                       
                           
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
                    
                    self.setDeliveryLocation.text = addressString
                       
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
       
    func getDeliveryLocations()
           {
            modelArrayDeliveryLocation.removeAll()
            
               if Connectivity.isConnectedToInternet {
                   print("Yes! internet is available.")
                   
                   // do some tasks..
                SVProgressHUD.show()
                              SVProgressHUD.setBackgroundColor(UIColor.lightGray)
                              SVProgressHUD.setForegroundColor(UIColor.white)
                              
                   
                   
                   var langCode = 0
                   
                   let isValid = UserDefaults.standard.string(forKey: "LangCode")
                   if (isValid != nil)
                   {
                       langCode = UserDefaults.standard.value(forKey: "LangCode") as! Int
                   }else {
                       langCode = 0
                      UserDefaults.standard.set("English", forKey: "LangName")                   }
                   
                   let header : [String : String] = [
                                  
                               "x-api-key" : "WFIgqXp8Qyr0AF3wIVGglSKLN7qgw7EtPu5V7mWUbIaoSMGIUppTgaCKqaWh7Gb5Lyrf8L2A177",
                               "Content-Type" : "application/json"
                                  
                              ]
                   
                   let parameter : [String : Any] = [
                       
                       "cmid": UserDefaults.standard.value(forKey: "StoreId")!,
                       "pincode" : selectedPinocde
                      
                   
                   
                   ]
                   
                   Alamofire.request(Webservices.DeliveryLocations,  method: .post, parameters : parameter, encoding: JSONEncoding.default , headers: header)
                                   .responseJSON { response in
                                       
                                       DispatchQueue.main.async {
                                          SVProgressHUD.dismiss()
                                       }
                                       
                                       print(response)
                                      
                                       
                                       if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                           //print("Data: \(utf8Text)") // original server data as UTF8 string
                                           if let newData = utf8Text.data(using: String.Encoding.utf8){
                                               
                                               do{
                                                   let json = try JSON(data: newData)
                                                   let status = json["status"].intValue
                                                   var data = json["DeliveryLocations"]
                                                                        
                                                   
                                                   if status == 1
                                                   {
                                                  
                                                    for i in 0..<data.count
                                                    {
                                                        var str = data[i]
                                                        
                                                        var obj = DeliveryLocationModelClass(pinocde :str["pincode"].stringValue, id : str["id"].intValue, Location : str["Location"].stringValue)
                                                        
                                                        self.modelArrayDeliveryLocation += [obj]
                                                    }
                                           
                                                     SVProgressHUD.dismiss()
                                                print(self.modelArrayDeliveryLocation[0].pinocde)
                                                    
                                                    print(self.modelArrayDeliveryLocation.count)
                                                    
                                                    if self.modelArrayDeliveryLocation.count == 0
                                                    {
                                                self.ShowAlert(langKeyWordForStaticValue.appName, AlertMessage: langKeyWordForStaticValue.DeliveryServiceNotAvailable, AlertTag: 101)
                                                        
                                                    }else if self.modelArrayDeliveryLocation.count == 1
                                                    {
                                                        self.objLocation = self.modelArrayDeliveryLocation[0]
                                                        self.SetAddressApi()
                                                        // set address api
                                                    }else{
                                                        
                                                        self.popUpView()
                                                        // set address api
                                                    }
                                                   }else{
                                                       self.ShowAlert(langKeyWordForStaticValue.appName, AlertMessage: langKeyWordForStaticValue.DeliveryServiceNotAvailable, AlertTag: 101)
                                                    
                                                   }
                                       
                                                                                               
                                               }catch _ as NSError {
                                                   // error
                                                 SVProgressHUD.dismiss()
                                               }
                                           }
                                       }
                               }
                   
               }else {
                 //  self.ShowAlert(langKeyWordForStaticValue.appName, AlertMessage: langKeyWordForStaticValue.plzCheckIntenetConnection, AlertTag: 10)
               }
               
           }
           
    
    
    func SetAddressApi()
             {
            
              
                 if Connectivity.isConnectedToInternet {
                     print("Yes! internet is available.")
                     
                      SVProgressHUD.show()
                                SVProgressHUD.setBackgroundColor(UIColor.lightGray)
                                SVProgressHUD.setForegroundColor(UIColor.white)
                                
                     
                     var langCode = 0
                     
                     let isValid = UserDefaults.standard.string(forKey: "LangCode")
                     if (isValid != nil)
                     {
                         langCode = UserDefaults.standard.value(forKey: "LangCode") as! Int
                     }else {
                         langCode = 0
                        UserDefaults.standard.set("English", forKey: "LangName")                   }
                     
                     let header : [String : String] = [
                                    
                                 "x-api-key" : "WFIgqXp8Qyr0AF3wIVGglSKLN7qgw7EtPu5V7mWUbIaoSMGIUppTgaCKqaWh7Gb5Lyrf8L2A177",
                                 "Content-Type" : "application/json"
                                    
                                ]
                     
                     let parameter : [String : Any] = [
                         
                        "clientid": "\(UserDefaults.standard.value(forKey: "userid")!)",
                         "pincode" : selectedPinocde,
                         "locationid": objLocation.id,
                         "adress" : setDeliveryLocation.text!
                     
                     
                     ]
                     
                     Alamofire.request(Webservices.SetAddress,  method: .post, parameters : parameter, encoding: JSONEncoding.default , headers: header)
                                     .responseJSON { response in
                                         
                                         DispatchQueue.main.async {
                                            SVProgressHUD.dismiss()
                                         }
                                         
                                         print(response)
                                        
                                         
                                         if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                             //print("Data: \(utf8Text)") // original server data as UTF8 string
                                             if let newData = utf8Text.data(using: String.Encoding.utf8){
                                                 
                                                 do{
                                                     let json = try JSON(data: newData)
                                                     let status = json["status"].intValue
                                                   
                                                     if status == 1
                                                     {
                                                       if SelectAddressFromVC == "CartScreenVC"
                                                       {
                                                        self.ShowAlert(langKeyWordForStaticValue.appName, AlertMessage: "Are you sure, you want to place order for selected loation?", AlertTag: 1)
                                                        //self.PlaceOrder()
                                                       }else{
                                                         self.navigationController?.popViewController(animated: true)
                                                        }
                                                     }else{
                                                         self.ShowAlert(langKeyWordForStaticValue.appName, AlertMessage: langKeyWordForStaticValue.SomeThingWentWrong, AlertTag: 101)
                                                      
                                                     }
                                         
                                                                                                 
                                                 }catch _ as NSError {
                                                     // error
                                                   SVProgressHUD.dismiss()
                                                 }
                                             }
                                         }
                                 }
                     
                 }else {
                   //  self.ShowAlert(langKeyWordForStaticValue.appName, AlertMessage: langKeyWordForStaticValue.plzCheckIntenetConnection, AlertTag: 10)
                 }
                 
             }
    
    func popUpView() {

              let contentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectPincodeViewController") as! SelectPincodeViewController

        contentVC.modelArrayDeliveryLocation = self.modelArrayDeliveryLocation
              // Init popup view controller with content is your content view controller
           let popupVC = PopupViewController(contentController: contentVC, popupWidth:  UIScreen.main.bounds.width - 40, popupHeight: UIScreen.main.bounds.height - 200)

              popupVC.backgroundAlpha = 0.3
              popupVC.backgroundColor = .black
              popupVC.canTapOutsideToDismiss = true
              popupVC.cornerRadius = 10
              popupVC.shadowEnabled = true
              // show it by call present(_ , animated:) method from a current UIViewController
              self.present(popupVC, animated: true)
          }


    
    
     func CheckPincodeApi()
     {
        
         if Connectivity.isConnectedToInternet {
             print("Yes! internet is available.")
             
            SVProgressHUD.show()
                        SVProgressHUD.setBackgroundColor(UIColor.lightGray)
                        SVProgressHUD.setForegroundColor(UIColor.white)
                        
             
             
             var langCode = 0
             
             let isValid = UserDefaults.standard.string(forKey: "LangCode")
             if (isValid != nil)
             {
                 langCode = UserDefaults.standard.value(forKey: "LangCode") as! Int
             }else {
                 langCode = 0
                    UserDefaults.standard.set("English", forKey: "LangName")
             }
             
             let header : [String : String] = [
                            
                         "x-api-key" : "WFIgqXp8Qyr0AF3wIVGglSKLN7qgw7EtPu5V7mWUbIaoSMGIUppTgaCKqaWh7Gb5Lyrf8L2A177",
                         "Content-Type" : "application/json"
                            
                        ]
             
             let parameter : [String : Any] = [
                 
             
                 "cmid" : UserDefaults.standard.value(forKey: "StoreId")!,
                 "pin" : selectedPinocde
             
             
             ]
             
             Alamofire.request(Webservices.Check_Pin,  method: .post, parameters : parameter, encoding: JSONEncoding.default , headers: header)
                             .responseJSON { response in
                                 
                                 DispatchQueue.main.async {
                                    SVProgressHUD.dismiss()
                                 }
                                 
                                 print(response)
                                
                                 
                                 if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                     //print("Data: \(utf8Text)") // original server data as UTF8 string
                                     if let newData = utf8Text.data(using: String.Encoding.utf8){
                                         
                                         do{
                                             let json = try JSON(data: newData)
                                             let status = json["status"].intValue
                                            
                                                                  
                                             
                                             if status == 1
                                             {
                                            
                                                self.ShowAlert(langKeyWordForStaticValue.appName, AlertMessage: "Delivery service available", AlertTag: 101)
                                                 
                                                 
                                     
                                             }else{
                                                 self.ShowAlert(langKeyWordForStaticValue.appName, AlertMessage: langKeyWordForStaticValue.DeliveryServiceNotAvailable, AlertTag: 101)
                                             }
                                 
                                                                                         
                                         }catch _ as NSError {
                                             // error
                                         }
                                     }
                                 }
                         }
             
         }else {
          //   self.ShowAlert(langKeyWordForStaticValue.appName, AlertMessage: langKeyWordForStaticValue.plzCheckIntenetConnection, AlertTag: 10)
         }
         
     }
    
    
    
       func PlaceOrder()
         {
             
             if Connectivity.isConnectedToInternet {
                 print("Yes! internet is available.")
                           
             // do some tasks..
                            SVProgressHUD.show()
                                       SVProgressHUD.setBackgroundColor(UIColor.lightGray)
                                       SVProgressHUD.setForegroundColor(UIColor.white)
                                       
                 
                 var productInfo_model1 = [PlaceOrderProductDetailModelClass]()
                 var totalAmount : Double = 0
             for i in 0..<cartArray.count
             {
               
                 var str = cartArray[i]
                 var productInfo_model = PlaceOrderProductDetailModelClass(total: Double(Float(str.quantity)*str.price), product: Int(str.childid), qnty: Double(str.quantity), price: Double(str.price))
         
                 
                 totalAmount = totalAmount + productInfo_model.total
                 productInfo_model1 += [productInfo_model]
                 
             }
             
                
             
                let newOrder1 = PlaceOrderModelClass1.init(pincode: objLocation.pinocde, clientid: UserDefaults.standard.value(forKey: "userid")! as! Int, location: objLocation.id, address: setDeliveryLocation.text!, Paymentmode: 1, cmid:UserDefaults.standard.value(forKey: "StoreId")! as! Int, imeinumber:UserDefaults.standard.value(forKey: "UUIDString") as! String, totalamount: "\(totalAmount)", OrderDetails: productInfo_model1)
             
                 var str = [PlaceOrderModelClass1]()
                 str += [newOrder1]
                 //    UserDefaults.standard.value(forKey: "UUIDString") as! String
                 var newOrder = PlaceOrderMainModelClass.init(orderList :str)
             
             let jsonEncoder = JSONEncoder()
             let jsonData  = try! jsonEncoder.encode(newOrder)
             
             
             print(jsonData)
             
             
             let jsonString = String(data: jsonData, encoding: .utf8)
             
             
             print(jsonString!)
             
             var string = "\(jsonString!)"
             print(string)
             

             
             let url: String = Webservices.PlaceOrder
             print("\(url)")
             var request = URLRequest(url: URL(string: url)!)
             request.httpMethod = HTTPMethod.post.rawValue
             request.setValue("application/json", forHTTPHeaderField: "Content-Type")
             //request.allHTTPHeaderFields = header
             request.httpBody = jsonData //?.data(using: String.Encoding.utf8)
             //let data = (string.data(using: .utf8))! as Data
             let data = (jsonString?.data(using: .utf8))! as Data
             request.httpBody = data
             
             
             Alamofire.request(request).responseJSON { response in
                 
                 if let data = response.data, let utf8Text = String(data: data, encoding: .utf8)
                     //  var data: NSData =jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
                 {
                     print("Data: \(utf8Text)")
                    SVProgressHUD.dismiss()
                     if let newData = utf8Text.data(using: String.Encoding.utf8){
                         do{
                             
                             let json = try JSON(data: newData)
                             let thedata = json["status"]
                             var data = json["OrederNo"][0]
                             print(response)
                             
                             print(thedata)
                             
                             if(thedata.intValue == 1)
                             {
                                SelectAddressFromVC = ""
                                var childArray = [ProductModelDataInOrders]()
                                childArray.removeAll()
                                for j in 0..<data["productlis"].count
                                {
                                 var str = data["productlis"][j]
                                   
                                    var ob = ProductModelDataInOrders(productid: str["productid"].intValue, productname: str["productname"].stringValue, quantity: str["quantity"].intValue, rate: str["rate"].floatValue, totalprice: str["totalprice"].floatValue, image: str["image"].stringValue, description: str["description"].stringValue, flag: true)
                                    
                                    childArray.append(ob)
                                }
                                var obj = OrdersHistoryModelClass(orderid: data["ordrid"].intValue, location: data["location"].stringValue, date: data["date"].stringValue, orderno: data["orderno"].intValue, totalamount: data["totalamount"].floatValue, Orderstatus: data["Orderstatus"].intValue, address: data["address"].stringValue, productlis: childArray)
                                    
                                   
                                self.ObjectOrderDetails = obj
                                self.performSegue(withIdentifier: "afterOrderPlacedSuccess3", sender: self)
                             }else{
                                 self.ShowAlert(langKeyWordForStaticValue.appName, AlertMessage: langKeyWordForStaticValue.SomeThingWentWrong,AlertTag: 1001)
                                 
                             }
                         }catch _ as NSError {
                             // error
                         }
                     }   }
             }
             }else {
               //  self.ShowAlert(langKeyWordForStaticValue.appName, AlertMessage: langKeyWordForStaticValue.plzCheckIntenetConnection, AlertTag: 10)
             }
         }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "afterOrderPlacedSuccess3"
         {
             
             var obj = segue.destination as! OrderPlacedSuccessStatusViewController
             obj.ObjectOrderDetails = ObjectOrderDetails
         }
     }
       
    func ShowAlert(_ AlertTitle:String, AlertMessage:String, AlertTag:NSInteger ) {
              
              // Initialize Alert Controller
              let alertController = UIAlertController(title: AlertTitle, message: AlertMessage, preferredStyle: .alert)
              
              // Initialize Actions
              let OkAction = UIAlertAction(title: langKeyWordForStaticValue.oklbl, style: .default) { (action) -> Void in
                  
              }
            
            let ConfirmAction = UIAlertAction(title: langKeyWordForStaticValue.confirmBtn1, style: .default) { (action) -> Void in
                        if AlertTag == 1
                        {
                          self.PlaceOrder()
                      }
                    }
              
              let cancleAction = UIAlertAction(title: langKeyWordForStaticValue.cancellbl, style: .cancel) { (action) -> Void in
                  
              }
              
            
              if AlertTag == 1{
                  alertController.addAction(ConfirmAction)
                  alertController.addAction(cancleAction)
                  
              }else{
                 alertController.addAction(OkAction)
                }
              
              // Move to the UI thread
              DispatchQueue.main.async(execute: { () -> Void in
                  // Present Alert Controller
                  self.present(alertController, animated: true, completion: nil)
              })
              
          }
     
    

}
