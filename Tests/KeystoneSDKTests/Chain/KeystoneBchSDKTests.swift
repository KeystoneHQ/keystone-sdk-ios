//
//  KeystoneBchSDKTests.swift
//  
//
//  Created by LiYan on 4/21/23.
//

import Foundation
import XCTest
import URKit
@testable import KeystoneSDK

final class KeystoneBchSDKTests: XCTestCase {
    // mock timestamp to get same ur code
    override func setUp() {
        super.setUp()
        func stubCurrentTimestamp() -> Int64 { return 1681871353647}
        Date.currentTimestamp = stubCurrentTimestamp
    }

    let bchTransaction = UtxoBaseTransaction (
        fee: 2250,
        inputs: [
            Input(
                hash: "a59bcbaaae11ba5938434e2d4348243e5e392551156c4a3e88e7bdc0b2a8f663",
                index: 1,
                value: 18519750,
                pubkey: "025ad49879cc8f1f91a210c6a2762fe4904ef0d4f17fd124b11b86135e4cb9143d",
                ownerKeyPath: "m/44'/145'/0'/0/0"
            ),
        ],
        outputs: [
            Output(address: "bitcoincash:qzrxqxsx0lfzyk4ht60a5hwwtr2xjvtxmu0qhkusnx", value: 10000),
            Output(address: "bitcoincash:qpgw8p85ysnjutpsk6u490ytydmgdlmc6vzxu680su", value: 18507500, isChange: true, changeAddressPath: "M/44'/145'/0'/0/0")
        ]
    )

    func testGenerateSignRequest() {
        let bchSignRequest = KeystoneSignRequest<UtxoBaseTransaction>(
            requestId: "cc946be2-8e4c-42be-a321-56a53a8cf516",
            signData: bchTransaction,
            xfp: "F23F9FD2"
        )

        let bchSdk = KeystoneBchSDK()
        let bchSignRequestEncoder = try! bchSdk.generateSignRequest(keystoneSignRequest: bchSignRequest)

        let qrCode = bchSignRequestEncoder.nextPart()
        XCTAssertEqual(qrCode, "ur:keystone-sign-request/oyadhkadinctluayaeaeaeaeaeaeaxhlmnsngeaogycesktthtbnjttdhfttgedkdyaawnkbztwsykuetnlrlnqzdtsgemronekbfrwdsfvsvspkflvsbyoekiqzyladhtaaryfxuycplfmtwenyrejoetjobacetodlspctckuodptnoykpvwuyfecsltdscecturwsihjnticlqzcnfrmsoxwznddlwpretnhgltdiswfdvttnmerdjohnwdfzqzpydngejontjsskpdbgsweosfsbdlfhctuyfhjycyjyrlytvtpmghketnpefnvabkchlegajnqzgmsghspsqdfzahgdjossiydmaygdstcemdlrehlkcfemnbpdbwsaecreecfdbwdafnvdqzmkfrknkizebkdrdpfymkprcxfegucycnfnynbgdnlfmevyleeeeswnbadkaovdmeahmyndueidaoftzobwcegumtcljeldlytnhtintdaepdendypfimaxihimnbtnkklywmfpjzsasetypdpdlbenurdwtdkkcyoniswpemwmbywkiamnbbwmpehfwnlfoxsrihnsglbgeewsmymoisnycmctjtimutntwnpsrlbgeosetbttjymkssqdisssmulkimcapeweoxiostbwsrmsndeevyaofegawnzozceoetsggogetsrkfzzmdscnzeflmtadaeaewkmdkbuo")
    }
}
