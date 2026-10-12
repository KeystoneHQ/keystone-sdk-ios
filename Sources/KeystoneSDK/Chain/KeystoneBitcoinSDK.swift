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
    private struct PSBTExtendPayload: Codable {
        let psbt: String
        let coinId: Int32?
    }

    public func parsePSBTExtend(ur: UR) throws -> PSBTExtend {
        let result = handle_error(
            get_result: { parse_crypto_psbt_extend($0, ur.type, ur.cbor.cborData.hexEncodedString()) }
        )
        let payload = try super.parseUR(urString: result, ofType: PSBTExtendPayload.self, ofError: KeystoneError.parsePSBTError)
        return PSBTExtend(psbt: payload.psbt.hexadecimal, coinId: payload.coinId)
    }

    /// coinId: 0 = Bitcoin (omitted), 2 = LTC, 3 = DOGE, 4 = DASH, 145 = BCH.
    public func generatePSBTExtend(psbt: Data, coinId: Int32 = 0) throws -> UREncoder {
        let result = handle_error(
            get_result: { generate_crypto_psbt_extend($0, psbt.hexEncodedString(), coinId) }
        )
        return try super.urStringToEncoder(urString: result, ofError: KeystoneError.generatePSBTError)
    }

    public func parsePSBT(ur: UR) throws -> Data {
        let psbtURString = handle_error(
            get_result: { parse_crypto_psbt($0, ur.type, ur.cbor.cborData.hexEncodedString()) }
        )

        let psbt = try super.parseUR(urString: psbtURString, ofType: PSBT.self, ofError: KeystoneError.parsePSBTError)
        return psbt.psbt.uppercased().hexadecimal
    }

    public func generatePSBT(psbt: Data) throws -> UREncoder {
        let psbt = handle_error(
            get_result: { generate_crypto_psbt($0, psbt.hexEncodedString())}
        )
        return try super.urStringToEncoder(urString: psbt, ofError: KeystoneError.generatePSBTError)
    }
}
