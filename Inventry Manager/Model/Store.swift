//
//  Store.swift
//  Inventry Manager
//
//  Created by Kashif Rizwan on 7/5/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import Foundation

struct store : Codable {
    
    let id : Int?
    let location : String?
    let storeName : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case location = "location"
        case storeName = "storeName"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        storeName = try values.decodeIfPresent(String.self, forKey: .storeName)
    }
    
}
