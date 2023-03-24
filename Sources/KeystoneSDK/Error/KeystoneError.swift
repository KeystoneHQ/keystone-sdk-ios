//
//  KeystoneError.swift
//  
//
//  Created by LiYan on 3/22/23.
//

import Foundation

enum KeystoneError: Swift.Error, Equatable {
    case parseSignatureError(String)
    case generateSignRequestError(String)
}
