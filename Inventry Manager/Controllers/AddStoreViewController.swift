//
//  AddStoreViewController.swift
//  Inventry Manager
//
//  Created by Kashif Rizwan on 6/27/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import UIKit

class AddStoreViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var addStoreBtn: ButtonDesign!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var locationField: textFieldDesign!
    @IBOutlet weak var nameField: textFieldDesign!
    private var loginObj = login(email: (staticLinker.currentUser?.email)!, password: (staticLinker.currentUser?.password)!)
    
    private var storeObj:StoreAdd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slideMenu()
        loader.isHidden = true
        loader.hidesWhenStopped = true
    }
    private func slideMenu(){
        if revealViewController() != nil{
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController()?.rearViewRevealWidth = 280
            view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        }
    }
    @IBAction func addStore(_ sender: Any) {
        loader.isHidden = false
        loader.startAnimating()
        addStoreBtn.isEnabled = false
        if let name = self.nameField.text, let location = self.locationField.text{
            self.storeObj = StoreAdd(storeName: name, storeLocation: location)
            
            
            self.storeObj.addStore(loginObj: self.loginObj, completionHandler: { (error,message)  in
                DispatchQueue.main.async {
                    self.loader.stopAnimating()
                    self.addStoreBtn.isEnabled = true
                    if error != ""{
                        let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        let alert = UIAlertController(title: "Successful", message: message, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }else{
            self.loader.stopAnimating()
            self.addStoreBtn.isEnabled = true
            let alert = UIAlertController(title: "Alert", message: "Please enter all required fields", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
