//
//  AddProductViewController.swift
//  Inventry Manager
//
//  Created by Kashif Rizwan on 6/27/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import UIKit

class AddProductViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var productName: textFieldDesign!
    @IBOutlet weak var manufacturer: textFieldDesign!
    @IBOutlet weak var descript: textFieldDesign!
    @IBOutlet weak var amount: textFieldDesign!
    @IBOutlet weak var quantity: textFieldDesign!
    @IBOutlet weak var txtDatePicker: textFieldDesign!
    @IBOutlet weak var addProductBtn: ButtonDesign!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    let datePicker = UIDatePicker()
    
    private var loginObj = login(email: staticLinker.currentUser.email, password: staticLinker.currentUser.password)
    private var productObj:Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.slideMenu()
        loader.isHidden = true
        loader.hidesWhenStopped = true
        self.showDatePicker()
    }
    @IBAction func AddProduct(_ sender: Any) {
        loader.isHidden = false
        loader.startAnimating()
        self.addProductBtn.isEnabled = false
        if let name = self.productName.text, let manufacturer = self.manufacturer.text, let _description = self.descript.text, let amount = self.amount.text, let quantity = self.quantity.text, let date = self.txtDatePicker.text{
            self.productObj = Product(name: name, manufacture: manufacturer, description: _description, amount: Int(amount)!, quantity: Int(quantity)!, date: date)
            self.productObj.addProduct(loginObj: self.loginObj, completionHandler: { (error,message)  in
                DispatchQueue.main.async {
                    self.loader.stopAnimating()
                    self.addProductBtn.isEnabled = true
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
            self.addProductBtn.isEnabled = true
            let alert = UIAlertController(title: "Alert", message: "Please enter all required fields", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    

}


extension AddProductViewController{
    private func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        txtDatePicker.inputAccessoryView = toolbar
        txtDatePicker.inputView = datePicker
        
    }
    
    @objc private func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        txtDatePicker.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc private func cancelDatePicker(){
        self.view.endEditing(true)
    }
    private func slideMenu(){
        if revealViewController() != nil{
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController()?.rearViewRevealWidth = 280
            
            view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        }
    }
}
