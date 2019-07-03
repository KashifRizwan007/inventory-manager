//
//  SignInViewController.swift
//  Inventry Manager
//
//  Created by Kashif Rizwan on 6/28/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    let pickerViewData=["True","False"]
    var role:Bool = true
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var email: textFieldDesign!
    @IBOutlet weak var password: textFieldDesign!
    @IBOutlet weak var signInBtn: ButtonDesign!
    @IBOutlet weak var name: textFieldDesign!
    private var signUpObj:signup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.isHidden = true
        loader.hidesWhenStopped = true
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        loader.isHidden = false
        loader.startAnimating()
        signInBtn.isEnabled = false
        if let email = self.email.text, let password = self.password.text, let name = self.name.text{
            signUpObj = signup(email: email, name: name, password: password, role: role)
            signUpObj.signUp(completionHandler: { (error) in
                DispatchQueue.main.async {
                    self.loader.stopAnimating()
                    self.signInBtn.isEnabled = true
                    if error != ""{
                        let alert = UIAlertController(title: "Sign-Up Error", message: error, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        let alert = UIAlertController(title: "Sign-Up Successful", message: "", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                            self.performSegue(withIdentifier: "signin", sender: self)
                        }))
                        self.present(alert, animated: true, completion: nil)
                        self.performSegue(withIdentifier: "signup", sender: nil)
                    }
                }
            })
        }else{
            self.loader.stopAnimating()
            self.signInBtn.isEnabled = true
            if email.text == "" || name.text == "" || password.text == ""{
                let alert = UIAlertController(title: "Alert", message: "Please enter all required fields", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
///////////////////////////////////////////////////////////////////////////////////////////
extension SignUpViewController{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerViewData[row] == "True"{
            role = true
        }else{
            role = false
        }
        return
    }
}
