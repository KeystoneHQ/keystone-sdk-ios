//
//  KeystoneSDK.swift
//
//
//  Created by LiYan on 21/3/2023.
//

import Foundation
import URRegistryFFI
import URKit

func handle_error<T>(
    get_result: (UnsafeMutablePointer<ExternError>) -> T,
    success: (T) -> String
) -> String {
    var err = ExternError()
    let err_ptr: UnsafeMutablePointer<ExternError> = UnsafeMutablePointer(&err)
    let res = get_result(err_ptr)
    if err_ptr.pointee.code == 0 {
        return success(res)
    } else {
        let val = String(cString: err_ptr.pointee.message)
        keystone_sdk_destroy_string(err_ptr.pointee.message)
        return val
    }
}


//@objc(KeystoneSDK)
public class KeystoneSDK {
    
    public init(){}
    
    func encodeQR(ur: UR) throws -> UREncoder {
        do {
            let encodeUR = try URKit.UR(type: ur.type, untaggedCBOR: ur.cbor)
            return UREncoder(encodeUR, maxFragmentLen: 100)
        } catch {
            throw KeystoneError.generateSignRequestError("Transaction is not valid")
        }
    }
}
