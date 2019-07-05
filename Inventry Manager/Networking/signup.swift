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
    var User:user?
    
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
                    staticLinker.token = (data["token"] as! String)
                    var userData = data["user"] as! [String:Any]
                    userData["password"] = self.password
                    let jsonData = try! JSONSerialization.data(withJSONObject: userData, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let decoder = JSONDecoder()
                    do
                    {
                        self.User = try decoder.decode(user.self, from: jsonData)
                        staticLinker.currentUser = self.User
                    }
                    catch
                    {
                        completionHandler(error.localizedDescription)
                    }
                    completionHandler("")
                }
            }
        })
    }
}
