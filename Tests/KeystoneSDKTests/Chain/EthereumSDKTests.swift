//
//  EthereumSDKTests.swift
//  
//
//  Created by LiYan on 3/29/23.
//

import Foundation
import XCTest
@testable import KeystoneSDK


final class EthereumSDKTests: XCTestCase {

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
            requestId: "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
            signData: "f849808609184e72a00082271094000000000000000000000000000000000000000080a47f7465737432000000000000000000000000000000000000000000000000000000600057808080",
            dataType: .message,
            chainId: 1,
            path: "m/44'/1'/1'/0/1",
            xfp: "12345678",
            origin: "metamask"
        )

        let ethereumSdk = KeystoneEthereumSDK()
        let ethSignRequestEncoder = try! ethereumSdk.generateSignRequest(ethSignRequest: ethSignRequest)

        let qrCode = ethSignRequestEncoder.nextPart()

        XCTAssertEqual(qrCode, "ur:eth-sign-request/1-3/lpadaxcfadbzcypdvljorohdhlkkadbghsendyehieeteyececdyesidehieihideeieeoidemieeeidhsieesidieieeyiddyieemideoieiaideniedyeyeceteeidiyeteeesetdyetendyeseheteeihemeyhsdydydyeteyeyemehdyeseedydydydydydydydydydydydydydytltlfnjt")
    }

    func testGenerateSignRequestError() {
        let ethSignRequest = EthSignRequest(
            requestId: "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
            signData: "f849808609184e72a00082271094000000000000000000000000000000000000000080a47f7465737432000000000000000000000000000000000000000000000000000000600057808080",
            dataType: .message,
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
