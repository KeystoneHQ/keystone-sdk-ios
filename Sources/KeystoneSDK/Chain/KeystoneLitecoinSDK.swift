//
//  KeystoneLitcoinSDK.swift
//  
//
//  Created by LiYan on 4/21/23.
//

import Foundation
import URRegistryFFI
import URKit

public class KeystoneLitcoinSDK: KeystoneCommonSDK {
    public func generateSignRequest(keystoneSignRequest: KeystoneSignRequest<LitecoinTransaction>) throws -> UREncoder {
        return try super.genSignRequest(coinType: .ltc, keystoneSignRequest: keystoneSignRequest)
    }
}
