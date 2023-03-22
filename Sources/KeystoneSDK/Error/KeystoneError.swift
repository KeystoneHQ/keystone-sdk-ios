//
//  KeystoneError.swift
//  
//
//  Created by LiYan on 3/22/23.
//

import Foundation

enum KeystoneError: Error {
    case parseSignatureError(String)
    case generateSignRequestError(String)
}
