//
//  AptosSignature.swift
//  
//
//  Created by LiYan on 4/17/23.
//

import Foundation

public struct AptosSignature : Equatable, Codable {
    public var requestId: String
    public var signature: String
    public var authenticationPublicKey: String

    enum CodingKeys: String, CodingKey {
        case requestId = "request_id"
        case signature
        case authenticationPublicKey = "authentication_public_key"
    }
}
