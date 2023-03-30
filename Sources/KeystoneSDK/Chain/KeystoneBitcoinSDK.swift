//
//  KeystoneBitcoinSDK.swift
//  
//
//  Created by LiYan on 3/30/23.
//

import Foundation
import URRegistryFFI
import URKit

public class KeystoneBitcoinSDK: KeystoneBaseSDK {
    public func parsePsbt(cborHex: String) throws -> String {
        let psbtURString = handle_error(
            get_result: { parse_crypto_psbt($0, cborHex) }
        )

        let psbt = try super.parseUR(urString: psbtURString, ofType: PSBT.self, ofError: KeystoneError.parsePSBTError)
        return psbt.psbt.uppercased()
    }

    public func generatePSBT(psbtHex: String) throws -> UREncoder {
        let psbt = handle_error(
            get_result: { generate_crypto_psbt($0, psbtHex)}
        )
        return try super.urStringToEncoder(urString: psbt, ofError: KeystoneError.generatePSBTError)
    }
}
