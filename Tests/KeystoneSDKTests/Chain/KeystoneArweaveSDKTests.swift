//
//  KeystoneArweaveSDKTests.swift
//  
//
//  Created by LiYan on 4/28/23.
//

import Foundation
import XCTest
import URKit
@testable import KeystoneSDK

final class KeystoneArweaveSDKTests: XCTestCase {

    func testParseSignature() {
        let signatureHex = "a201d825509b1deb4d3b7d4bad9bdd2b0d7b3dcb6d0259020080337c3a47f1b69a38544c69f379a4aa0ea8ef1f853b718d992c6a73c643e63ca6dff9186cd2f41a45c6405ef6b71353c3b6864c799699964e559afa7aa7f7c345c1966c998193539985e2724831025beadb0a1a269f54ec4a95c69a3bc4295a5c6c5f926dcc84fbf2251b56c841f764b162e062c8db5302090aa1d528d83cf48b53aa0709009f3975d63ea8ff26e80b4f2f01380e100860b304fccbbc0877278efbf72fb045331f76df132a5119bd51590f0502350d3cb31f14daba731893c5834e2e8bfa5bf517ac63693b81041cf7f8ed7293d034b3e54c4d02c66542d3b9648e9ecf912101a20b87f39d75d4f1a02c816f424c8a1fda05a9e7e8ccf064d31c0bf10c661872a7f40c0b1d75dbfae6a95ddcc81eead3f49cfa3803517cf9d79f2541041416c3e8ecfc0292d864f34fe613866e86b7b0bc7abc5b3f84e6ee3b06933c4f82552bb985f6b7fac0a580e94d7a0e8e295dd2e49ece66ead0ee6a46b84553302b94701a9d24b91c085154b7e67a7ac59e3a41ae96c8e1afd1aa778633457005555cff4198820c2aa8ea1ff0f86a9f4ae03d96b215449c63bff7cae9a114c9db05cc4e4d9993a13149393b6a6992b6042bb82d34ffdc7f1aeaf17fa5240ca6ebd9e62fd6c90bce91747af37bf8fc3c72859a1dfec2cf2c49295e1ccdc09b91d9074d204dea74a70002baa05fc86acfcff45fe7f0dd7e5e24c8f69575"

        let sdk = KeystoneArweaveSDK()
        let ur = try! UR(type: "arweave-signature", cborData: signatureHex.hexadecimal)
        let signature = try! sdk.parseSignature(ur: ur)

        XCTAssertEqual(signature.requestId, "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d")
        XCTAssertEqual(signature.signature, "80337c3a47f1b69a38544c69f379a4aa0ea8ef1f853b718d992c6a73c643e63ca6dff9186cd2f41a45c6405ef6b71353c3b6864c799699964e559afa7aa7f7c345c1966c998193539985e2724831025beadb0a1a269f54ec4a95c69a3bc4295a5c6c5f926dcc84fbf2251b56c841f764b162e062c8db5302090aa1d528d83cf48b53aa0709009f3975d63ea8ff26e80b4f2f01380e100860b304fccbbc0877278efbf72fb045331f76df132a5119bd51590f0502350d3cb31f14daba731893c5834e2e8bfa5bf517ac63693b81041cf7f8ed7293d034b3e54c4d02c66542d3b9648e9ecf912101a20b87f39d75d4f1a02c816f424c8a1fda05a9e7e8ccf064d31c0bf10c661872a7f40c0b1d75dbfae6a95ddcc81eead3f49cfa3803517cf9d79f2541041416c3e8ecfc0292d864f34fe613866e86b7b0bc7abc5b3f84e6ee3b06933c4f82552bb985f6b7fac0a580e94d7a0e8e295dd2e49ece66ead0ee6a46b84553302b94701a9d24b91c085154b7e67a7ac59e3a41ae96c8e1afd1aa778633457005555cff4198820c2aa8ea1ff0f86a9f4ae03d96b215449c63bff7cae9a114c9db05cc4e4d9993a13149393b6a6992b6042bb82d34ffdc7f1aeaf17fa5240ca6ebd9e62fd6c90bce91747af37bf8fc3c72859a1dfec2cf2c49295e1ccdc09b91d9074d204dea74a70002baa05fc86acfcff45fe7f0dd7e5e24c8f69575")
    }

    func testParseSignatureError() {
        let signatureHex = "a201d825509b1de"
        let sdk = KeystoneArweaveSDK()
        let ur = try! UR(type: "arweave-signature", cborData: signatureHex.hexadecimal)

        var thrownError: Swift.Error?
        XCTAssertThrowsError(try sdk.parseSignature(ur: ur)) {
             thrownError = $0
        }
        XCTAssertEqual(thrownError as? KeystoneError, .parseSignatureError("signature is invalid"))
    }

    func testGenerateSignRequest() {
        let signRequest = ArweaveSignRequest(
            masterFingerprint: "F23F9FD2",
            requestId: "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
            signData: "7b22666f726d6174223a322c226964223a22222c226c6173745f7478223a22675448344631615059587639314a704b6b6e39495336684877515a3141597949654352793251694f654145547749454d4d5878786e466a30656b42466c713939222c226f776e6572223a22222c2274616773223a5b7b226e616d65223a2256486c775a51222c2276616c7565223a2256484a68626e4e6d5a5849227d2c7b226e616d65223a22513278705a573530222c2276616c7565223a2251584a44623235755a574e30227d2c7b226e616d65223a22513278705a5735304c565a6c636e4e70623234222c2276616c7565223a224d5334774c6a49227d5d2c22746172676574223a226b796977315934796c7279475652777454617473472d494e3965773838474d6c592d795f4c473346784741222c227175616e74697479223a2231303030303030303030222c2264617461223a22222c22646174615f73697a65223a2230222c22646174615f726f6f74223a22222c22726577617264223a2239313037353734333836222c227369676e6174757265223a22227d",
            saltLen: .zero,
            signType: .transaction,
            origin: "arconnect"
        )

        let sdk = KeystoneArweaveSDK()
        let signRequestEncoder = try! sdk.generateSignRequest(arweaveSignRequest: signRequest)

        let qrCode = signRequestEncoder.nextPart()

        XCTAssertEqual(qrCode, "ur:arweave-sign-request/1-2/lpadaocfadsscycpetjkvahdvooladcywzfhnetdaotpdagdndcawmgtfrkigrpmndutdnbtkgfssbjnaxhkadmtkgcpiyjljpjnhsjycpfteydwcpiniecpftcpcpdwcpjzhsjkjyhejykscpftcpioghfdeefgehhsgdhkhdkoesehgejogrjejtesgaguenisfdktgyhtehfphkkkgaihfxgmkkeygyingwihfpfeghktgafegtgthdksksjtfgimdyihjefwfgjzjsesescpdwcpjlktjtihjpcpftcpcpdwcpjyhsiojkcpfthpkgcpjthsjnihcpftcphffdjzkthtgycpdwcpkohsjzkpihcpftcphffdgeisidjtgljnhthdgacpkidwkgcpjthsjnihcpftcpgyeyksjohthgecdycpdwcpkohsjzkpihcpftcpgyhdgefyideyeckphthgglzofxnsia")
    }

    func testGenerateSignRequestError() {
        let signRequest = ArweaveSignRequest(
            masterFingerprint: "F23F9FD2",
            requestId: "9b1deb4d-3b7d-4bad-9bdd-2b0d7b",
            signData: "7b22666f726d6174223a322c226964223a22222c226c6173745f7478223a22675448344631615059587639314a704b6b6e39495336684877515a3141597949654352793251694f654145547749454d4d5878786e466a30656b42466c713939222c226f776e6572223a22222c2274616773223a5b7b226e616d65223a2256486c775a51222c2276616c7565223a2256484a68626e4e6d5a5849227d2c7b226e616d65223a22513278705a573530222c2276616c7565223a2251584a44623235755a574e30227d2c7b226e616d65223a22513278705a5735304c565a6c636e4e70623234222c2276616c7565223a224d5334774c6a49227d5d2c22746172676574223a226b796977315934796c7279475652777454617473472d494e3965773838474d6c592d795f4c473346784741222c227175616e74697479223a2231303030303030303030222c2264617461223a22222c22646174615f73697a65223a2230222c22646174615f726f6f74223a22222c22726577617264223a2239313037353734333836222c227369676e6174757265223a22227d",
            saltLen: .zero,
            signType: .transaction,
            origin: "arconnect"
        )

        let sdk = KeystoneArweaveSDK()

        var thrownError: Swift.Error?
        XCTAssertThrowsError(try sdk.generateSignRequest(arweaveSignRequest:  signRequest)) {
             thrownError = $0
        }
        XCTAssertEqual(thrownError as? KeystoneError, .generateSignRequestError("uuid is invalid"))
    }
}
