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
    
    
    func parseSignature(cbor_hex: String) -> Signature? {
        let sign_result = handle_error(
            get_result: { parse_sol_signature($0, cbor_hex) },
            success: { (res: Optional<UnsafePointer<CChar>>) -> String in
                let val = String(cString: res!)
                keystone_sdk_destroy_string(res!)
                return val
            }
        )

        let decoder = JSONDecoder()
        return try? decoder.decode(Signature.self, from: Data(sign_result.utf8))
        //        do {
        //            return try decoder.decode(Signature.self, from: Data(sign_result.utf8))
        //        } catch {
        //            throw KeystoneError.parseSignatureError("Signature is invalid")
        //        }
    }

    func generateSignRequest(request_id: String, sign_data: String, path: String, xfp: String, address: String?, origin: String?, sign_type: SignType) throws -> UREncoder {
        let sign_request = handle_error(
            get_result: { generate_sol_sign_request($0, request_id, sign_data, path, xfp, address, origin, sign_type.rawValue)},
            success: { (res: Optional<UnsafePointer<CChar>>) -> String in
                let val = String(cString: res!)
                keystone_sdk_destroy_string(res!)
                return val
            }
        )
        let decoder = JSONDecoder()
        do {
            let tx_ur = try decoder.decode(UR.self, from: Data(sign_request.utf8))
            return try encodeQR(ur: tx_ur)
        } catch {
            throw KeystoneError.generateSignRequestError("someeeeee error")
        }
    }
}
