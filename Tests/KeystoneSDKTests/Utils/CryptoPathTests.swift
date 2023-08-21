//
//  CryptoPathTests.swift
//  
//
//  Created by LiYan on 8/21/23.
//

import Foundation
import XCTest
import URKit
@testable import KeystoneSDK


final class CryptoPathTests: XCTestCase {
    func testParseHDPath() {
        let hdPath = "m/44'/60'/0'/10/1"
        let path = CryptoPath.parseHDPath(hdPath: hdPath)

        XCTAssertEqual(path.purpose, Optional(PathItem(index:44, hardened: true)))
        XCTAssertEqual(path.coinType, Optional(PathItem(index:60, hardened: true)))
        XCTAssertEqual(path.account, Optional(PathItem(index:0, hardened: true)))
        XCTAssertEqual(path.change, Optional(PathItem(index:10, hardened: false)))
        XCTAssertEqual(path.addressIndex, Optional(PathItem(index:1, hardened: false)))
    }

    func testParseEmptyHDPath() {
        let hdPath = "m/44'/0'"
        let path = CryptoPath.parseHDPath(hdPath: hdPath)

        XCTAssertEqual(path.purpose?.index, 44)
        XCTAssertEqual(path.coinType?.index, 0)
        XCTAssertEqual(path.account, nil)
        XCTAssertEqual(path.change, nil)
        XCTAssertEqual(path.addressIndex, nil)
    }

    func testParseRandomString() {
        let hdPath = "abcd"
        let path = CryptoPath.parseHDPath(hdPath: hdPath)

        XCTAssertEqual(path.purpose, nil)
        XCTAssertEqual(path.coinType, nil)
        XCTAssertEqual(path.account, nil)
        XCTAssertEqual(path.change, nil)
        XCTAssertEqual(path.addressIndex, nil)
    }
}
