//
//  AddSalesDetailViewController.swift
//  Inventry Manager
//
//  Created by Kashif Rizwan on 6/27/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import UIKit

class AddSalesDetailViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var storeTxt: textFieldDesign!
    @IBOutlet weak var productTxt: textFieldDesign!
    @IBOutlet weak var salesDateTxt: textFieldDesign!
    @IBOutlet weak var quantityTxt: textFieldDesign!
    @IBOutlet weak var unitPriceTxt: textFieldDesign!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    let datePicker = UIDatePicker()
    var productPickerData:[String] = ["dfasf","fwsf","fwef"]
    var storePickerData:[String] = ["24","423"]
    var currentTextField = UITextField()
    var pickerView = UIPickerView()
    
    private var loginObj = login(email: staticLinker.currentUser.email!, password: staticLinker.currentUser.password!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.isHidden = true
        loader.hidesWhenStopped = true
        self.slideMenu()
        self.showDatePicker()
    }
    
}

extension AddSalesDetailViewController{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentTextField == storeTxt{
            return self.storePickerData.count
        }else if currentTextField == productTxt{
            return self.productPickerData.count
        }else{
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentTextField == storeTxt{
            return self.storePickerData[row]
        }else if currentTextField == productTxt{
            return self.productPickerData[row]
        }else{
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentTextField == storeTxt{
            self.currentTextField.text = self.storePickerData[row]
        }else if currentTextField == productTxt{
            self.currentTextField.text = self.productPickerData[row]
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.pickerView.reloadAllComponents()
        
        self.currentTextField = textField
        
        self.currentTextField.inputView = pickerView
    }
    
    private func showDatePicker(){
        //Formate Date
        self.datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: true)
        
        salesDateTxt.inputAccessoryView = toolbar
        salesDateTxt.inputView = datePicker
        
    }
    
    @objc private func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        salesDateTxt.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc private func cancelPicker(){
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
