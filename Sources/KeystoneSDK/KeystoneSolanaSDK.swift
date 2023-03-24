//
//  KeystoneSDKSolanaSDK.swift
//  
//
//  Created by LiYan on 3/21/23.
//

import Foundation
import URRegistryFFI
import URKit


public class KeystoneSolanaSDK: KeystoneSDK {

    public enum SignType: Int32 {
        case Transaction = 1
        case Message = 2
    }

    func parseSignature(cborHex: String) throws -> Signature {
        let signResult = handle_error(
            get_result: { parse_sol_signature($0, cborHex) },
            success: { (res: Optional<UnsafePointer<CChar>>) -> String in
                let val = String(cString: res!)
                keystone_sdk_destroy_string(res!)
                return val
            }
        )

        let decoder = JSONDecoder()
        do {
            return try decoder.decode(Signature.self, from: Data(signResult.utf8))
        } catch {
            let err = try decoder.decode(Error.self, from: Data(signResult.utf8))
            throw KeystoneError.parseSignatureError(err.error)
        }
    }

    func generateSignRequest(requestId: String, signData: String, path: String, xfp: String, address: String?, origin: String?, signType: SignType) throws -> UREncoder {
        let signRequest = handle_error(
            get_result: { generate_sol_sign_request($0, requestId, signData, path, xfp, address, origin, signType.rawValue)},
            success: { (res: Optional<UnsafePointer<CChar>>) -> String in
                let val = String(cString: res!)
                keystone_sdk_destroy_string(res!)
                return val
            }
        )
        let decoder = JSONDecoder()
        do {
            let txUR = try decoder.decode(UR.self, from: Data(signRequest.utf8))
            return try encodeQR(ur: txUR)
        } catch {
            let err = try decoder.decode(Error.self, from: Data(signRequest.utf8))
            throw KeystoneError.generateSignRequestError(err.error)
        }
    }
}
