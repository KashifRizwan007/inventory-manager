//
//  ViewStoreViewController.swift
//  Inventry Manager
//
//  Created by Kashif Rizwan on 6/27/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import UIKit
import Alamofire

class ViewStoreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    private var loginObj = login(email: staticLinker.currentUser.email, password: staticLinker.currentUser.password)
    var refreshControl = UIRefreshControl()
    var data = [[String:Any]]()
    private var msg = "Loading..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.slideMenu()
        self._loadData()
        tableView.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(_loadData), for: .valueChanged)
    }
    
    @objc private func _loadData(){
        self.getStores(loginObj: loginObj, completionHandler: { (error,_data)  in
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                if let err = error{
                    self.msg = err
                    self.data.removeAll()
                    self.tableView.reloadData()
                }else{
                    if _data!.isEmpty{
                        self.msg = "No products found"
                        self.data.removeAll()
                        self.tableView.reloadData()
                    }else{
                        self.data = _data!
                        self.tableView.reloadData()
                    }
                }
            }
        })
    }
    
}
extension ViewStoreViewController{
    
    private func getStores(loginObj:login, completionHandler: @escaping (_ error: String?, _ data:[[String:Any]]?) -> ()){
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
        AF.request(staticLinker.link.getStores, method: .get, parameters:nil, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","token":staticLinker.currentUser.token]).responseJSON(completionHandler: {(response) in
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 94
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storeCell") as! StoreTableViewCell
        cell.storeName.text = (data[indexPath.row]["location"] as! String)
        cell.StoreLocation.text = (data[indexPath.row]["storeName"] as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSection: NSInteger = 0
        
        if data.count > 0 {
            self.tableView.tableFooterView = nil
            numOfSection = 1
        } else {
            
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
            noDataLabel.text = msg
            noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.center
            self.tableView.tableFooterView = noDataLabel
            
        }
        return numOfSection
    }
    
    private func slideMenu(){
        if revealViewController() != nil{
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController()?.rearViewRevealWidth = 280
            
            view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        }
    }
}
