//
//  Signature.swift
//  
//
//  Created by LiYan on 3/21/23.
//

import Foundation

public struct Signature : Equatable, Codable {
    public var requestId: String
    public var signature: String
    
    enum CodingKeys: String, CodingKey {
        case requestId = "request_id"
        case signature
    }
}
