//
//  File.swift
//  Inventry Manager
//
//  Created by Kashif Rizwan on 7/8/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import Foundation

struct salesData : Codable {
    
    let productName : String?
    let sale : sales?
    let storeLocation : String?
    let storeName : String?
    
    enum CodingKeys: String, CodingKey {
        case productName = "productName"
        case sale = "sale"
        case storeLocation = "storeLocation"
        case storeName = "storeName"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        productName = try values.decodeIfPresent(String.self, forKey: .productName)
        sale = try sales(from: decoder)
        storeLocation = try values.decodeIfPresent(String.self, forKey: .storeLocation)
        storeName = try values.decodeIfPresent(String.self, forKey: .storeName)
    }
}
