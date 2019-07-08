//
//  addSales.swift
//  Inventry Manager
//
//  Created by Kashif Rizwan on 7/8/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import Foundation
import Alamofire

class addInventorySales{
    var salesDetailData:[String:Any]
    
    init(pid:Int, sid:Int, salesDate:String, quantity:Int, stockSold:Int) {
        self.salesDetailData = ["pid":pid,"sid":sid,"saleDate":salesDate,"quantity":quantity,"stockSold":stockSold]
    }
    
    func addSales(loginObj: login, completionHandler: @escaping (_ error: String?, _ message:String?) -> ()){
        loginObj.login(completionHandler: { (error) in
            DispatchQueue.main.async {
                if error != ""{
                    completionHandler(error,nil)
                }else{
                    self.addSalesExt( completionHandler: {(error,message) in
                        completionHandler(error,message)
                    })
                }
            }
        }
    )}
    
    private func addSalesExt( completionHandler: @escaping (_ error: String?, _ message:String?) -> ()){
        AF.request(staticLinker.link.addSales, method: .post,
                   parameters: self.salesDetailData,
                   encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","token":staticLinker.token]).responseJSON(completionHandler: {(response) in
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
