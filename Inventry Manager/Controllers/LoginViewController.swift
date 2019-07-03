//
//  LoginViewController.swift
//  Inventry Manager
//
//  Created by Kashif Rizwan on 6/27/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var email: textFieldDesign!
    @IBOutlet weak var password: textFieldDesign!
    @IBOutlet weak var loginBtn: ButtonDesign!
    private var loginObj:login!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.isHidden = true
        loader.hidesWhenStopped = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    @IBAction func signInPress(_ sender: Any) {
        email.text = "kashif2@gmail.com"
        password.text = "123"
        loader.isHidden = false
        loader.startAnimating()
        loginBtn.isEnabled = false
        if let email = self.email.text, let password = self.password.text{
            loginObj = login(email: email, password: password)
            loginObj.login(completionHandler: { (error) in
                DispatchQueue.main.async {
                    self.loader.stopAnimating()
                    self.loginBtn.isEnabled = true
                    if error != ""{
                        let alert = UIAlertController(title: "Login Error", message: error, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        let alert = UIAlertController(title: "Login Successful", message: "", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                            self.performSegue(withIdentifier: "login", sender: self)
                        }))
                        self.present(alert, animated: true, completion: nil)
                        self.performSegue(withIdentifier: "login", sender: nil)
                    }
                }
            })
        }else{
            self.loader.stopAnimating()
            loginBtn.isEnabled = true
            let alert = UIAlertController(title: "Alert", message: "Please enter all fields", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
}
