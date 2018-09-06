//
//  LoginViewController.swift
//  eCash
//
//  Created by Terence Williams on 8/7/18.
//  Copyright © 2018 Terence Williams. All rights reserved.
//

import UIKit

extension String {
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

struct eCashUser {
    var userToken: String = ""
    var userName: String = ""
    
    init(token: String, username: String) {
        userName = username
        userToken = token
    }
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var usernameInput: String = ""
    var passwordInput: String = ""
    var loggedSuccessful: Bool = false
    
    var token: String = ""
    var loginStatus: Int = 0

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccount: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        username.delegate = self
        password.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (username.isFirstResponder) {
            username.resignFirstResponder()
        }
        if (password.isFirstResponder){
            password.resignFirstResponder()
        }
        return true
    }
    
    func hasInput(textfield: UITextField) -> Bool{
        if textfield.text == "" {
            return false
        } else{
            return true
        }
    }

    @IBAction func submitLogin(){
        if(hasInput(textfield: username) && hasInput(textfield: password)){
            usernameInput = username.text!
            passwordInput = password.text!
            loading.isHidden = false
            getData()
        }
        else{
            failedLogin()
        }
        
    }
    
    func encodeBase64(username:String, password:String) -> String{
        let logon = username + ":" + password
        let base64 = logon.toBase64()
        return base64
    }
    
    func getData() {
        let endpoint: String = "https://daily.ecashsoftware.com/api/api/Authenticate/GetAuthenticate"
        guard let url = URL(string: endpoint) else {
            return
        }
        
        //Encode Username and Password For Key
        let encoded = encodeBase64(username: "admin", password: "CartNath58")
        let authenticate = String.init(format: "Basic %@", encoded)
        print(authenticate)
        
        //Begin Making API Call
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(authenticate, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
      
        let task = session.dataTask(with: urlRequest) { (data, response, error) -> Void in
            
            print("\n•••••Data: ", data)
            print("\n••••Response: ", response)
            
            do {
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("User: ", json)
                }
            }catch {
                print("Error deserializing JSON: \(error)")
                self.failedLogin()
            }
            
            
            
            if let http = response as? HTTPURLResponse {
                print("http: ", http)
                if (http.allHeaderFields["Token"] == nil){
                 
                }
                else{
                    self.token = http.allHeaderFields["Token"] as! String
                    print("Token: ", self.token)
                    self.login(token: self.token)
                    
                }
            }
            
            guard error == nil else {
                print("Error calling GET")
                self.failedLogin()
                return
            }
            
        }
        task.resume()
    }
    
    func login(token: String){
        
        let endpoint: String = "https://daily.ecashsoftware.com/api/api/MobileApi/Login"
        guard let url = URL(string: endpoint) else {
            return
        }
        
        //Set HHTP Body
        let json:[String: String] = ["UserName": usernameInput, "Password": passwordInput]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        //Begin Making API Call
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(self.token, forHTTPHeaderField: "Token")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData
        urlRequest.httpMethod = "POST"

        
        let session = URLSession.shared
        
        let task1 = session.dataTask(with: urlRequest) { (data, response, error) -> Void in
            
            print("Data: ", data)
            print("Response: ", response)
            
            guard error == nil else {
                print("Error calling POST")
                return
            }
            
            do {
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print(json)
                    self.loginStatus = json["LoginSuccess"] as! Int
                    print(self.loginStatus)
                    //BOOM!!!! Check login status here!
                    if(self.loginStatus == 0){
                        self.failedLogin()
                        //self.loggedSuccessful = false
                    }
                    else {
                        self.completeLogin()
                        UserDefaults.standard.set(self.token, forKey: "token")
                        //self.loggedSuccessful = true
                    }
                }
            }catch {
                print("Error deserializing JSON: \(error)")
                self.failedLogin()
            }
            
        }
        task1.resume()
    }
    
    
    func failedLogin(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Login Failed", message: "Invalid  username or password", preferredStyle: UIAlertControllerStyle.alert)
            self.present(alert, animated: true, completion: nil)
            //Delay dismissal
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.loading.isHidden = true
                alert.dismiss(animated: true, completion: nil)
            })
            
            self.password.text = ""
        }
    }
    
    func completeLogin(){
        DispatchQueue.main.async {
            UserDefaults.standard.setValue(self.usernameInput, forKey: "username")
            self.performSegue(withIdentifier: "login", sender: self)
        }

    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
