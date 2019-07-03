//
//  Login.swift
//  Inventry Manager
//
//  Created by Kashif Rizwan on 7/2/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import Foundation
import Alamofire

class login{
    var email:String
    var password:String
    init(email:String, password:String) {
        self.email = email
        self.password = password
    }
    func login(completionHandler: @escaping (_ UserData: String?) -> ()){
        AF.request(staticLinker.link.signIn, method: .post, parameters: ["email":self.email,"password":self.password], encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(response) in
            if let error = response.error{
                let err = error.localizedDescription
                completionHandler(err)
            }else{
                let temp = try! response.result.get() as! [String:Any]
                let err = temp["error"] as! String
                if err != ""{
                    completionHandler(err)
                }else{
                    let data = temp["data"] as! [String:Any]
                    var userInfo = data["user"] as! [String:Any]
                    staticLinker.currentUser.role = (userInfo["Role"] as! Bool)
                    staticLinker.currentUser.email = (userInfo["email"] as! String)
                    staticLinker.currentUser.id = (userInfo["id"] as! Int)
                    staticLinker.currentUser.name = (userInfo["name"] as! String)
                    staticLinker.currentUser.password = self.password
                    staticLinker.currentUser.token = (data["token"] as! String)
                    completionHandler("")
                }
            }
        })
    }
}
