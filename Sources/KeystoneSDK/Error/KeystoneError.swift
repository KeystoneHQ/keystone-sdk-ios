//
//  KeystoneError.swift
//  
//
//  Created by LiYan on 3/22/23.
//

import Foundation

public enum KeystoneError: Swift.Error, Equatable {
    case internalError
    case parseSignatureError(String)
    case generateSignRequestError(String)
    case syncAccountsError(String)
}

extension KeystoneError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .parseSignatureError(let reason):
                return NSLocalizedString("parseSignatureError", comment: reason)
            case .generateSignRequestError(let reason):
                return NSLocalizedString("generateSignRequestError", comment: reason)
            case .syncAccountsError(let reason):
                return NSLocalizedString("syncAccountsError", comment: reason)
            case .internalError:
                return NSLocalizedString("internalError", comment: "Keystone SDK internal Error")
        }
    }
}
