//
//  addStore.swift
//  Inventry Manager
//
//  Created by Kashif Rizwan on 7/2/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import Foundation
import Alamofire

class StoreAdd{
    var storeName:String
    var storeLocation:String
    
    init(storeName:String, storeLocation:String) {
        self.storeName = storeName
        self.storeLocation = storeLocation
    }
    
    func addStore(loginObj:login, completionHandler: @escaping (_ error: String?, _ message:String?) -> ()){
        loginObj.login(completionHandler: { (error) in
            DispatchQueue.main.async {
                if error != ""{
                    completionHandler(error,nil)
                }else{
                    self.addStoreExt(completionHandler: {(error,message) in
                        completionHandler(error,message)
                    })
                }
            }
        }
    )}
    
    private func addStoreExt(completionHandler: @escaping (_ error: String?, _ message:String?) -> ()){
        AF.request(staticLinker.link.addStores, method: .post, parameters: ["storeName":self.storeName,"location":self.storeLocation], encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","token":staticLinker.token]).responseJSON(completionHandler: {(response) in
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
