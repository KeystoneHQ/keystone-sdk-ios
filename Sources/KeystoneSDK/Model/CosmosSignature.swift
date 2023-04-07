//
//  CosmosSignature.swift
//  
//
//  Created by Renfeng Shi on 2023/4/6.
//

import Foundation

public struct CosmosSignature : Equatable, Codable {
    public var requestId: String
    public var signature: String
    public var publicKey: String
    
    enum CodingKeys: String, CodingKey {
        case requestId = "request_id"
        case signature
        case publicKey = "public_key"
    }
}
