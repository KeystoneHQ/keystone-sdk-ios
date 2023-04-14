//
//  KeystoneCosmosSDKTests.swift
//  
//
//  Created by Renfeng Shi on 2023/4/7.
//
import XCTest
import URKit
@testable import KeystoneSDK

final class KeystoneCosmosSDKTests: XCTestCase {

    func testParseSignature() {
        let signatureHex = "a301d825507afd5e09926743fba02e08c4a09417ec02584078325c2ea8d1841dbcd962e894ca6ecd5890aa4c1aa9e1eb789cd2d0e9c22ec737c2b4fb9c2defd863cadf914f538330ec42d6c30c04857ee1f06e7f2589d7d903582103f3ded94f2969d76200c6ed5db836041cc815fa62aa791e047905186c07e00275"

        let sdk = KeystoneCosmosSDK()
        let ur = try! UR(type: "cosmos-signature", cborData: signatureHex.hexadecimal)
        let signature = try! sdk.parseSignature(ur: ur)

        XCTAssertEqual(signature.requestId, "7afd5e09-9267-43fb-a02e-08c4a09417ec")
        XCTAssertEqual(signature.signature, "78325c2ea8d1841dbcd962e894ca6ecd5890aa4c1aa9e1eb789cd2d0e9c22ec737c2b4fb9c2defd863cadf914f538330ec42d6c30c04857ee1f06e7f2589d7d9")
        XCTAssertEqual(signature.publicKey, "03f3ded94f2969d76200c6ed5db836041cc815fa62aa791e047905186c07e00275")
    }

    func testParseSignatureError() {
        let signatureHex = "a201d825509b1de"
        let sdk = KeystoneCosmosSDK()
        let ur = try! UR(type: "cosmos-signature", cborData: signatureHex.hexadecimal)
        
        var thrownError: Swift.Error?
        XCTAssertThrowsError(try sdk.parseSignature(ur: ur)) {
             thrownError = $0
        }
        XCTAssertEqual(thrownError as? KeystoneError, .parseSignatureError("signature is invalid"))
    }

    func testGenerateSignRequest() {
        let signRequest = CosmosSignRequest(
            requestId: "7AFD5E09-9267-43FB-A02E-08C4A09417EC",
            signData: "7B226163636F756E745F6E756D626572223A22323930353536222C22636861696E5F6964223A226F736D6F2D746573742D34222C22666565223A7B22616D6F756E74223A5B7B22616D6F756E74223A2231303032222C2264656E6F6D223A22756F736D6F227D5D2C22676173223A22313030313936227D2C226D656D6F223A22222C226D736773223A5B7B2274797065223A22636F736D6F732D73646B2F4D736753656E64222C2276616C7565223A7B22616D6F756E74223A5B7B22616D6F756E74223A223132303030303030222C2264656E6F6D223A22756F736D6F227D5D2C2266726F6D5F61646472657373223A226F736D6F31667334396A7867797A30306C78363436336534767A767838353667756C64756C6A7A6174366D222C22746F5F61646472657373223A226F736D6F31667334396A7867797A30306C78363436336534767A767838353667756C64756C6A7A6174366D227D7D5D2C2273657175656E6365223A2230227D",
            dataType: .amino,
            accounts: [
                CosmosSignRequest.Account(path: "m/44'/118'/0'/0/0", xfp: "f23f9fd2", address: "4c2a59190413dff36aba8e6ac130c7a691cfb79f")
            ],
            origin: "Keplr"
        )

        let sdk = KeystoneCosmosSDK()
        let signRequestEncoder = try! sdk.generateSignRequest(cosmosSignRequest: signRequest)

        let qrCode = signRequestEncoder.nextPart()

        XCTAssertEqual(qrCode, "ur:cosmos-sign-request/1-2/lpadaocfadtecyfzolaoaohdwdoladtpdagdknzchyasmoiofxzonbdmayssnbmwchwpaohkadjekgcphsiaiajlkpjtjyhejtkpjnidihjpcpftcpeyesdyececencpdwcpiaishsinjtheiniecpftcpjljkjnjldpjyihjkjydpeecpdwcpiyihihcpftkgcphsjnjlkpjtjycpfthpkgcphsjnjlkpjtjycpftcpehdydyeycpdwcpieihjtjljncpftcpkpjljkjnjlcpkihldwcpiohsjkcpftcpehdydyehesencpkidwcpjnihjnjlcpftcpcpdwcpjnjkiojkcpfthpkgcpjykkjoihcpftcpiajljkjnjljkdpjkiejedlgtjkioguihjtiecpdwcpkohsjzkpihcpftkgcphsjnjlkpjtjycpfthpkgcphsjnjlkpjtjycpftcpeheydydydydydydycpdwcpiernjotadi")
    }

    func testGenerateSignRequestError() {
        let signRequest = CosmosSignRequest(
            requestId: "7AFD5E09-9267-43FB-A02E-08C4A09417EC-1",
            signData: "7B226163636F756E745F6E756D626572223A22323930353536222C22636861696E5F6964223A226F736D6F2D746573742D34222C22666565223A7B22616D6F756E74223A5B7B22616D6F756E74223A2231303032222C2264656E6F6D223A22756F736D6F227D5D2C22676173223A22313030313936227D2C226D656D6F223A22222C226D736773223A5B7B2274797065223A22636F736D6F732D73646B2F4D736753656E64222C2276616C7565223A7B22616D6F756E74223A5B7B22616D6F756E74223A223132303030303030222C2264656E6F6D223A22756F736D6F227D5D2C2266726F6D5F61646472657373223A226F736D6F31667334396A7867797A30306C78363436336534767A767838353667756C64756C6A7A6174366D222C22746F5F61646472657373223A226F736D6F31667334396A7867797A30306C78363436336534767A767838353667756C64756C6A7A6174366D227D7D5D2C2273657175656E6365223A2230227D",
            dataType: .amino,
            accounts: [
                CosmosSignRequest.Account(path: "m/44'/118'/0'/0/0", xfp: "f23f9fd2", address: "4c2a59190413dff36aba8e6ac130c7a691cfb79f")
            ],
            origin: "Keplr"
        )

        let sdk = KeystoneCosmosSDK()

        var thrownError: Swift.Error?
        XCTAssertThrowsError(try sdk.generateSignRequest(cosmosSignRequest: signRequest)) {
             thrownError = $0
        }
        XCTAssertEqual(thrownError as? KeystoneError, .generateSignRequestError("uuid is invalid"))
    }
}
