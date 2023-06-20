//
//  KeystoneSuiSDKTests.swift
//  
//
//  Created by Renfeng Shi on 2023/5/18.
//

import Foundation
import XCTest
import URKit
@testable import KeystoneSDK

final class KeystoneSuiSDKTests: XCTestCase {

    func testParseSignature() {
        let signatureHex = "A301D825509B1DEB4D3B7D4BAD9BDD2B0D7B3DCB6D025840F4B79835417490958C72492723409289B444F3AF18274BA484A9EEACA9E760520E453776E5975DF058B537476932A45239685F694FC6362FE5AF6BA714DA6505035820AEB28ECACE5C664C080E71B9EFD3D071B3DAC119A26F4E830DD6BD06712ED93F"

        let sdk = KeystoneSuiSDK()
        let ur = try! UR(type: "sui-signature", cborData: signatureHex.hexadecimal)
        let signature = try! sdk.parseSignature(ur: ur)

        XCTAssertEqual(signature.requestId, "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d")
        XCTAssertEqual(signature.signature, "f4b79835417490958c72492723409289b444f3af18274ba484a9eeaca9e760520e453776e5975df058b537476932a45239685f694fc6362fe5af6ba714da6505")
        XCTAssertEqual(signature.publicKey, "aeb28ecace5c664c080e71b9efd3d071b3dac119a26f4e830dd6bd06712ed93f")
    }

    func testParseSignatureError() {
        let signatureHex = "a201d825509b1de"
        let sdk = KeystoneSuiSDK()
        let ur = try! UR(type: "sui-signature", cborData: signatureHex.hexadecimal)

        var thrownError: Swift.Error?
        XCTAssertThrowsError(try sdk.parseSignature(ur: ur)) {
             thrownError = $0
        }
        XCTAssertEqual(thrownError as? KeystoneError, .parseSignatureError("signature is invalid"))
    }

    func testGenerateSignRequest() {
        let signRequest = SuiSignRequest(
            requestId: "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
            intentMessage: "00000000000200201ff915a5e9e32fdbe0135535b6c69a00a9809aaf7f7c0275d3239ca79db20d6400081027000000000000020200010101000101020000010000ebe623e33b7307f1350f8934beb3fb16baef0fc1b3f1b92868eec3944093886901a2e3e42930675d9571a467eb5d4b22553c93ccb84e9097972e02c490b4e7a22ab73200000000000020176c4727433105da34209f04ac3f22e192a2573d7948cb2fabde7d13a7f4f149ebe623e33b7307f1350f8934beb3fb16baef0fc1b3f1b92868eec39440938869e803000000000000640000000000000000",
            accounts: [
                SuiSignRequest.Account(path: "m/44'/784'/0'/0'/0'", xfp: "f23f9fd2", address: "0xebe623e33b7307f1350f8934beb3fb16baef0fc1b3f1b92868eec39440938869"),
                SuiSignRequest.Account(path: "m/44'/784'/0'/0'/1'", xfp: "f23f9fd2", address: "1ff915a5e9e32fdbe0135535b6c69a00a9809aaf7f7c0275d3239ca79db20d64")
            ],
            origin: "Sui Wallet"
        )

        let sdk = KeystoneSuiSDK()
        let signRequestEncoder = try! sdk.generateSignRequest(suiSignRequest: signRequest)

        let qrCode = signRequestEncoder.nextPart()

        XCTAssertEqual(qrCode, "ur:sui-sign-request/onadtpdagdndcawmgtfrkigrpmndutdnbtkgfssbjnaohduoaeaeaeaeaeaoaecxctytbzonwlvldluyvtbwgoecrpswnyaeptlanypelbkeaokptecnnsosntprbtieaeaybediaeaeaeaeaeaeaoaoaeadadadaeadadaoaeaeadaeaewmvacnvlfrjkatwnecbsldeernqdzocmrdwsbsseqdwnrhdeiswysrmwfzmuloinadoevlvedtdyiohlmdjsoxiowmhlgrcpgofnmusfroglmhmsmsdmaossmhqzvdoedrrleyaeaeaeaeaeaecxchjzfldifxehahtneecxneaapsfhcpvymooehgfskkfdsbdlpyuekibwoswkwngawmvacnvlfrjkatwnecbsldeernqdzocmrdwsbsseqdwnrhdeiswysrmwfzmuloinvsaxaeaeaeaeaeaeieaeaeaeaeaeaeaeaeaxlftaaddyoeadlecsdwykcfaxbeykaeykaeykaeykaocywzfhnetdtaaddyoeadlecsdwykcfaxbeykaeykaeykadykaocywzfhnetdaalfhdcxwmvacnvlfrjkatwnecbsldeernqdzocmrdwsbsseqdwnrhdeiswysrmwfzmuloinhdcxctytbzonwlvldluyvtbwgoecrpswnyaeptlanypelbkeaokptecnnsosntprbtieahimgukpincxhghsjzjzihjynllkahgt")
    }

    func testGenerateSignRequestError() {
        let signRequest = SuiSignRequest(
            requestId: "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb",
            intentMessage: "00000000000200201ff915a5e9e32fdbe0135535b6c69a00a9809aaf7f7c0275d3239ca79db20d6400081027000000000000020200010101000101020000010000ebe623e33b7307f1350f8934beb3fb16baef0fc1b3f1b92868eec3944093886901a2e3e42930675d9571a467eb5d4b22553c93ccb84e9097972e02c490b4e7a22ab73200000000000020176c4727433105da34209f04ac3f22e192a2573d7948cb2fabde7d13a7f4f149ebe623e33b7307f1350f8934beb3fb16baef0fc1b3f1b92868eec39440938869e803000000000000640000000000000000",
            accounts: [
                SuiSignRequest.Account(path: "m/44'/784'/0'/0'/0'", xfp: "f23f9fd2", address: "0xebe623e33b7307f1350f8934beb3fb16baef0fc1b3f1b92868eec39440938869"),
                SuiSignRequest.Account(path: "m/44'/784'/0'/0'/1'", xfp: "f23f9fd2", address: "1ff915a5e9e32fdbe0135535b6c69a00a9809aaf7f7c0275d3239ca79db20d64")
            ],
            origin: "Sui Wallet"
        )

        let sdk = KeystoneSuiSDK()

        var thrownError: Swift.Error?
        XCTAssertThrowsError(try sdk.generateSignRequest(suiSignRequest: signRequest)) {
             thrownError = $0
        }
        XCTAssertEqual(thrownError as? KeystoneError, .generateSignRequestError("uuid is invalid"))
    }
}
