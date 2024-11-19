import XCTest
import URKit
@testable import KeystoneSDK


final class KeystoneNearSDKTests: XCTestCase {

    func testParseSignature() {
        let cborHex = "a201d825509b1deb4d3b7d4bad9bdd2b0d7b3dcb6d0281584085c578f8ca68bf8d771f0346ed68c4170df9ee9878cb76f3e2fac425c3f5793d36a741547e245c6c7ac1b9433ad5fc523d41152cac2a3726cbe134e0a0366802"

        let sdk = KeystoneNearSDK()
        let ur = try! UR(type: "near-signature", cbor: CBOR(cborHex.hexadecimal))
        let nearSignature = try! sdk.parseSignature(ur: ur)

        XCTAssertEqual(nearSignature.requestId, "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d")
        XCTAssertEqual(nearSignature.signature, ["85c578f8ca68bf8d771f0346ed68c4170df9ee9878cb76f3e2fac425c3f5793d36a741547e245c6c7ac1b9433ad5fc523d41152cac2a3726cbe134e0a0366802"])
    }

    func testParseSignatureError() {
        let cborHex = "a201d825509b1de"
        let sdk = KeystoneNearSDK()
        let ur = try! UR(type: "near-signature", cbor: CBOR(cborHex.hexadecimal))
        
        var thrownError: Swift.Error?
        XCTAssertThrowsError(try sdk.parseSignature(ur: ur)) {
             thrownError = $0
        }
        XCTAssertEqual(thrownError as? KeystoneError, .parseSignatureError("signature is invalid"))
    }


    func testGenerateSignRequest() {
        let signRequest = NearSignRequest(
            requestId: "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
            signData: ["4000000039666363303732306130313664336331653834396438366231366437313339653034336566633438616464316337386633396333643266303065653938633037009FCC0720A016D3C1E849D86B16D7139E043EFC48ADD1C78F39C3D2F00EE98C07823E0CA1957100004000000039666363303732306130313664336331653834396438366231366437313339653034336566633438616464316337386633396333643266303065653938633037F0787E1CB1C22A1C63C24A37E4C6C656DD3CB049E6B7C17F75D01F0859EFB7D80100000003000000A1EDCCCE1BC2D3000000000000"],
            path: "m/44'/397'/0'",
            xfp: "F23F9FD2",
            account: "",
            origin: "nearwallet"
        )

        let sdk = KeystoneNearSDK()
        let signRequestEncoder = try! sdk.generateSignRequest(nearSignRequest: signRequest)

        let qrCode = signRequestEncoder.nextPart()

        XCTAssertEqual(qrCode, "ur:near-sign-request/oxadtpdagdndcawmgtfrkigrpmndutdnbtkgfssbjnaolyhdvafzaeaeaeesiyiaiadyemeydyhsdyehenieeoiaehiheteeesieetenidehenieemeheoesihdyeeeoihiyiaeeethsieieehiaemetiyeoesiaeoieeyiydydyihihesetiadyemaenesfatcxnbcmtesevsgatpjecmtsbwnnaafmztfdpmttstmyessrtdwtbawllkatlffmbnoymdjsaeaefzaeaeaeesiyiaiadyemeydyhsdyehenieeoiaehiheteeesieetenidehenieemeheoesihdyeeeoihiyiaeeethsieieehiaemetiyeoesiaeoieeyiydydyihihesetiadyemwtkskbcepasadrceiasageemveswswhfutfnpfgavarlselbkptictayhkwsrltpadaeaeaeaxaeaeaeoywesftocwsateaeaeaeaeaeaeaxtaaddyoeadlncsdwykcfadlgykaeykaocywzfhnetdahimjtihhsjpkthsjzjzihjycxcahgbg")
    }

    func testGenerateSignRequestError() {
        let signRequest = NearSignRequest(
            requestId: "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6",
            signData: ["4000000039666363303732306130313664336331653834396438366231366437313339653034336566633438616464316337386633396333643266303065653938633037009FCC0720A016D3C1E849D86B16D7139E043EFC48ADD1C78F39C3D2F00EE98C07823E0CA1957100004000000039666363303732306130313664336331653834396438366231366437313339653034336566633438616464316337386633396333643266303065653938633037F0787E1CB1C22A1C63C24A37E4C6C656DD3CB049E6B7C17F75D01F0859EFB7D80100000003000000A1EDCCCE1BC2D3000000000000"],
            path: "m/44'/397'/0'",
            xfp: "F23F9FD2",
            account: "",
            origin: "nearwallet"
        )

        let sdk = KeystoneNearSDK()

        var thrownError: Swift.Error?
        XCTAssertThrowsError(try sdk.generateSignRequest(nearSignRequest: signRequest)) {
             thrownError = $0
        }
        XCTAssertEqual(thrownError as? KeystoneError, .generateSignRequestError("uuid is invalid"))
    }
}
