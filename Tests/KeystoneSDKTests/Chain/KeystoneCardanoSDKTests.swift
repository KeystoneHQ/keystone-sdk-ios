//
//  KeystoneCardanoSDKTests.swift
//  
//
//  Created by LiYan on 5/22/23.
//

import Foundation
import XCTest
import URKit
@testable import KeystoneSDK

final class KeystoneCardanoSDKTests: XCTestCase {

    func testParseSignature() {
        let signatureHex = "a201d825509b1deb4d3b7d4bad9bdd2b0d7b3dcb6d0258cda100828258207233f4cd5f24fa554e1ea4ed9251e39f4e18b2e0efd909b27ca01333c22ac49a5840725d8d98bab67eec8bf2704153f725f35ff7b0c9fabee135d97cf6c6b0885b14aa8748d9ba236abd19560b43afb0c5ac6d03359a1ef71b0712fc300d73e23e07825820c4af2472a9b27acad95967b1f5ff224cf3065824f6f1f0df7dbf4b52b819b1e85840c1ba75df625c7f657633f85f07d0bfd67f4e8ffb6b81b4b65a0ab186b459c4434971c25191b2725bff3f29bb9c1d247aabd60e63f0ea6ba53db0624ae1bcc101"

        let sdk = KeystoneCardanoSDK()
        let ur = try! UR(type: "cardano-signature", cbor: CBOR(signatureHex.hexadecimal))
        let signature = try! sdk.parseSignature(ur: ur)

        XCTAssertEqual(signature.requestId, "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d")
        XCTAssertEqual(signature.witnessSet, "a100828258207233f4cd5f24fa554e1ea4ed9251e39f4e18b2e0efd909b27ca01333c22ac49a5840725d8d98bab67eec8bf2704153f725f35ff7b0c9fabee135d97cf6c6b0885b14aa8748d9ba236abd19560b43afb0c5ac6d03359a1ef71b0712fc300d73e23e07825820c4af2472a9b27acad95967b1f5ff224cf3065824f6f1f0df7dbf4b52b819b1e85840c1ba75df625c7f657633f85f07d0bfd67f4e8ffb6b81b4b65a0ab186b459c4434971c25191b2725bff3f29bb9c1d247aabd60e63f0ea6ba53db0624ae1bcc101")
    }

    func testGenerateSignRequest() {
        let signRequest = CardanoSignRequest(
            requestId: "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
            signData: "84a400828258204e3a6e7fdcb0d0efa17bf79c13aed2b4cb9baf37fb1aa2e39553d5bd720c5c99038258204e3a6e7fdcb0d0efa17bf79c13aed2b4cb9baf37fb1aa2e39553d5bd720c5c99040182a200581d6179df4c75f7616d7d1fd39cbc1a6ea6b40a0d7b89fea62fc0909b6c370119c350a200581d61c9b0c9761fd1dc0404abd55efc895026628b5035ac623c614fbad0310119c35002198ecb0300a0f5f6",
            utxos: [
                CardanoSignRequest.Utxo(
                    transactionHash: "4e3a6e7fdcb0d0efa17bf79c13aed2b4cb9baf37fb1aa2e39553d5bd720c5c99",
                    index: 3,
                    amount: "10000000",
                    xfp: "73c5da0a",
                    hdPath: "m/1852'/1815'/0'/0/0",
                    address: "addr1qy8ac7qqy0vtulyl7wntmsxc6wex80gvcyjy33qffrhm7sh927ysx5sftuw0dlft05dz3c7revpf7jx0xnlcjz3g69mq4afdhv"
                ),
                CardanoSignRequest.Utxo(
                    transactionHash: "4e3a6e7fdcb0d0efa17bf79c13aed2b4cb9baf37fb1aa2e39553d5bd720c5c99",
                    index: 4,
                    amount: "18020000",
                    xfp: "73c5da0a",
                    hdPath: "m/1852'/1815'/0'/0/1",
                    address: "addr1qyz85693g4fr8c55mfyxhae8j2u04pydxrgqr73vmwpx3azv4dgkyrgylj5yl2m0jlpdpeswyyzjs0vhwvnl6xg9f7ssrxkz90"
                )
            ],
            certKeys: [
                CardanoSignRequest.CertKey(
                    keyHash: "e557890352095f1cf6fd2b7d1a28e3c3cb029f48cf34ff890a28d176", xfp: "73c5da0a", keyPath: "m/1852'/1815'/0'/2/0"
                )
            ],
            origin: "cardano-wallet"
        )

        let sdk = KeystoneCardanoSDK()
        let signRequestEncoder = try! sdk.generateSignRequest(cardanoSignRequest: signRequest)

        let qrCode = signRequestEncoder.nextPart()
        
        print(qrCode)

        XCTAssertEqual(qrCode, "ur:cardano-sign-request/1-4/lpadaacfaokgcynncemytahdneonadtpdagdndcawmgtfrkigrpmndutdnbtkgfssbjnaohdoylroxaelflfhdcxglftjtlbuopftiwsoykgylnsbwpltdqzsbndpeemzocyoevlmdgutlryjpbnhhnlaxlfhdcxglftjtlbuopftiwsoykgylnsbwpltdqzsbndpeemzocyoevlmdgutlryjpbnhhnlaaadlfoeaehdcahskkurgskpylhsjnkicttensrfcyjtolqzbkbtkgldzeoldlrtmhndjzemadcfsrgdoeaehdcahssopfsokoctttuoaaaapytlhyztldgdatostidy")
    }

    func testGenerateSignRequestError() {
        let signRequest = CardanoSignRequest(
            requestId: "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
            signData: "84a400828258204e3a6e7fdcb0d0efa17bf79c13aed2b4cb9baf37fb1aa2e39553d5bd720c5c99038258204e3a6e7fdcb0d0efa17bf79c13aed2b4cb9baf37fb1aa2e39553d5bd720c5c99040182a200581d6179df4c75f7616d7d1fd39cbc1a6ea6b40a0d7b89fea62fc0909b6c370119c350a200581d61c9b0c9761fd1dc0404abd55efc895026628b5035ac623c614fbad0310119c35002198ecb0300a0f5f6",
            utxos: [
                CardanoSignRequest.Utxo(
                    transactionHash: "4e3a6e7fdcb0d0efa17bf79c13aed2b4cb9baf37fb1aa2e39553d5bd720c5c99",
                    index: 3,
                    amount: "10000000",
                    xfp: "73c5da",
                    hdPath: "m/1852'/1815'/0'/0/0",
                    address: "addr1qy8ac7qqy0vtulyl7wntmsxc6wex80gvcyjy33qffrhm7sh927ysx5sftuw0dlft05dz3c7revpf7jx0xnlcjz3g69mq4afdhv"
                ),
                CardanoSignRequest.Utxo(
                    transactionHash: "4e3a6e7fdcb0d0efa17bf79c13aed2b4cb9baf37fb1aa2e39553d5bd720c5c99",
                    index: 4,
                    amount: "18020000",
                    xfp: "73c5da0a",
                    hdPath: "m/1852'/1815'/0'/0/1",
                    address: "addr1qyz85693g4fr8c55mfyxhae8j2u04pydxrgqr73vmwpx3azv4dgkyrgylj5yl2m0jlpdpeswyyzjs0vhwvnl6xg9f7ssrxkz90"
                )
            ],
            certKeys: [
                CardanoSignRequest.CertKey(
                    keyHash: "e557890352095f1cf6fd2b7d1a28e3c3cb029f48cf34ff890a28d176", xfp: "73c5da0a", keyPath: "m/1852'/1815'/0'/2/0"
                )
            ],
            origin: "cardano-wallet"
        )

        let sdk = KeystoneCardanoSDK()

        var thrownError: Swift.Error?
        XCTAssertThrowsError(try sdk.generateSignRequest(cardanoSignRequest: signRequest)) {
             thrownError = $0
        }
        XCTAssertEqual(thrownError as? KeystoneError, .generateSignRequestError("xfp in utxos is invalid"))
    }
}
