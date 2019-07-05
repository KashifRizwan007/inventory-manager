//
//  editProduct.swift
//  Inventry Manager
//
//  Created by Kashif Rizwan on 7/4/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import Foundation
import Alamofire

class editProduct{
    var name:String
    var manufacture:String
    var description:String
    var amount:Int
    var quantity:Int
    var date:String
    var pid:Int
    init(name:String, manufacture:String, description:String, amount:Int, quantity:Int, date:String, pid:Int) {
        self.name = name
        self.manufacture = manufacture
        self.description = description
        self.amount = amount
        self.quantity = quantity
        self.date = date
        self.pid = pid
    }
    func _editProduct(loginObj: login, completionHandler: @escaping (_ error: String?, _ message:String?) -> ()){
        loginObj.login(completionHandler: { (error) in
            DispatchQueue.main.async {
                if error != ""{
                    completionHandler(error,nil)
                }else{
                    self.editProductExt(productName : self.name, manufacturer: self.manufacture, description: self.description, amount: Int(self.amount), quantity: Int(self.quantity), date: self.date, _pid: self.pid, completionHandler: {(error,message) in
                        completionHandler(error,message)
                    })
                }
            }
        }
        )}
    
    private func editProductExt(productName:String, manufacturer:String, description:String, amount:Int, quantity:Int, date:String, _pid:Int, completionHandler: @escaping (_ error: String?, _ message:String?) -> ()){
        AF.request(staticLinker.link.editProducts, method: .post,
                   parameters: ["name":name,"manufacture":manufacturer,"description":description,"amount":amount,"quantity":quantity,"date":date,"pid":_pid],
                   encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","token":staticLinker.currentUser.token]).responseJSON(completionHandler: {(response) in
                    if let error = response.error{
                        let err = error.localizedDescription
                        completionHandler(err,nil)
                    }else{
                        let temp = try! response.result.get() as! [String:Any]
                        if let error = temp["error"]{
                            let err = error as! String
                            print(err)
                            completionHandler(err,nil)
                        }else{
                            let msg = temp["message"] as! String
                            completionHandler(nil,msg)
                        }
                    }
                })
    }
    
}

