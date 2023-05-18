//
//  SuiSignRequest.swift
//  
//
//  Created by Renfeng Shi on 2023/5/18.
//

import Foundation

public struct SuiSignRequest {
    let requestId: String
    let signData: String
    let signType: SignType
    let accounts: [Account]
    var origin: String

    public enum SignType: Int32 {
        case single = 1
        case multi = 2
        case message = 3
    }

    public struct Account: Encodable {
        let path: String
        let xfp: String
        let address: String

        public init(path: String, xfp: String, address: String = "") {
            self.path = path
            self.xfp = xfp
            self.address = address
        }
    }

    public init(requestId: String, signData: String, signType: SignType, accounts: [Account], origin: String = "") {
        self.requestId = requestId
        self.signData = signData
        self.signType = signType
        self.accounts = accounts
        self.origin = origin
    }
}
