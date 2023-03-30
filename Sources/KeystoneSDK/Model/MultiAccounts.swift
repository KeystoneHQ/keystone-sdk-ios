//
//  Solana.swift
//  
//
//  Created by LiYan on 3/27/23.
//

import Foundation

public struct MultiAccounts : Equatable, Codable {
    public var masterFingerprint: String
    public var device: String
    public var keys: Array<Account>
    
    enum CodingKeys: String, CodingKey {
        case masterFingerprint = "master_fingerprint"
        case device
        case keys
    }
}

public struct Account : Equatable, Codable {
    public var chain: String
    public var path: String
    public var publicKey: String
    public var name: String
    public var chainCode: String
    public var extendedPublicKey: String

    enum CodingKeys: String, CodingKey {
        case chain
        case path
        case name
        case publicKey = "public_key"
        case chainCode = "chain_code"
        case extendedPublicKey = "extended_public_key"
    }
}
