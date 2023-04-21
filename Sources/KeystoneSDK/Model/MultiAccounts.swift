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
}

public struct Account : Equatable, Codable {
    public var chain: String
    public var path: String
    public var publicKey: String
    public var name: String
    public var chainCode: String
    public var extendedPublicKey: String
}
