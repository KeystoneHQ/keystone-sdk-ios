import XCTest
import URKit
@testable import KeystoneSDK


final class KeystoneSolanaSDKTests: XCTestCase {

    func testParseSignature() {
        let solSignatureHex = "a201d825509b1deb4d3b7d4bad9bdd2b0d7b3dcb6d025840d4f0a7bcd95bba1fbb1051885054730e3f47064288575aacc102fbbf6a9a14daa066991e360d3e3406c20c00a40973eff37c7d641e5b351ec4a99bfe86f335f7"

        let solanaSdk = KeystoneSolanaSDK()
        let ur = try! UR(type: "sol-signature", cbor: CBOR(solSignatureHex.hexadecimal))
        let solSignature = try! solanaSdk.parseSignature(ur: ur)

        XCTAssertEqual(solSignature.requestId, "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d")
        XCTAssertEqual(solSignature.signature, "d4f0a7bcd95bba1fbb1051885054730e3f47064288575aacc102fbbf6a9a14daa066991e360d3e3406c20c00a40973eff37c7d641e5b351ec4a99bfe86f335f7")
    }

    func testGenerateSignRequest() {
        let solSignRequest = SolSignRequest(
            requestId: "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
            signData: "01000103c8d842a2f17fd7aab608ce2ea535a6e958dffa20caf669b347b911c4171965530f957620b228bae2b94c82ddd4c093983a67365555b737ec7ddc1117e61c72e0000000000000000000000000000000000000000000000000000000000000000010295cc2f1f39f3604718496ea00676d6a72ec66ad09d926e3ece34f565f18d201020200010c0200000000e1f50500000000",
            path: "m/44'/501'/0'/0'",
            xfp: "12121212",
            signType: .message,
            origin: "solflare"
        )

        let solanaSdk = KeystoneSolanaSDK()
        let solSignRequestEncoder = try! solanaSdk.generateSignRequest(solSignRequest: solSignRequest)

        let qrCode = solSignRequestEncoder.nextPart()

        XCTAssertEqual(qrCode, "ur:sol-sign-request/onadtpdagdndcawmgtfrkigrpmndutdnbtkgfssbjnaohdmtadaeadaxsptpfwoewnlbtspkrpaytodmonecolwlhdurzscxsgyninqdflrhbysschcfihgubsmdkocxprderdvorhgslfuttyrtmumkftioengogorlemwpkiuobychvacejpvtaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaebedthhsawnwfneenaajslrmtwdaeiojnimjpwpiypmastadsvlwpvlgwhfhecstdadaoaoaeadbnaoaeaeaeaevyykahaeaeaeaeaxtaaddyoeadlocsdwykcfadykykaeykaeykaocybgbgbgbgahisjkjljziyjzhsjpihamaodssrgsao")
    }

    func testGenerateSignRequestError() {
        let solSignRequest = SolSignRequest(
            requestId: "9b1deb4d-3b7d-4bad-9bdd-2",
            signData: "01000103c8d842a2f17fd7aab608ce2ea535a6e958dffa20caf669b347b911c4171965530f957620b228bae2b94c82ddd4c093983a67365555b737ec7ddc1117e61c72e0000000000000000000000000000000000000000000000000000000000000000010295cc2f1f39f3604718496ea00676d6a72ec66ad09d926e3ece34f565f18d201020200010c0200000000e1f50500000000",
            path: "m/44'/501'/0'/0'",
            xfp: "12121212",
            signType: .message,
            origin: "solflare"
        )

        let solanaSdk = KeystoneSolanaSDK()

        var thrownError: Swift.Error?
        XCTAssertThrowsError(try solanaSdk.generateSignRequest(solSignRequest: solSignRequest)) {
             thrownError = $0
        }
        XCTAssertEqual(thrownError as? KeystoneError, .generateSignRequestError("uuid is invalid"))
    }
}
