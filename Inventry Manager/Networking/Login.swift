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
    var User:user?
    
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
                    
                    var userData = data["user"] as! [String:Any]
                    userData["password"] = self.password
                    staticLinker.token = (data["token"] as! String)
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
