//
//  VewStockDetailsViewController.swift
//  Inventry Manager
//
//  Created by Kashif Rizwan on 7/3/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import UIKit
import Alamofire

class VewStockDetailsViewController: UIViewController {
    
    var stock:product!
    private var loginObj = login(email: (staticLinker.currentUser?.email)!, password: (staticLinker.currentUser?.password)!)

    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var manufacturer: UITextField!
    @IBOutlet weak var descriptions: UITextView!
    @IBOutlet weak var quantity: UITextField!
    
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var date: UITextField!
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUI()
        loader.isHidden = true
        loader.hidesWhenStopped = true
        self.showDatePicker()
    }
    
    private func loadUI(){
        self.manufacturer.text = self.stock.manufacture
        self.productName.text = self.stock.name
        self.quantity.text = String(self.stock.quantity!)
        self.descriptions.text = self.stock.descriptionField
        self.amount.text = String(self.stock.amount!)
        self.date.text = self.stock.date
    }
    @IBAction func EditProduct(_ sender: Any) {
        loader.isHidden = false
        loader.startAnimating()
        self.saveBtn.isEnabled = false
        if let name = self.productName.text, let manufacturer = self.manufacturer.text, let _description = self.descriptions.text, let amount = self.amount.text, let quantity = self.quantity.text, let date = self.date.text{
            let editProductObj = editProduct(name: name, manufacture: manufacturer, description: _description, amount: Int(amount)!, quantity: Int(quantity)!, date: date, pid:self.stock.id!)
            editProductObj._editProduct(loginObj: self.loginObj, completionHandler: { (error,message)  in
                DispatchQueue.main.async {
                    self.loader.stopAnimating()
                    self.saveBtn.isEnabled = true
                    if error != ""{
                        let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        let alert = UIAlertController(title: "Successful", message: message, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }else{
            self.loader.stopAnimating()
            self.saveBtn.isEnabled = true
            let alert = UIAlertController(title: "Alert", message: "Please enter all required fields", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
extension VewStockDetailsViewController{
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
        
        date.inputAccessoryView = toolbar
        date.inputView = datePicker
        
    }
    
    @objc private func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        date.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc private func cancelDatePicker(){
        self.view.endEditing(true)
    }
}
