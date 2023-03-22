import XCTest
@testable import KeystoneSDK


final class KeystoneSolanaSDKTests: XCTestCase {
    func testParseSignature() {
        let sol_signature = "a201d825509b1deb4d3b7d4bad9bdd2b0d7b3dcb6d025840d4f0a7bcd95bba1fbb1051885054730e3f47064288575aacc102fbbf6a9a14daa066991e360d3e3406c20c00a40973eff37c7d641e5b351ec4a99bfe86f335f7"

        let keystone_sol_sdk = KeystoneSolanaSDK()
        let sol_sig = keystone_sol_sdk.parseSignature(cbor_hex: sol_signature)

        XCTAssertEqual(sol_sig?.requestId, "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d")
        XCTAssertEqual(sol_sig?.signature, "d4f0a7bcd95bba1fbb1051885054730e3f47064288575aacc102fbbf6a9a14daa066991e360d3e3406c20c00a40973eff37c7d641e5b351ec4a99bfe86f335f7")
    }

    func testGenerateSignRequest() {
        let request_id = "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d"
        let sign_data = "01000103c8d842a2f17fd7aab608ce2ea535a6e958dffa20caf669b347b911c4171965530f957620b228bae2b94c82ddd4c093983a67365555b737ec7ddc1117e61c72e0000000000000000000000000000000000000000000000000000000000000000010295cc2f1f39f3604718496ea00676d6a72ec66ad09d926e3ece34f565f18d201020200010c0200000000e1f50500000000"
        let path = "m/44'/501'/0'/0'"
        let xfp = "12121212"
        let address = ""
        let origin = "solflare"
        
        let keystone_sol_sdk = KeystoneSolanaSDK()
        let sol_sign_request = try! keystone_sol_sdk.generateSignRequest(request_id: request_id, sign_data: sign_data, path: path, xfp: xfp, address: address, origin: origin, sign_type: KeystoneSolanaSDK.SignType.Message)
        
        let qr_code = sol_sign_request.nextPart()
        
        XCTAssertEqual(qr_code, "ur:sol-sign-request/1-5/lpadahcfadoscyzortlylkhdgokkadoxhsecdyehieeteyececdyesidehieihideeieeoidemieeeidhsieesidieieeyiddyieemideoieiaideniedyeyecetesendyehdydydyehdyeoiaetieeteeeyhseyiyehemiyieemhshsidendyetiaiheyihhsecghsrdebe")
    }
}
