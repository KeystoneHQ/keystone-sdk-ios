//
//  ZcashAccounts.swift
//  KeystoneSDK
//
//  Created by Sora Li on 2024/11/27.
//

import Foundation

public struct ZcashAccounts : Equatable, Codable {
    public var seedFingerprint: String
    public var keys: Array<ZcashUnifiedAccount>
}

public struct ZcashUnifiedAccount: Equatable, Codable {
    public var transparent: ZcashTransparentAccount?
    public var orchard: ZcashShieldedAccount
    public var name: String?
}

public struct ZcashTransparentAccount: Equatable, Codable {
    public var path: String
    public var xpub: String
}

public struct ZcashShieldedAccount: Equatable, Codable {
    public var path: String
    public var fvk: String
}
