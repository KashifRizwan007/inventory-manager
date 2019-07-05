//
//  DeleteProduct.swift
//  Inventry Manager
//
//  Created by Kashif Rizwan on 7/4/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import Foundation
import Alamofire

class DeleteProduct{
    
    func delStock(stockId:Int, loginObj:login, completionHandler: @escaping (_ error: String?, _ msg:String?) -> ()){
        loginObj.login(completionHandler: { (error) in
            DispatchQueue.main.async {
                if error != ""{
                    completionHandler(error,nil)
                }else{
                    self.delStockExt(stockId: stockId,completionHandler: {(error,msg) in
                        completionHandler(error,msg)
                    })
                    
                }
            }
        }
    )}
    
    private func delStockExt(stockId:Int, completionHandler: @escaping (_ error: String?, _ data:String?) -> ()){
        AF.request(staticLinker.link.deleteProduct, method: .delete, parameters:["pid":stockId], encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","token":staticLinker.token]).responseJSON(completionHandler: {(response) in
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
