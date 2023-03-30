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
    public lazy var sol: KeystoneSolanaSDK = {
        return KeystoneSolanaSDK()
    }()
    public lazy var eth: KeystoneEthereumSDK = {
        return KeystoneEthereumSDK()
    }()
    public lazy var btc: KeystoneBitcoinSDK = {
        return KeystoneBitcoinSDK()
    }()
    private let wallet: KeystoneWallet = KeystoneWallet()
    private var urDecoder: URDecoder = URDecoder()

    public static var maxFragment = 100;

    public init(){}

    public func decodeQR(qrCode: String) throws -> UR? {
        let isReceiveSucceed = urDecoder.receivePart(qrCode)
        switch urDecoder.result {
            case .success(let ur):
                let cborHex = ur.cborData.hexEncodedString()
                return UR(type: ur.type, cbor: cborHex)
            case .failure:
                resetQRDecoder()
                throw QRCodeError.invalidQRCode
            case nil:
                if isReceiveSucceed {
                    return nil
                } else {
                    resetQRDecoder()
                    throw QRCodeError.unexpectedQRCode
                }
        }
    }

    public func resetQRDecoder(){
        urDecoder = URDecoder()
    }

    // Sync Keystone hardware wallet
    public func parseMultiAccounts(cborHex: String) throws -> MultiAccounts {
        return try wallet.parseMultiAccounts(cborHex: cborHex)
    }
}
