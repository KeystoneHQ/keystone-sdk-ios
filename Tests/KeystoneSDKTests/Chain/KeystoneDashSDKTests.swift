//
//  KeystoneDashSDKTests.swift
//  
//
//  Created by LiYan on 4/23/23.
//

import Foundation
import XCTest
import URKit
@testable import KeystoneSDK

final class KeystoneDashSDKTests: XCTestCase {
    // mock timestamp to get same ur code
    override func setUp() {
        super.setUp()
        func stubCurrentTimestamp() -> Int64 { return 1681871353647}
        Date.currentTimestamp = stubCurrentTimestamp
    }

    let dashTransaction = UtxoBaseTransaction (
        fee: 2250,
        inputs: [
            Input(
                hash: "a59bcbaaae11ba5938434e2d4348243e5e392551156c4a3e88e7bdc0b2a8f663",
                index: 1,
                value: 18519750,
                pubkey: "03cf51a0e4f926e50177d3a662eb5cc38728828cec249ef42582e77e5503675314",
                ownerKeyPath: "m/44'/5'/0'/0/0"
            ),
        ],
        outputs: [
            Output(address: "XphpGezU3DUKHk87v2DoL4r7GhZUvCvvbm", value: 10000),
            Output(address: "XfmecwGwcPBR7pXTqrn26jTjNe8a4fvcSL", value: 18507500, isChange: true, changeAddressPath: "M/44'/5'/0'/0/0")
        ]
    )

    func testGenerateSignRequest() {
        let dashSignRequest = KeystoneSignRequest<UtxoBaseTransaction>(
            requestId: "cc946be2-8e4c-42be-a321-56a53a8cf516",
            signData: dashTransaction,
            xfp: "F23F9FD2"
        )

        let dashSdk = KeystoneDashSDK()
        let dashSignRequestEncoder = try! dashSdk.generateSignRequest(keystoneSignRequest: dashSignRequest)

        let qrCode = dashSignRequestEncoder.nextPart()

        XCTAssertEqual(qrCode, "ur:keystone-sign-request/1-2/lpadaocfadhtcyaedahspfhdpmoyadhkadgoctluayaeaeaeaeaeaeaxgolgfsgrsrgdcslpinwlberdqzkodrgldaaymdfwfdwzuetklalsrpoydphdgrredpmwjtyluerfoyghjeimmhbbztbyvodljojochktlbfzatsettutgobyktemvldecebanssraxmygopsgoglteglbghsiamwdstsldgadmkourleytjekplyjylsjtayynrphddmlpflvlkbjntkmklajplgvtfdoxswoynbttgyaakeltjssklomodsiyfmjlfnkirsfhzmkszotbztrpisrywpghctgeynkioykepdhdnblghfgeoywswmvonlstkn")
    }

    func testGenerateSignRequestError() {
        let dashSignRequest = KeystoneSignRequest<UtxoBaseTransaction>(
            requestId: "cc946be2-8e4c-42be-a321-56a53a8cf516",
            signData: dashTransaction,
            xfp: "F23F9F"
        )

        let dashSdk = KeystoneDashSDK()

        var thrownError: Swift.Error?
        XCTAssertThrowsError(try dashSdk.generateSignRequest(keystoneSignRequest: dashSignRequest)) {
             thrownError = $0
        }
        XCTAssertEqual(thrownError as? KeystoneError, .generateSignRequestError("length of xfp must be exactly 8"))
    }
}
