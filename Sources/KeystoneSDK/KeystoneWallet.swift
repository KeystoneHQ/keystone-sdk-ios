//
//  KeystoneWallet.swift
//  
//
//  Created by LiYan on 3/27/23.
//

import Foundation
import URRegistryFFI

public class KeystoneWallet: KeystoneSDK {

    func parseMultiAccounts(cborHex: String) throws -> MultiAccounts {
        let signResult = handle_error(
            get_result: { parse_crypto_multi_accounts($0, cborHex) },
            success: { (res: Optional<UnsafePointer<CChar>>) -> String in
                let val = String(cString: res!)
                keystone_sdk_destroy_string(res!)
                return val
            }
        )

        let decoder = JSONDecoder()
        do {
            return try decoder.decode(MultiAccounts.self, from: Data(signResult.utf8))
        } catch {
            let err = try decoder.decode(Error.self, from: Data(signResult.utf8))
            throw KeystoneError.parseMultiAccountsError
        }
    }
}
