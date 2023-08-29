//
//  ObjectToDictionary.swift
//  Travelify
//
//  Created by Minh Tan Vu on 26/08/2023.
//

import Foundation

struct JSON {
    static let encoder = JSONEncoder()
}

extension Encodable {
    // Convert dữ liệu từ object thành dictionary
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    
}
