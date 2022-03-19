//
//  ViewController.swift
//  ActofitDemoApp
//
//  Created by Apple on 18/03/22.
//

import Security
import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var txt_mobile: UITextField!
    @IBOutlet weak var txt_Name: UITextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.endEditing(true)
        if let receivedData = KeyChain.load(key: "Credential") {
            let result = receivedData.to(type: String.self)
            print("result: ", result)
            if result != nil{
            let credential =  result.components(separatedBy: ",")
            txt_Name.text = credential[0]
            txt_mobile.text = credential[1]
            }
        }
        setDoneOnKeyboard()
        // Do any additional setup after loading the view.
    }

    @IBAction func btn_login(_ sender: UIButton) {
        let phoneString = txt_mobile.text!
        let phoneNumber : Bool = phoneString.isPhoneNumber
        if phoneNumber == true
        {
            var credential : String = "\(txt_Name.text!),\(txt_mobile.text!)"
            let data = Data(from: credential)
            let status = KeyChain.save(key: "Credential", data: data)
          //  self.ShowAlert("Actofit", AlertMessage: "Login successful!", AlertTag: 101)
            self.performSegue(withIdentifier: "LoginSegue", sender: self)
        }else{
            self.ShowAlert("Actofit", AlertMessage: "Please enter valid mobile number.", AlertTag: 10)
        }
        
    }

    func ShowAlert(_ AlertTitle:String, AlertMessage:String, AlertTag:NSInteger ) {
               
               // Initialize Alert Controller
               let alertController = UIAlertController(title: AlertTitle, message: AlertMessage, preferredStyle: .alert)
               
               // Initialize Actions
               let OkAction = UIAlertAction(title: "Ok", style: .default) { (action) -> Void in
                   if AlertTag == 101
                   {
                       
                   }
               }
               
               alertController.addAction(OkAction)
               
               DispatchQueue.main.async(execute: { () -> Void in
                   // Present Alert Controller
                   self.present(alertController, animated: true, completion: nil)
               })
               
           }
    
    func setDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.txt_mobile.inputAccessoryView = keyboardToolbar
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

