//
//  viewStore.swift
//  Inventry Manager
//
//  Created by Kashif Rizwan on 7/5/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import Foundation
import  Alamofire

class viewStore{
    
    func getStores(loginObj:login, completionHandler: @escaping (_ error: String?, _ data:[[String:Any]]?) -> ()){
        loginObj.login(completionHandler: { (error) in
            DispatchQueue.main.async {
                if error != ""{
                    completionHandler(error,nil)
                }else{
                    self.getStoresExt(completionHandler: {(error,data) in
                        completionHandler(error,data)
                    })
                }
            }
        }
    )}
    
    private func getStoresExt(completionHandler: @escaping (_ error: String?, _ data:[[String:Any]]?) -> ()){
        AF.request(staticLinker.link.getStores, method: .get, parameters:nil, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","token":staticLinker.token]).responseJSON(completionHandler: {(response) in
            if let error = response.error{
                let err = error.localizedDescription
                completionHandler(err,nil)
            }else{
                let temp = try! response.result.get() as! [String:Any]
                let error = temp["error"] as! String
                if error != ""{
                    completionHandler(error,nil)
                }else{
                    let dta = temp["data"] as! [[String:Any]]
                    completionHandler(nil,dta)
                }
            }
        })
    }
    
}
