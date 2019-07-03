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
    
    var stock = [String:Any]()
    private var loginObj = login(email: staticLinker.currentUser.email, password: staticLinker.currentUser.password)

    @IBOutlet weak var manufacturer: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var descriptions: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUI()
        loader.isHidden = true
        loader.hidesWhenStopped = true
    }
    
    private func loadUI(){
        self.manufacturer.text = (self.stock["manufacture"] as! String)
        self.productName.text = (self.stock["name"] as! String)
        self.quantity.text = String(self.stock["quantity"] as! Int)
        self.descriptions.text = (self.stock["description"] as! String)
        self.amount.text = String(self.stock["amount"] as! Int)
        self.date.text = (self.stock["date"] as! String)
    }

    @IBAction func deleteStock(_ sender: Any) {
        self.loader.isHidden = false
        self.loader.startAnimating()
        self.deleteBtn.isEnabled = false
        self.delStock(loginObj: loginObj, completionHandler: { (error,msg)  in
            DispatchQueue.main.async {
                self.loader.stopAnimating()
                self.deleteBtn.isEnabled = true
                if let err = error{
                    let alert = UIAlertController(title: "Alert", message: err, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
}
extension VewStockDetailsViewController{
    
    private func delStock(loginObj:login, completionHandler: @escaping (_ error: String?, _ msg:String?) -> ()){
        loginObj.login(completionHandler: { (error) in
            DispatchQueue.main.async {
                if error != ""{
                    completionHandler(error,nil)
                }else{
                    self.delStockExt(completionHandler: {(error,msg) in
                        completionHandler(error,msg)
                    })
                    
                }
            }
        }
    )}
    
    private func delStockExt(completionHandler: @escaping (_ error: String?, _ data:String?) -> ()){
        AF.request(staticLinker.link.deleteProduct, method: .delete, parameters:["pid":self.stock["id"] as! Int], encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","token":staticLinker.currentUser.token]).responseJSON(completionHandler: {(response) in
            if let error = response.error{
                let err = error.localizedDescription
                completionHandler(err,nil)
            }else{
                let temp = try! response.result.get() as! [String:Any]
                let error = temp["error"] as! String
                if error != ""{
                    completionHandler(error,nil)
                }else{
                    let msg = temp["message"] as! String
                    completionHandler(nil,msg)
                }
            }
        })
    }
}
