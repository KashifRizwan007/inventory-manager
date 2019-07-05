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
    var deletingProductData:[String:Any]

    init(name:String, manufacture:String, description:String, amount:Int, quantity:Int, date:String, pid:Int) { self.deletingProductData = ["name":name,"manufacture":manufacture,"description":description,"amount":amount,"quantity":quantity,"date":date,"pid":pid]
    }
    
    func _editProduct(loginObj: login, completionHandler: @escaping (_ error: String?, _ message:String?) -> ()){
        loginObj.login(completionHandler: { (error) in
            DispatchQueue.main.async {
                if error != ""{
                    completionHandler(error,nil)
                }else{
                    self.editProductExt( completionHandler: {(error,message) in
                        completionHandler(error,message)
                    })
                }
            }
        }
    )}
    
    private func editProductExt( completionHandler: @escaping (_ error: String?, _ message:String?) -> ()){
        AF.request(staticLinker.link.editProducts, method: .post, parameters: self.deletingProductData, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","token":staticLinker.token]).responseJSON(completionHandler: {(response) in
            if let error = response.error{
                let err = error.localizedDescription
                completionHandler(err,nil)
            }else{
                let temp = try! response.result.get() as! [String:Any]
                if let error = temp["error"]{
                    let err = error as! String
                    completionHandler(err,nil)
                }else{
                    let msg = temp["message"] as! String
                    completionHandler(nil,msg)
                }
            }
        })
    }
    
}

