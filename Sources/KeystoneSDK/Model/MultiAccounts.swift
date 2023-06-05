//
//  Solana.swift
//  
//
//  Created by LiYan on 3/27/23.
//

import Foundation

public struct MultiAccounts : Equatable, Codable {
    public var masterFingerprint: String
    public var device: String?
    public var keys: Array<Account>
}
