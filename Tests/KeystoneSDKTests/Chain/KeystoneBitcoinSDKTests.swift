//
//  KeystoneBitcoinSDKTests.swift
//  
//
//  Created by LiYan on 3/30/23.
//

import Foundation
import XCTest
import URKit
@testable import KeystoneSDK


final class KeystoneBitcoinSDKTests: XCTestCase {
    func testPSBTExtendKnownVectors() throws {
        let sdk = KeystoneBitcoinSDK()
        for (coinId, cbor) in [(Int32(0), "a10142aabb"), (2, "a20142aabb0202"), (3, "a20142aabb0203"), (4, "a20142aabb0204"), (145, "a20142aabb021891")] {
            let ur = try UR(type: "crypto-psbt-extend", cbor: CBOR(cbor.hexadecimal))
            let parsed = try sdk.parsePSBTExtend(ur: ur)
            XCTAssertEqual(parsed.psbt, "aabb".hexadecimal)
            XCTAssertEqual(parsed.coinId, coinId == 0 ? nil : coinId)
            let encoder = try sdk.generatePSBTExtend(psbt: parsed.psbt, coinId: coinId)
            XCTAssertEqual(encoder.nextPart(), UREncoder(ur, maxFragmentLen: KeystoneSDK.maxFragmentLen).nextPart())
        }
        let expected = try UR(type: "crypto-psbt-extend", cbor: CBOR("a10142aabb".hexadecimal))
        XCTAssertEqual(try sdk.generatePSBTExtend(psbt: "aabb".hexadecimal).nextPart(), UREncoder(expected, maxFragmentLen: KeystoneSDK.maxFragmentLen).nextPart())
    }

    func testPSBTExtendInvalidInputs() throws {
        let sdk = KeystoneBitcoinSDK()
        let wrongType = try UR(type: "crypto-psbt", cbor: CBOR("a10142aabb".hexadecimal))
        XCTAssertThrowsError(try sdk.parsePSBTExtend(ur: wrongType)) {
            XCTAssertEqual($0 as? QRCodeError, .unexpectedQRCode)
        }
        for cbor in ["42aabb", "a20142aabb0201"] {
            let ur = try UR(type: "crypto-psbt-extend", cbor: CBOR(cbor.hexadecimal))
            XCTAssertThrowsError(try sdk.parsePSBTExtend(ur: ur)) {
                XCTAssertEqual($0 as? KeystoneError, .parsePSBTError("PSBT is invalid"))
            }
        }
        for coinId: Int32 in [-1, 1, 5, Int32.max] {
            XCTAssertThrowsError(try sdk.generatePSBTExtend(psbt: "aabb".hexadecimal, coinId: coinId)) {
                XCTAssertEqual($0 as? KeystoneError, .generatePSBTError("invalid coin_id"))
            }
        }
    }
    
    func testParsePsbt() {
        let psbtCborHex = "58A770736274FF01009A020000000258E87A21B56DAF0C23BE8E7070456C336F7CBAA5C8757924F545887BB2ABDD750000000000FFFFFFFF838D0427D0EC650A68AA46BB0B098AEA4422C071B2CA78352A077959D07CEA1D0100000000FFFFFFFF0270AAF00800000000160014D85C2B71D0060B09C9886AEB815E50991DDA124D00E1F5050000000016001400AEA9A2E5F0F876A588DF5546E8742D1D87008F000000000000000000"
        
        let bitcoinSdk = KeystoneBitcoinSDK()
        let ur = try! UR(type: "crypto-psbt", cbor: CBOR(psbtCborHex.hexadecimal))
        let psbt = try! bitcoinSdk.parsePSBT(ur: ur)
        
        XCTAssertEqual(psbt, "70736274FF01009A020000000258E87A21B56DAF0C23BE8E7070456C336F7CBAA5C8757924F545887BB2ABDD750000000000FFFFFFFF838D0427D0EC650A68AA46BB0B098AEA4422C071B2CA78352A077959D07CEA1D0100000000FFFFFFFF0270AAF00800000000160014D85C2B71D0060B09C9886AEB815E50991DDA124D00E1F5050000000016001400AEA9A2E5F0F876A588DF5546E8742D1D87008F000000000000000000".hexadecimal)
    }

    func testParsePsbtTypeError() {
        let psbtCborHex = "58A770736274FF01009A020000000258E87A21B56DAF0C23BE8E7070456C336F7CBAA5C8757924F545887BB2ABDD750000000000FFFFFFFF838D0427D0EC650A68AA46BB0B098AEA4422C071B2CA78352A077959D07CEA1D0100000000FFFFFFFF0270AAF00800000000160014D85C2B71D0060B09C9886AEB815E50991DDA124D00E1F5050000000016001400AEA9A2E5F0F876A588DF5546E8742D1D87008F000000000000000000"
        let bitcoinSdk = KeystoneBitcoinSDK()
        let ur = try! UR(type: "crypto-hdkey", cbor: CBOR(psbtCborHex.hexadecimal))

        var thrownError: Swift.Error?
        XCTAssertThrowsError(try bitcoinSdk.parsePSBT(ur: ur)) {
             thrownError = $0
        }
        XCTAssertEqual(thrownError as? QRCodeError, .unexpectedQRCode)
    }

    func testGeneratePsbtUR() {
        let psbtHex = "70736274FF01009A020000000258E87A21B56DAF0C23BE8E7070456C336F7CBAA5C8757924F545887BB2ABDD750000000000FFFFFFFF838D0427D0EC650A68AA46BB0B098AEA4422C071B2CA78352A077959D07CEA1D0100000000FFFFFFFF0270AAF00800000000160014D85C2B71D0060B09C9886AEB815E50991DDA124D00E1F5050000000016001400AEA9A2E5F0F876A588DF5546E8742D1D87008F000000000000000000"

        let bitcoinSdk = KeystoneBitcoinSDK()
        let psbtEncoder = try! bitcoinSdk.generatePSBT(psbt: psbtHex.hexadecimal)

        XCTAssertEqual(psbtEncoder.nextPart(), "ur:crypto-psbt/hdosjojkidjyzmadaenyaoaeaeaeaohdvsknclrejnpebncnrnmnjojofejzeojlkerdonspkpkkdkykfelokgprpyutkpaeaeaeaeaezmzmzmzmlslgaaditiwpihbkispkfgrkbdaslewdfycprtjsprsgksecdratkkhktikewdcaadaeaeaeaezmzmzmzmaojopkwtayaeaeaeaecmaebbtphhdnjstiambdassoloimwmlyhygdnlcatnbggtaevyykahaeaeaeaecmaebbaeplptoevwwtyakoonlourgofgvsjydpcaltaemyaeaeaeaeaeaeaeaeaebkgdcarh")
    }
}
