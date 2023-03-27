//
//  KeystoneSDK.swift
//
//
//  Created by LiYan on 21/3/2023.
//

import Foundation
import URRegistryFFI
import URKit

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}


public class KeystoneSDK {
    public lazy var sol: SolanaSDK = {
        return SolanaSDK()
    }()
    public lazy var eth: EthereumSDK = {
        return EthereumSDK()
    }()
    private let wallet: KeystoneWallet
    private var urDecoder: URDecoder

    public static var maxFragment = 100;

    public init(){
        wallet = KeystoneWallet()
        urDecoder = URDecoder()
    }

    public func decodeQR(qrCode: String) throws -> UR? {
        let _ = urDecoder.receivePart(qrCode)
        if urDecoder.result != nil {
            switch urDecoder.result! {
                case .success(let ur):
                    let cborHex = ur.cborData.hexEncodedString()
                    urDecoder = URDecoder()
                    return UR(type: ur.type, cbor: cborHex)
                case .failure(let error):
                    urDecoder = URDecoder()
                    throw KeystoneError.parseQRError(error.localizedDescription)
            }
        }
        return nil
    }

    public func resetQRDecoder(){
        urDecoder = URDecoder()
    }

    // Sync Keystone hardware wallet
    public func parseMultiAccounts(cborHex: String) throws -> MultiAccounts {
        return try wallet.parseMultiAccounts(cborHex: cborHex)
    }
}
