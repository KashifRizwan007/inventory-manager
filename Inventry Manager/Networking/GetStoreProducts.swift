//
//  GetStoreProducts.swift
//  Inventry Manager
//
//  Created by Kashif Rizwan on 7/8/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import Foundation

class getStoreProducts{
    let productsGetObj = GetProduct()
    let storesGetObj = viewStore()
    let loginObj = login(email: staticLinker.currentUser.email!, password: staticLinker.currentUser.password!)
    
    func getAllStoresData( completionHandler: @escaping (_ error: String?, _ data:[storesDataObject]?) -> ()){
        self.storesGetObj.getStores(loginObj: self.loginObj, completionHandler: { (error,_data)  in
            DispatchQueue.main.async {
                if let err = error{
                    completionHandler(err,nil)
                }else{
                    if _data!.isEmpty{
                        completionHandler(nil,[storesDataObject(storeName: "No stores found", storeId: -1)])
                    }else{
                        let storeDict = self.prepareStoreData(data: _data!)
                        completionHandler(nil,storeDict)
                    }
                }
            }
        })
    }
    func getAllProductsData( completionHandler: @escaping (_ error: String?, _ data:[productsDataObject]?) -> ()){
        self.productsGetObj.getStock(loginObj: self.loginObj, completionHandler: { (error,_data)  in
            DispatchQueue.main.async {
                if let err = error{
                    completionHandler(err,nil)
                }else{
                    if _data!.isEmpty{
                        completionHandler(nil,[productsDataObject(productName: "No products found", productId: -1)])
                    }else{
                        let productsDict = self.prepareProductData(data: _data!)
                        completionHandler(nil,productsDict)
                    }
                }
            }
        })
    }
    private func prepareProductData(data: [[String:Any]]) -> [productsDataObject] {
        var temp:product
        var productData = [productsDataObject]()
        for i in data{
            let jsonData = try! JSONSerialization.data(withJSONObject: i, options: JSONSerialization.WritingOptions.prettyPrinted)
            let decoder = JSONDecoder()
            do
            {
                temp = try decoder.decode(product.self, from: jsonData)
                productData.append(productsDataObject(productName: temp.name!, productId: temp.id!))
            }
            catch{
                print(error.localizedDescription)
            }
        }
        return productData
    }
    private func prepareStoreData(data: [[String:Any]]) -> [storesDataObject] {
        var temp:store
        var storeData = [storesDataObject]()
        for i in data{
            let jsonData = try! JSONSerialization.data(withJSONObject: i, options: JSONSerialization.WritingOptions.prettyPrinted)
            let decoder = JSONDecoder()
            do
            {
                temp = try decoder.decode(store.self, from: jsonData)
                storeData.append(storesDataObject(storeName: temp.storeName!, storeId: temp.id!))
            }
            catch{
                print(error.localizedDescription)
            }
        }
        return storeData
    }
    
}
