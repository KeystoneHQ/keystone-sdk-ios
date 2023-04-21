//
//  KeystoneCommon.swift
//  
//
//  Created by LiYan on 4/21/23.
//

import Foundation

public struct Output: Codable {
    let address: String
    let value: Int32
    let isChange: Bool
    let changeAddressPath: String

    public init(address: String, value: Int32, isChange: Bool, changeAddressPath: String) {
        self.address = address
        self.value = value
        self.isChange = isChange
        self.changeAddressPath = changeAddressPath
    }
}

public struct TransactionSignResult: Codable {
    let requestId: String
    let rawData: String

    public init(requestId: String, rawData: String) {
        self.requestId = requestId
        self.rawData = rawData
    }
}
