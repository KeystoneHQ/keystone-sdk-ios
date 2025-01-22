//
//  KeystoneLitecoinSDKTests.swift
//  
//
//  Created by LiYan on 4/23/23.
//

import Foundation
import XCTest
import URKit
@testable import KeystoneSDK

final class KeystoneLitecoinSDKTests: XCTestCase {
    // mock timestamp to get same ur code
    override func setUp() {
        super.setUp()
        func stubCurrentTimestamp() -> Int64 { return 1681871353647}
        Date.currentTimestamp = stubCurrentTimestamp
    }

    let ltcTransaction = LitecoinTransaction (
        fee: 2250,
        inputs: [
            LitecoinTransaction.Input(
                hash: "a59bcbaaae11ba5938434e2d4348243e5e392551156c4a3e88e7bdc0b2a8f663",
                index: 1,
                utxo: LitecoinTransaction.Input.Utxo(
                    publicKey: "035684d200e10bc1a3e2bd7d59e58a07f2f19ef968725e18f1ed65e13396ab9466",
                    value: 18519750
                ),
                ownerKeyPath: "m/49'/2'/0'/0/0"
            )
        ],
        outputs: [
            Output(address: "MUfnaSqZjggTrHA2raCJ9kxpP2hM6zezKw", value: 10000),
            Output(address: "MK9aTexgpbRuMPqGpMERcjJ8hLJbAS31Nx", value: 18507500, isChange: true, changeAddressPath: "M/49'/2'/0'/0/0")
        ]
    )

    func testParseSignResult() {
        let signResultData = "a1015901b11f8b08000000000000004d923d8e14300c85b5628b0121214db9150505cd48fe8b635351a0a9b942123b0d122376b7e12c9c8c1b50517002cca241b88822c7fe64bf97c3cdf1d5a7fcfaf078f99cafbfdcaf4be4dd8fdbc3f3e3e14c7cf6f3077af7fdf6c59bb55c74269d2c659d84669e06139e9a8ec6c3d66ea8c7f7b2713919e0748bec113ef7f018c8a2446d933832c2de9b87efb0ee0a163b8ad17af77df7f319105c030195b70e9bb46016cf8c53862e6c0da9b1b7e4241113a69014666b3e07e2c831d6ac6b2bc65f5447ad53960866065ab22f81ec93338d3036e54a27eca0dcc176eca70042a00eff05f6e128c9c164620bb7f49a0d427dda469ecdc97b20470930b7f55caa38ae735cfbfb54d6ec69211a634ccf05630cf134fcb31fc2ea5533ad03496710012290dda2d74b099292c05a45e62bb74cf766a3483a143266ae51f6706d365a69b3cb26c9f9c468e808d6c0a66bf26ab01741ccca4ccba0020e3441dccaa1adaa2672b9db5bb9d4a9142d49b8a94994538930178eb261468fe6595340dfb4d173bb5a3524962e59a84466d7da5554af6abcfdf6eb865efefb7f1fef2fbf01cb596bb490020000"

        let ltcSdk = KeystoneLitecoinSDK()
        let ur = try! UR(type: "keystone-sign-result", cbor: CBOR(signResultData.hexadecimal))
        let signResult = try! ltcSdk.parseSignResult(ur: ur)

        XCTAssertEqual(signResult.requestId, "cc946be2-8e4c-42be-a321-56a53a8cf516")
        XCTAssertEqual(signResult.rawData, "0200000000010163f6a8b2c0bde7883e4a6c155125395e3e2448432d4e433859ba11aeaacb9ba50100000017160014c441eed18e39c40e7b3ee821df2ece9217063708fdffffff02102700000000000017a914e3d32848c1f470bd0d69b8f13b59297d13d8debf87ec661a010000000017a9147b636e7e8d46daab9ec0aaa49e816c1510c77b6b870247304402204f5d70c78b2e4e036c7789cef4b9958adaa6a60edbecaa323821a52d4f56a4eb02204519108508b96e3c50fc20db850b8ed2789a18411f63d658b9b13f5175da57250121035684d200e10bc1a3e2bd7d59e58a07f2f19ef968725e18f1ed65e13396ab946600000000")
    }

    func testGenerateSignRequest() {
        let ltcSignRequest = KeystoneSignRequest<LitecoinTransaction>(
            requestId: "cc946be2-8e4c-42be-a321-56a53a8cf516",
            signData: ltcTransaction,
            xfp: "F23F9FD2"
        )

        let ltcSdk = KeystoneLitecoinSDK()
        let ltcSignRequestEncoder = try! ltcSdk.generateSignRequest(keystoneSignRequest: ltcSignRequest)

        let qrCode = ltcSignRequestEncoder.nextPart()
        XCTAssertEqual(qrCode, "ur:keystone-sign-request/1-2/lpadaocfadhpcycpmhurfhhdployadhkadhfctluayaeaeaeaeaeaeaxgoglgwgraogycefyrkdwhyeegwvogamtrtbemtkizmylfsvsmhhkhfwdlepthlrdryylynrllezchkhllessgwvyflvsbdfyylfmfzfptidpftktdpoekgrlyncybnsrsfdydyvlvesbskmuqzmdfygdcwoxsokpidmuluwdkgfmgrntenoyjntluediwyjkrnpfttcwrlsghptbdrdsbnbegwaoqdckcnamfngtasynrotinsiminiamnfewevyvdvlwnchjnfriyntkthyengrjlbtyldmhgtptlhhcfjeqztblapasobnmdlkeydncsgahl")
    }

    func testGenerateSignRequestError() {
        let ltcSignRequest = KeystoneSignRequest<LitecoinTransaction>(
            requestId: "cc946be2-8e4c-42be-a321-56a53a8cf516",
            signData: ltcTransaction,
            xfp: "F23F9F"
        )

        let ltcSdk = KeystoneLitecoinSDK()

        var thrownError: Swift.Error?
        XCTAssertThrowsError(try ltcSdk.generateSignRequest(keystoneSignRequest: ltcSignRequest)) {
             thrownError = $0
        }
        XCTAssertEqual(thrownError as? KeystoneError, .generateSignRequestError("length of xfp must be exactly 8"))
    }
}
