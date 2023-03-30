//
//  KeystoneWallet.swift
//  
//
//  Created by LiYan on 3/27/23.
//

import Foundation
import URRegistryFFI

public class KeystoneWallet: KeystoneBaseSDK {
    func parseMultiAccounts(cborHex: String) throws -> MultiAccounts {
        let multiAccounts = handle_error(
            get_result: { parse_crypto_multi_accounts($0, cborHex) }
        )
        return try super.parseUR(urString: multiAccounts, ofType: MultiAccounts.self, ofError: KeystoneError.syncAccountsError)
    }
}
