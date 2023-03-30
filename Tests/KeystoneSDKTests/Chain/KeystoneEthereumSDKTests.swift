//
//  EthereumSDKTests.swift
//  
//
//  Created by LiYan on 3/29/23.
//

import Foundation
import XCTest
@testable import KeystoneSDK


final class KeystoneEthereumSDKTests: XCTestCase {

    func testParseSignature() {
        let ethSignatureHex = "a301d825509b1deb4d3b7d4bad9bdd2b0d7b3dcb6d025841d4f0a7bcd95bba1fbb1051885054730e3f47064288575aacc102fbbf6a9a14daa066991e360d3e3406c20c00a40973eff37c7d641e5b351ec4a99bfe86f335f71303686b657973746f6e65"

        let ethereumSdk = KeystoneEthereumSDK()
        let ethSignature = try! ethereumSdk.parseSignature(cborHex: ethSignatureHex)

        XCTAssertEqual(ethSignature.requestId, "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d")
        XCTAssertEqual(ethSignature.signature, "d4f0a7bcd95bba1fbb1051885054730e3f47064288575aacc102fbbf6a9a14daa066991e360d3e3406c20c00a40973eff37c7d641e5b351ec4a99bfe86f335f713")
    }

    func testParseSignatureError() {
        let ethSignatureHex = "a201d825509b1de"
        let ethereumSdk = KeystoneEthereumSDK()
        
        var thrownError: Swift.Error?
        XCTAssertThrowsError(try ethereumSdk.parseSignature(cborHex: ethSignatureHex)) {
             thrownError = $0
        }
        XCTAssertEqual(thrownError as? KeystoneError, .parseSignatureError("signature is invalid"))
    }


    func testGenerateSignRequest() {
        let ethSignRequest = EthSignRequest(
            requestId: "6c3633c0-02c0-4313-9cd7-e25f4f296729",
            signData: "6578616d706c652060706572736f6e616c5f7369676e60206d657373616765",
            dataType: .personalMessage,
            chainId: 1,
            path: "m/44'/60'/0'/0/0",
            xfp: "12345678",
            origin: "metamask"
        )

        let ethereumSdk = KeystoneEthereumSDK()
        let ethSignRequestEncoder = try! ethereumSdk.generateSignRequest(ethSignRequest: ethSignRequest)

        let qrCode = ethSignRequestEncoder.nextPart()

        XCTAssertEqual(qrCode, "ur:eth-sign-request/oladtpdagdjzeneortaortfxbwnstsvohegwdtiodtaohdctihkshsjnjojzihcxhnjoihjpjkjljthsjzhejkiniojthncxjnihjkjkhsioihaxaxaaadahtaaddyoeadlecsdwykcsfnykaeykaewkaewkaocybgeehfksatisjnihjyhsjnhsjkjehgadcese")
    }

    func testGenerateSignRequestError() {
        let ethSignRequest = EthSignRequest(
            requestId: "6c3633c0-02c0-4313-9cd7-e25f4f296729",
            signData: "6578616d706c652060706572736f6e616c5f7369676e60206d657373616765",
            dataType: .personalMessage,
            chainId: 1,
            path: "",
            xfp: "12345678",
            origin: "metamask"
        )

        let ethereumSdk = KeystoneEthereumSDK()

        var thrownError: Swift.Error?
        XCTAssertThrowsError(try ethereumSdk.generateSignRequest(ethSignRequest: ethSignRequest)) {
             thrownError = $0
        }
        XCTAssertEqual(thrownError as? KeystoneError, .generateSignRequestError("path is invalid"))
    }
}
