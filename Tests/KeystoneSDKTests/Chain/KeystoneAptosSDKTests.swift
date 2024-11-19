//
//  KeystoneAptosSDKTests.swift
//  
//
//  Created by LiYan on 4/17/23.
//

import Foundation
import XCTest
import URKit
@testable import KeystoneSDK

final class KeystoneAptosSDKTests: XCTestCase {

    func testParseSignature() {
        let signatureHex = "a301d825509b1deb4d3b7d4bad9bdd2b0d7b3dcb6d02584047e7b510784406dfa14d9fd13c3834128b49c56ddfc28edb02c5047219779adeed12017e2f9f116e83762e86f805c7311ea88fb403ff21900e069142b1fb310e0358208e53e7b10656816de70824e3016fc1a277e77825e12825dc4f239f418ab2e04e"

        let sdk = KeystoneAptosSDK()
        let ur = try! UR(type: "aptos-signature", cbor: CBOR(signatureHex.hexadecimal))
        let signature = try! sdk.parseSignature(ur: ur)

        XCTAssertEqual(signature.requestId, "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d")
        XCTAssertEqual(signature.signature, "47e7b510784406dfa14d9fd13c3834128b49c56ddfc28edb02c5047219779adeed12017e2f9f116e83762e86f805c7311ea88fb403ff21900e069142b1fb310e")
        XCTAssertEqual(signature.authenticationPublicKey, "8e53e7b10656816de70824e3016fc1a277e77825e12825dc4f239f418ab2e04e")
    }

    func testParseSignatureError() {
        let signatureHex = "a201d825509b1de"
        let sdk = KeystoneAptosSDK()
        let ur = try! UR(type: "aptos-signature", cbor: CBOR(signatureHex.hexadecimal))

        var thrownError: Swift.Error?
        XCTAssertThrowsError(try sdk.parseSignature(ur: ur)) {
             thrownError = $0
        }
        XCTAssertEqual(thrownError as? KeystoneError, .parseSignatureError("signature is invalid"))
    }

    func testGenerateSignRequest() {
        let signRequest = AptosSignRequest(
            requestId: "7AFD5E09-9267-43FB-A02E-08C4A09417EC",
            signData: "8e53e7b10656816de70824e3016fc1a277e77825e12825dc4f239f418ab2e04e",
            signType: .single,
            accounts: [
                AptosSignRequest.Account(path: "m/44'/637'/0'/0'/0'", xfp: "f23f9fd2", key: "aa7420c68c16645775ecf69a5e2fdaa4f89d3293aee0dd280e2d97ad7b879650"),
                AptosSignRequest.Account(path: "m/44'/637'/0'/0'/1'", xfp: "f23f9fd2", key: "97f95acfb04f84d228dce9bda4ad7e2a5cb324d5efdd6a7f0b959e755ebb3a70")
            ],
            origin: "aptosWallet"
        )

        let sdk = KeystoneAptosSDK()
        let signRequestEncoder = try! sdk.generateSignRequest(aptosSignRequest: signRequest)

        let qrCode = signRequestEncoder.nextPart()

        XCTAssertEqual(qrCode, "ur:aptos-sign-request/oladtpdagdknzchyasmoiofxzonbdmayssnbmwchwpaohdcxmnguvdpaamhflyjnvdaydkvladjlseoektvdksdavydedauogwcnnefpleprvtglaxlftaaddyoeadlecsdwykcfaokiykaeykaeykaeykaocywzfhnetdtaaddyoeadlecsdwykcfaokiykaeykaeykadykaocywzfhnetdaalfhdcxpkjycxswlkcmiehgkpwpynnyhydltnoxyanteymuplvtutdebadpmspmkgltmtgdhdcxmsythttkpfgwlrtddeuowlryoxpmkbdrhhqddktlwsutimlbbdmdnnkphyrkftjoahjehsjojyjljkhghsjzjzihjyamadtplnmdkg")
    }

    func testGenerateSignRequestError() {
        let signRequest = AptosSignRequest(
            requestId: "7AFD5E09-9267-43FB-A02E-08C4A09",
            signData: "8e53e7b10656816de70824e3016fc1a277e77825e12825dc4f239f418ab2e04e",
            signType: .single,
            accounts: [
                AptosSignRequest.Account(path: "m/44'/637'/0'/0'/0'", xfp: "f23f9fd2", key: "0xaa7420c68c16645775ecf69a5e2fdaa4f89d3293aee0dd280e2d97ad7b879650"),
                AptosSignRequest.Account(path: "m/44'/637'/0'/0'/1'", xfp: "f23f9fd2", key: "0x97f95acfb04f84d228dce9bda4ad7e2a5cb324d5efdd6a7f0b959e755ebb3a70")
            ],
            origin: "aptosWallet"
        )

        let sdk = KeystoneAptosSDK()

        var thrownError: Swift.Error?
        XCTAssertThrowsError(try sdk.generateSignRequest(aptosSignRequest: signRequest)) {
             thrownError = $0
        }
        XCTAssertEqual(thrownError as? KeystoneError, .generateSignRequestError("uuid is invalid"))
    }
}
