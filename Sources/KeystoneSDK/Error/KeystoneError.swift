//
//  KeystoneError.swift
//  
//
//  Created by LiYan on 3/22/23.
//

import Foundation

public enum KeystoneError: Swift.Error, Equatable {
    case internalError
    case syncAccountsError(String)
    case parseSignatureError(String)
    case generateSignRequestError(String)
    case parsePSBTError(String)
    case generatePSBTError(String)
}

extension KeystoneError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .internalError:
                return NSLocalizedString("internalError", comment: "Keystone SDK internal Error")
            case .syncAccountsError(let reason):
                return NSLocalizedString("syncAccountsError", comment: reason)
            case .parseSignatureError(let reason):
                return NSLocalizedString("parseSignatureError", comment: reason)
            case .generateSignRequestError(let reason):
                return NSLocalizedString("generateSignRequestError", comment: reason)
            case .parsePSBTError(let reason):
                return NSLocalizedString("parsePSBTError", comment: reason)
            case .generatePSBTError(let reason):
                return NSLocalizedString("internalError", comment: reason)
        }
    }
}
