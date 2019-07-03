//
//  signup.swift
//  Inventry Manager
//
//  Created by Kashif Rizwan on 7/2/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import Foundation
import Alamofire

class signup{
    var email:String
    var name:String
    var password:String
    var role:Bool
    init(email:String, name:String, password:String, role:Bool) {
        self.email = email
        self.name = name
        self.password = password
        self.role = role
    }
    func signUp(completionHandler: @escaping (_ UserData: String?) -> ()){
        AF.request(staticLinker.link.signUp, method: .post, parameters: ["email":self.email, "name":self.name, "password":self.password, "role":self.role], encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(response) in
            if let error = response.error{
                let err = error.localizedDescription
                completionHandler(err)
            }else{
                let temp = try! response.result.get() as! [String:Any]
                let err =  temp["error"] as! String
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
