//
//  KeystoneTronSDKTests.swift
//  
//
//  Created by LiYan on 4/12/23.
//

import Foundation

import Foundation
import XCTest
import URKit
@testable import KeystoneSDK


final class KeystoneTronSDKTests: XCTestCase {
    
    func testParseSignature() {
        let tronSignatureHex = "a201d825509b1deb4d3b7d4bad9bdd2b0d7b3dcb6d02584147b1f77b3e30cfbbfa41d795dd34475865240617dd1c5a7bad526f5fd89e52cd057c80b665cc2431efab53520e2b1b92a0425033baee915df858ca1c588b0a1800"

        let tronSdk = KeystoneTronSDK()
        let ur = try! UR(type: "tron-signature", cborData: tronSignatureHex.hexadecimal)
        let tronSignature = try! tronSdk.parseSignature(ur: ur)

        XCTAssertEqual(tronSignature.requestId, "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d")
        XCTAssertEqual(tronSignature.signature, "47b1f77b3e30cfbbfa41d795dd34475865240617dd1c5a7bad526f5fd89e52cd057c80b665cc2431efab53520e2b1b92a0425033baee915df858ca1c588b0a1800")
    }
    
    func testGenerateSignRequest() {
        let tronSignRequest = TronSignRequest(
            requestId: "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
            signData: "0a0207902208e1b9de559665c6714080c49789bb2c5aae01081f12a9010a31747970652e676f6f676c65617069732e636f6d2f70726f746f636f6c2e54726967676572536d617274436f6e747261637412740a1541c79f045e4d48ad8dae00e6a6714dae1e000adfcd1215410d292c98a5eca06c2085fff993996423cf66c93b2244a9059cbb0000000000000000000000009bbce520d984c3b95ad10cb4e32a9294e6338da300000000000000000000000000000000000000000000000000000000000f424070c0b6e087bb2c90018094ebdc03",
            path: "m/44'/195'/0'/0'",
            xfp: "12121212"
        )

        let tronSdk = KeystoneTronSDK()
        let tronSignRequestEncoder = try! tronSdk.generateSignRequest(tronSignRequest: tronSignRequest)
        
        let qrCode = tronSignRequestEncoder.nextPart()

        XCTAssertEqual(qrCode, "ur:tron-sign-request/otadtpdagdndcawmgtfrkigrpmndutdnbtkgfssbjnaohkadgdkgcpiajljtjyjphsiajyfpieiejpihjkjkcpftcpghfwfpjlemgdglkkgrjleseehkhggojsehfxjkeygsfwfgksjeisghjoisjtfpfeeeghcpdwcpiyihihcpftehdydydydydydydydydydwcpiyjpjljncpftcpghgofpiskskteogtiogtkkgmesjpiskkjpgtfyjthfgeidjleoidjekkehflgugojpfdcpdwcpjzhsjyihjkjyfwjzjliajecpftkgcpishsjkiscpftcpdydydydydydydydydydydydydydydydyihehidesieihececeseneneciaenemehdydydydydydydydydydydydydydydydydydydydydydydydydydydydydydydydycpdwcpjtkpjnidihjpcpfteheseoendwcpjyinjnihjkjyhsjnjocpfteheceyemeneteyeeeedydydydykidwcpjlkoihjpjpinieihcpftjtkpjzjzdwcpjyjlcpftcpghgyfpioeygheykogeiafdfphdesjkidgrghfejlhsjlhgknjyeceheykkgoiminfgfycpdwcpjyjljeihjtcpftjtkpjzjzdwcpkohsjzkpihcpftcpehdydydydydydycpkiaxtaaddyoeadlocsdwykcssrykaeykaeykaocybgbgbgbgcsidenue")
    }
    
    func testGenerateSignRequestWithToken() {
        let tronSignRequest = TronSignRequest(
            requestId: "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
            signData: "0a0207902208e1b9de559665c6714080c49789bb2c5aae01081f12a9010a31747970652e676f6f676c65617069732e636f6d2f70726f746f636f6c2e54726967676572536d617274436f6e747261637412740a1541c79f045e4d48ad8dae00e6a6714dae1e000adfcd1215410d292c98a5eca06c2085fff993996423cf66c93b2244a9059cbb0000000000000000000000009bbce520d984c3b95ad10cb4e32a9294e6338da300000000000000000000000000000000000000000000000000000000000f424070c0b6e087bb2c90018094ebdc03",
            path: "m/44'/195'/0'/0'",
            xfp: "12121212",
            tokenInfo: TokenInfo(
                name: "TONE", symbol: "TronOne", decimals: 8
            )
        )

        let tronSdk = KeystoneTronSDK()
        let tronSignRequestEncoder = try! tronSdk.generateSignRequest(tronSignRequest: tronSignRequest)
        
        let qrCode = tronSignRequestEncoder.nextPart()

        XCTAssertEqual(qrCode, "ur:tron-sign-request/1-2/lpadaocfadrfcybsrpdpdlhdueotadtpdagdndcawmgtfrkigrpmndutdnbtkgfssbjnaohkadlkkgcpiajljtjyjphsiajyfpieiejpihjkjkcpftcpghfwfpjlemgdglkkgrjleseehkhggojsehfxjkeygsfwfgksjeisghjoisjtfpfeeeghcpdwcpiyihihcpftehdydydydydydydydydydwcpiyjpjljncpftcpghgofpiskskteogtiogtkkgmesjpiskkjpgtfyjthfgeidjleoidjekkehflgugojpfdcpdwcpjzhsjyihjkjyfwjzjliajecpftkgcpishsjkiscpftcpdydydydydydydydydydydydydydydydyihehidesieihececeseneneciaenemehdydydydydydydydydydydydydydydydydydydydydydydydydyssastyst")
    }
}
