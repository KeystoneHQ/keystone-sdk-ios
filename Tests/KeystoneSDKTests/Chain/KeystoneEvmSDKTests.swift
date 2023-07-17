//
//  KeystoneEvmSDKTests.swift
//  
//
//  Created by Renfeng Shi on 2023/7/17.
//

import XCTest
import URKit
@testable import KeystoneSDK

final class KeystoneEvmSDKTests: XCTestCase {

    func testParseSignature() {
        let signatureHex = "a201d82550057523355d514a64a481ff2200000000025840a0e2577ca16119a32f421c6a1c90fa2178a9382f30bf3575ff276fb820b32b3269d49d6bbfc82bae899f60c15de4b97f24a7ebb6d4712534829628ccfbef38bc"

        let sdk = KeystoneEvmSDK()
        let ur = try! UR(type: "evm-signature", cborData: signatureHex.hexadecimal)
        let signature = try! sdk.parseSignature(ur: ur)

        XCTAssertEqual(signature.requestId, "05752335-5d51-4a64-a481-ff2200000000")
        XCTAssertEqual(signature.signature, "a0e2577ca16119a32f421c6a1c90fa2178a9382f30bf3575ff276fb820b32b3269d49d6bbfc82bae899f60c15de4b97f24a7ebb6d4712534829628ccfbef38bc")
    }

    func testParseSignatureError() {
        let signatureHex = "a201d825509b1de"
        let sdk = KeystoneEvmSDK()
        let ur = try! UR(type: "evm-signature", cborData: signatureHex.hexadecimal)
        
        var thrownError: Swift.Error?
        XCTAssertThrowsError(try sdk.parseSignature(ur: ur)) {
             thrownError = $0
        }
        XCTAssertEqual(thrownError as? KeystoneError, .parseSignatureError("signature is invalid"))
    }

    func testGenerateSignRequest() {
        let signRequest = EvmSignRequest(
            requestId: "05752335-5d51-4a64-a481-ff2200000000",
            signData: "0A9D010A9A010A1C2F636F736D6F732E62616E6B2E763162657461312E4D736753656E64127A0A2C65766D6F73317363397975617230756E3736677235633871346A3736687572347179706A6B38336E786B7735122C65766D6F73317363397975617230756E3736677235633871346A3736687572347179706A6B38336E786B77351A1C0A07617465766D6F7312113130303030303030303030303030303030127E0A590A4F0A282F65746865726D696E742E63727970746F2E76312E657468736563703235366B312E5075624B657912230A21024F7A8D64E515CCF1E0A92A7C859262F425473CF09A50EBCAF3B06B156624145312040A020801181612210A1B0A07617465766D6F7312103236323530303030303030303030303010A8B4061A0C65766D6F735F393030302D342084C68E01",
            dataType: .cosmosDirect,
            customChainIdentifier: 9000,
            account: EvmSignRequest.Account(path: "m/44'/60'/0'/0/0", xfp: "f23f9fd2", address: "0x860A4E746FE4FDA40E98382B2F6AFC1D4040CAC7"),
            origin: "Keplr Extension"
        )

        let sdk = KeystoneEvmSDK()
        let signRequestEncoder = try! sdk.generateSignRequest(evmSignRequest: signRequest)

        let qrCode = signRequestEncoder.nextPart()

        XCTAssertEqual(qrCode, "ur:evm-sign-request/1-2/lpadaocfadmocyldbbnehnhdsoosadtpdagdahkpcnechlgygeieoxlyzmcpaeaeaeaeaohkadeobkntadbknyadbkcedliajljkjnjljkdmidhsjtjedmkoehidihjyhsehdmgtjkioguihjtiebgknbkdwihkojnjljkehjkiaeskkkphsjpdykpjtemeniojpeciaetjseeimemeniskpjpeejskkjoimjeeteojtksjektecbgdwihkojnjljkehjkiaeskkkphsjpdykpjtemeniojpeciaetjseeimemeniskpjpeejskkjoimjeeteojtksjekteccycebkathsjyihkojnjljkbgbyehdydydydydydydydydydydydydydydydybgkbbkhkbkgwbkdedlihjyisihjpjninsocsleax")
    }

    func testGenerateSignRequestError() {
        let signRequest = EvmSignRequest(
            requestId: "7AFD5E09-9267-43FB-A02E-08C4A09417EC-1",
            signData: "0A9D010A9A010A1C2F636F736D6F732E62616E6B2E763162657461312E4D736753656E64127A0A2C65766D6F73317363397975617230756E3736677235633871346A3736687572347179706A6B38336E786B7735122C65766D6F73317363397975617230756E3736677235633871346A3736687572347179706A6B38336E786B77351A1C0A07617465766D6F7312113130303030303030303030303030303030127E0A590A4F0A282F65746865726D696E742E63727970746F2E76312E657468736563703235366B312E5075624B657912230A21024F7A8D64E515CCF1E0A92A7C859262F425473CF09A50EBCAF3B06B156624145312040A020801181612210A1B0A07617465766D6F7312103236323530303030303030303030303010A8B4061A0C65766D6F735F393030302D342084C68E01",
            dataType: .cosmosDirect,
            customChainIdentifier: 9000,
            account: EvmSignRequest.Account(path: "m/44'/60'/0'/0/0", xfp: "f23f9fd2", address: "0x860A4E746FE4FDA40E98382B2F6AFC1D4040CAC7"),
            origin: "Keplr"
        )

        let sdk = KeystoneEvmSDK()

        var thrownError: Swift.Error?
        XCTAssertThrowsError(try sdk.generateSignRequest(evmSignRequest: signRequest)) {
             thrownError = $0
        }
        XCTAssertEqual(thrownError as? KeystoneError, .generateSignRequestError("uuid is invalid"))
    }
}
