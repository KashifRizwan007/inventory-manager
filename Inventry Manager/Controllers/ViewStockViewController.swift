//
//  ViewStockViewController.swift
//  Inventry Manager
//
//  Created by Kashif Rizwan on 6/27/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import UIKit
import Alamofire

class ViewStockViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    private var loginObj = login(email: staticLinker.currentUser.email, password: staticLinker.currentUser.password)
    var refreshControl = UIRefreshControl()
    var data = [[String:Any]]()
    private var msg = "Loading..."
    var productData = [String:Any]()
    
    var boxView = UIView()
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.slideMenu()
        self.loadData()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 108
        tableView.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
    }
    @objc private func loadData(){
        self.getStock(loginObj: loginObj, completionHandler: { (error,_data)  in
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

extension ViewStockViewController{
    
    private func getStock(loginObj:login, completionHandler: @escaping (_ error: String?, _ data:[[String:Any]]?) -> ()){
        loginObj.login(completionHandler: { (error) in
            DispatchQueue.main.async {
                if error != ""{
                    completionHandler(error,nil)
                }else{
                    self.getStockExt(completionHandler: {(error,data) in
                        completionHandler(error,data)
                    })
                    
                }
            }
        }
        )}
    
    private func getStockExt(completionHandler: @escaping (_ error: String?, _ data:[[String:Any]]?) -> ()){
        AF.request(staticLinker.link.getProducts, method: .get, parameters:nil, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","token":staticLinker.currentUser.token]).responseJSON(completionHandler: {(response) in
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        productData = data[indexPath.row]
        self.performSegue(withIdentifier: "productDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productDetail"{
            let viewStockDetail = segue.destination as? VewStockDetailsViewController
            viewStockDetail?.stock = self.productData
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell") as! ViewStockTableViewCell
        cell.name.text = (data[indexPath.row]["name"] as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle:  UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete \((self.data[indexPath.row]["name"] as! String))?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
                print("fnewfniaeufbiesbfkjsefwe")
                self.deleteStock(stockId: self.data[indexPath.row]["id"] as! Int, index: indexPath.row)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion:nil)
        }
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
    private func deleteStock(stockId:Int, index:Int){
        let delStock = DeleteProduct()
        
        addSavingPhotoView()
        
        delStock.delStock(stockId: stockId, loginObj: loginObj, completionHandler: { (error,msg)  in
            DispatchQueue.main.async {
                if let err = error{
                    let alert = UIAlertController(title: "Alert", message: err, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    self.boxView.removeFromSuperview()
                    self.data.remove(at: index)
                    if self.data.count == 0{
                        self.msg = "No products found"
                    }
                    self.tableView.reloadData()
                    let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    func addSavingPhotoView() {
        // You only need to adjust this frame to move it anywhere you want
        boxView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 180, height: 50))
        boxView.backgroundColor = UIColor.white
        boxView.alpha = 0.8
        boxView.layer.cornerRadius = 10
        
        //Here the spinnier is initialized
        let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.startAnimating()
        
        let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = UIColor.gray
        textLabel.text = "Deleting..."
        
        boxView.addSubview(activityView)
        boxView.addSubview(textLabel)
        
        view.addSubview(boxView)
    }
}
