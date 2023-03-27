//
//  EthereumSDK.swift
//  
//
//  Created by LiYan on 3/27/23.
//

import Foundation
import URRegistryFFI
import URKit


public class EthereumSDK: KeystoneSDK {

    public enum DataType: Int32 {
        case Transaction = 1
        case Message = 2
    }

    func parseSignature(cborHex: String) throws -> Signature {
        let signResult = handle_error(
            get_result: { parse_eth_signature($0, cborHex) },
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

    func generateSignRequest(requestId: String, signData: String, dataType: DataType, chainId: Int32, path: String, xfp: String, address: String?, origin: String?) throws -> UREncoder {
        let signRequest = handle_error(
            get_result: { generate_eth_sign_request($0, requestId, signData, dataType.rawValue, chainId, path, xfp, address, origin)},
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
