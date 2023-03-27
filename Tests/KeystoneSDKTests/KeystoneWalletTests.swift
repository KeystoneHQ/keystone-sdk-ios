//
//  KeystoneWalletTests.swift
//  
//
//  Created by LiYan on 3/27/23.
//

import XCTest
@testable import KeystoneSDK


final class KeystoneWalletTests: XCTestCase {
    func testParseMultiAccountsWithBTC() {
        let multiAccountsCBORHex = "a3011aa424853c0281d9012fa4035821034af544244d31619d773521a1a366373c485ff89de50bea543c2b14cccfbb6a500458208dc2427d8ab23caab07729f88f089a3cfa2cfffcd7d1e507f983c0d44a5dbd3506d90130a10186182cf500f500f5081a149439dc03686b657973746f6e65"
        
        let keystoneWallet = KeystoneWallet()
        let multiAccounts = try! keystoneWallet.parseMultiAccounts(cborHex: multiAccountsCBORHex)
        let firstHDKey = multiAccounts.keys[0]

        XCTAssertEqual(multiAccounts.device, "keystone")
        XCTAssertEqual(multiAccounts.masterFingerprint, "a424853c")

        XCTAssertEqual(firstHDKey.chain, "BTC")
        XCTAssertEqual(firstHDKey.path, "m/44'/0'/0'")
        XCTAssertEqual(firstHDKey.publicKey, "034af544244d31619d773521a1a366373c485ff89de50bea543c2b14cccfbb6a50")
        XCTAssertEqual(firstHDKey.extendedPublicKey, "xpub6BoYPFH1MivLdh2BWZuRu6LfuaVSkVak5wsDxjjkAWcUM2QPKyeCHXMgDfRJFvKZhqA4vM5vsgcD6C5ot9eThnFHstgPntNzBLUdLeKS7Zt")
    }
    
    func testParseMultiAccountsWithSOL() {
        let multiAccountsCBORHex = "a3011ae9181cf30281d9012fa203582102eae4b876a8696134b868f88cc2f51f715f2dbedb7446b8e6edf3d4541c4eb67b06d90130a10188182cf51901f5f500f500f503686b657973746f6e65"
        
        let keystoneWallet = KeystoneWallet()
        let multiAccounts = try! keystoneWallet.parseMultiAccounts(cborHex: multiAccountsCBORHex)
        let firstHDKey = multiAccounts.keys[0]

        XCTAssertEqual(multiAccounts.device, "keystone")
        XCTAssertEqual(multiAccounts.masterFingerprint, "e9181cf3")

        XCTAssertEqual(firstHDKey.chain, "SOL")
        XCTAssertEqual(firstHDKey.path, "m/44'/501'/0'/0'")
        XCTAssertEqual(firstHDKey.publicKey, "02eae4b876a8696134b868f88cc2f51f715f2dbedb7446b8e6edf3d4541c4eb67b")
        XCTAssertEqual(firstHDKey.extendedPublicKey, "")
    }
    
    func testParseMultiAccountsError() {
        let multiAccountsCBORHex = "a3011ae9181cf30281d9012fa203582102eae4b876a8696134b868f88cc2f51f715f2dbe"
        let keystoneWallet = KeystoneWallet()

        var thrownError: Swift.Error?
        XCTAssertThrowsError(try keystoneWallet.parseMultiAccounts(cborHex: multiAccountsCBORHex)) {
             thrownError = $0
        }
        XCTAssertEqual(thrownError as? KeystoneError, .parseMultiAccountsError)
    }
}
