//
//  ItemsRequest.swift
//  Digid
//
//  Created by Artem Kutasevych on 17.10.2023.
//

import Foundation

struct ItemsRequest: DataRequest {
    var sinceId: String?
    var maxId: String?

    var url: String {
        let baseURL: String = "https://marlove.net/e/mock/v1"
        let path: String = "/items"
        return baseURL + path
    }
    
    var queryItems: [String: String] {
        var query: [String: String] = [:]
        
        if sinceId != nil {
            query["since_id"] = sinceId
        }
        
        if maxId != nil {
            query["max_id"] = maxId
        }
        
        return query
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: [String : String] {
        ["Authorization": "0581e02b1306de12907e61c51c4ee430"]
    }
    
    func decode(_ data: Data) throws -> [Item] {
        let decoder = JSONDecoder()
        let response = try decoder.decode([Item].self, from: data)
        return response
    }
}
