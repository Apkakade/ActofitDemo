//
//import UIKit
//
//class listOfAddressViewController: UIViewController , UITableViewDelegate,UITableViewDataSource{
//  
//    let context = AppDelegate().persistentContainer.viewContext
//    var cartArray = [MyCartData]()
//    
//    var modelGetAddress = [GetAddressModelClass]()
//    var objLocation : GetAddressModelClass!
//  
//    @IBOutlet weak var tblView_Address: UITableView!
//    var ObjectOrderDetails : OrdersHistoryModelClass!
//  
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        
//        if #available(iOS 13.0, *) {
//                                        let app = UIApplication.shared
//                                        let statusBarHeight: CGFloat = app.statusBarFrame.size.height
//                                        
//                                        let statusbarView = UIView()
//                                        statusbarView.backgroundColor = CustomCommonVioletColor
//                                        view.addSubview(statusbarView)
//                                      
//                                        statusbarView.translatesAutoresizingMaskIntoConstraints = false
//                                        statusbarView.heightAnchor
//                                            .constraint(equalToConstant: statusBarHeight).isActive = true
//                                        statusbarView.widthAnchor
//                                            .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
//                                        statusbarView.topAnchor
//                                            .constraint(equalTo: view.topAnchor).isActive = true
//                                        statusbarView.centerXAnchor
//                                            .constraint(equalTo: view.centerXAnchor).isActive = true
//                                      
//                                    } else {
//                                        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
//                                        statusBar?.backgroundColor = CustomCommonVioletColor
//                                    }
//             
//        
//        
//        tblView_Address.tableFooterView = UIView()
//        
//        uiView_noNetwork.isHidden = true
//        
//        cartArray.removeAll()
//        let request = NSFetchRequest<MyCartData>.init(entityName: "MyCartData")
//        var  result = try! context.fetch(request)
//        cartArray = result
//        
//        
//        startTimer()
//        
//        // Do any additional setup after loading the view.
//    }
//    
//    
//    override func viewWillAppear(_ animated: Bool) {
//       
//        startTimer()
//        
//        getAddressLocation()
//    }
//    
//    
//    
//    @IBOutlet weak var lbl_back: UILabel!
//    @IBOutlet weak var lbl_UsingGps: UILabel!
//    @IBOutlet weak var lbl_currentLoc: UILabel!
//    @IBOutlet weak var lbl_SaveAddress: UILabel!
//    var timerTest : Timer?
//        func startTimer()
//        {
//            if timerTest == nil
//            {
//                timerTest =  Timer.scheduledTimer(
//                    timeInterval: TimeInterval(1),
//                    target      : self,
//                    selector    : #selector(self.timerActionTest),
//                    userInfo    : nil,
//                    repeats     : true)
//            }
//        }
//        
//        func stopTimerTest()
//        {
//            if timerTest != nil
//            {
//                timerTest!.invalidate()
//                timerTest = nil
//            }
//        }
//        
//        @objc func timerActionTest()
//        {
//             
//        }
//
//        override func viewWillDisappear(_ animated: Bool) {
//            stopTimerTest()
//        }
//        override func viewDidDisappear(_ animated: Bool) {
//            stopTimerTest()
//        }
//        
//       
//    
//    
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return modelGetAddress.count
//      }
//      
//      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListofAddressTableViewCell
//        cell.lbl_address.text = modelGetAddress[indexPath.row].adress
//        return cell
//      }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//          if UIDevice.current.userInterfaceIdiom == .pad {
//            return 70
//          }else{
//        return 50
//        }
//    }
//
//   
//    
//    func getAddressLocation()
//            {
//             modelGetAddress.removeAll()
//             
//                if Connectivity.isConnectedToInternet {
//                    print("Yes! internet is available.")
//                    
//                    // do some tasks..
////                    ANLoader.showLoading()
////                    ANLoader.pulseAnimation = true //It will animate your Loading
////                    ANLoader.activityColor = .white
////                    ANLoader.activityBackgroundColor = .darkGray
////                    ANLoader.activityTextColor = .clear
//                    //SVProgressHUD.dismiss()
//                    
//                    
//                    var langCode = 0
//                    
//                    let isValid = UserDefaults.standard.string(forKey: "LangCode")
//                    if (isValid != nil)
//                    {
//                        langCode = UserDefaults.standard.value(forKey: "LangCode") as! Int
//                    }else {
//                        langCode = 0
//                       UserDefaults.standard.set("English", forKey: "LangName")                   }
//                    
//                    let header : [String : String] = [
//                                   
//                                "x-api-key" : "WFIgqXp8Qyr0AF3wIVGglSKLN7qgw7EtPu5V7mWUbIaoSMGIUppTgaCKqaWh7Gb5Lyrf8L2A177",
//                                "Content-Type" : "application/json"
//                                   
//                               ]
//                    
//                    let parameter : [String : Any] = [
//                        
//                        "clientid": "\(UserDefaults.standard.value(forKey: "userid")!)",
//                    
//                    ]
//                    
//                    Alamofire.request(Webservices.GetAddress,  method: .post, parameters : parameter, encoding: JSONEncoding.default , headers: header)
//                                    .responseJSON { response in
//                                        
//                                        DispatchQueue.main.async {
//                                          // SVProgressHUD.dismiss()
//                                        }
//                                        
//                                        print(response)
//                                       
//                                        
//                                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                                            //print("Data: \(utf8Text)") // original server data as UTF8 string
//                                            if let newData = utf8Text.data(using: String.Encoding.utf8){
//                                                
//                                                do{
//                                                    let json = try JSON(data: newData)
//                                                    let status = json["status"].intValue
//                                                    var data = json["adresslist"]
//                                                                         
//                                                    
//                                                    if status == 1
//                                                    {
//                                                   
//                                                     for i in 0..<data.count
//                                                     {
//                                                         var str = data[i]
//                                                         
//                                                         var obj = GetAddressModelClass(pincode: str["pincode"].stringValue, adress: str["adress"].stringValue, locationid: str["locationid"].intValue, llocationname: str["llocationname"].stringValue)
//                                                      
//                                                         
//                                                         self.modelGetAddress += [obj]
//                                                     }
//                                                        SVProgressHUD.dismiss()
//                                                        self.tblView_Address.reloadData()
//                                            
//                                                      
//                                                 
//                                                    }else{
////                                                        self.ShowAlert(langKeyWordForStaticValue.appName, AlertMessage: langKeyWordForStaticValue.DeliveryServiceNotAvailable, AlertTag: 101)
//                                                      SVProgressHUD.dismiss()
//                                                        
//                                                    }
//                                        
//                                                                                                
//                                                }catch _ as NSError {
//                                                    // error
//                                                  SVProgressHUD.dismiss()
//                                                }
//                                            }
//                                        }
//                                }
//                    
//                }else {
//                  
//                }
//                
//            }
//            
//    
//    func PlaceOrder()
//      {
//          
//          if Connectivity.isConnectedToInternet {
//              print("Yes! internet is available.")
//                        
//          // do some tasks..
//                          SVProgressHUD.show()
//                                    SVProgressHUD.setBackgroundColor(UIColor.lightGray)
//                                    SVProgressHUD.setForegroundColor(UIColor.white)
//                                    
//              
//              var productInfo_model1 = [PlaceOrderProductDetailModelClass]()
//              var totalAmount : Double = 0
//          for i in 0..<cartArray.count
//          {
//            
//              var str = cartArray[i]
//              var productInfo_model = PlaceOrderProductDetailModelClass(total: Double(Float(str.quantity)*str.price), product: Int(str.childid), qnty: Double(str.quantity), price: Double(str.price))
//      
//              
//              totalAmount = totalAmount + productInfo_model.total
//              productInfo_model1 += [productInfo_model]
//              
//          }
//          
//             
//          
//            let newOrder1 = PlaceOrderModelClass1.init(pincode: objLocation.pincode, clientid: UserDefaults.standard.value(forKey: "userid")! as! Int, location: objLocation.locationid, address: objLocation.adress, Paymentmode: 1, cmid: UserDefaults.standard.value(forKey: "StoreId")! as! Int, imeinumber:UserDefaults.standard.value(forKey: "UUIDString") as! String, totalamount: "\(totalAmount)", OrderDetails: productInfo_model1)
//          
//              var str = [PlaceOrderModelClass1]()
//              str += [newOrder1]
//              //    UserDefaults.standard.value(forKey: "UUIDString") as! String
//              var newOrder = PlaceOrderMainModelClass.init(orderList :str)
//          
//          let jsonEncoder = JSONEncoder()
//          let jsonData  = try! jsonEncoder.encode(newOrder)
//          
//          
//          print(jsonData)
//          
//          
//          let jsonString = String(data: jsonData, encoding: .utf8)
//          
//          
//          print(jsonString!)
//          
//          var string = "\(jsonString!)"
//          print(string)
//          
//
//          
//          let url: String = Webservices.PlaceOrder
//          print("\(url)")
//          var request = URLRequest(url: URL(string: url)!)
//          request.httpMethod = HTTPMethod.post.rawValue
//          request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//          //request.allHTTPHeaderFields = header
//          request.httpBody = jsonData //?.data(using: String.Encoding.utf8)
//          //let data = (string.data(using: .utf8))! as Data
//          let data = (jsonString?.data(using: .utf8))! as Data
//          request.httpBody = data
//          
//          
//          Alamofire.request(request).responseJSON { response in
//              
//              if let data = response.data, let utf8Text = String(data: data, encoding: .utf8)
//                  //  var data: NSData =jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
//              {
//                  print("Data: \(utf8Text)")
//                 SVProgressHUD.dismiss()
//                  if let newData = utf8Text.data(using: String.Encoding.utf8){
//                      do{
//                          
//                          let json = try JSON(data: newData)
//                          let thedata = json["status"]
//                           var data = json["OrederNo"][0]
//                             print(response)
//                              print(thedata)
//                            if(thedata.intValue == 1)
//                            {
//                            SelectAddressFromVC = ""
//                            var childArray = [ProductModelDataInOrders]()
//                             childArray.removeAll()
//                              for j in 0..<data["productlis"].count
//                                {
//                             var str = data["productlis"][j]
//                             var ob = ProductModelDataInOrders(productid: str["productid"].intValue, productname: str["productname"].stringValue, quantity: str["quantity"].intValue, rate: str["rate"].floatValue, totalprice: str["totalprice"].floatValue , image: str["image"].stringValue, description: str["description"].stringValue, flag: true)
//                                   childArray.append(ob)
//                             }
//                                var obj = OrdersHistoryModelClass(orderid: data["ordrid"].intValue, location: data["location"].stringValue, date: data["date"].stringValue, orderno: data["orderno"].intValue, totalamount: data["totalamount"].floatValue, Orderstatus: data["Orderstatus"].intValue, address: data["address"].stringValue, productlis: childArray)
//                                                             
//                                self.ObjectOrderDetails = obj
//                            
//                             self.performSegue(withIdentifier: "afterOrderPlacedSuccess2", sender: self)
//                          }else{
//                              self.ShowAlert(langKeyWordForStaticValue.appName, AlertMessage: langKeyWordForStaticValue.DeliveryServiceNotAvailable,AlertTag: 1001)
//                              
//                          }
//                      }catch _ as NSError {
//                          // error
//                      }
//                  }   }
//          }
//          }else {
//            //  self.ShowAlert(langKeyWordForStaticValue.appName, AlertMessage: langKeyWordForStaticValue.plzCheckIntenetConnection, AlertTag: 10)
//          }
//      }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "afterOrderPlacedSuccess2"
//        {
//            
//            var obj = segue.destination as! OrderPlacedSuccessStatusViewController
//            obj.ObjectOrderDetails = ObjectOrderDetails
//        }
//    }
//      
//      
//      func ShowAlert(_ AlertTitle:String, AlertMessage:String, AlertTag:NSInteger ) {
//          
//          // Initialize Alert Controller
//          let alertController = UIAlertController(title: AlertTitle, message: AlertMessage, preferredStyle: .alert)
//          
//          // Initialize Actions
//          let OkAction = UIAlertAction(title: langKeyWordForStaticValue.oklbl, style: .default) { (action) -> Void in
//              
//          }
//        
//        let ConfirmAction = UIAlertAction(title: langKeyWordForStaticValue.confirmBtn1, style: .default) { (action) -> Void in
//                    if AlertTag == 1
//                    {
//                      self.PlaceOrder()
//                  }
//                }
//          
//          let cancleAction = UIAlertAction(title: langKeyWordForStaticValue.cancellbl, style: .cancel) { (action) -> Void in
//              
//          }
//          
//        
//          if AlertTag == 1{
//              alertController.addAction(ConfirmAction)
//              alertController.addAction(cancleAction)
//              
//          }else{
//             alertController.addAction(OkAction)
//            }
//          
//          // Move to the UI thread
//          DispatchQueue.main.async(execute: { () -> Void in
//              // Present Alert Controller
//              self.present(alertController, animated: true, completion: nil)
//          })
//          
//      }
//    
//    
//}
