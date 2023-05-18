//
//  KeystoneTronSDKTests.swift
//  
//
//  Created by LiYan on 4/12/23.
//

import Foundation

import Foundation
import XCTest
import URKit
@testable import KeystoneSDK


final class KeystoneTronSDKTests: XCTestCase {
    // mock timestamp to get same ur code
    override func setUp() {
        super.setUp()
        func stubCurrentTimestamp() -> Int64 { return 1681871353647}
        Date.currentTimestamp = stubCurrentTimestamp
    }
    
    func testParseSignature() {
        let tronSignatureHex = "a1015901bd1f8b08000000000000008d523d8e94310cd54aac342024a429b7a2a0a019c9761c3ba6a24053738538761a24462c349c85821b5071324e80bf866e259c2acf3fc97bcfa7bbf3ab4ff9fdebb7dbe77cfde571dd221f7edd9f9e9f4f576a57bb7ea0773fef5fbc31c748e7b834d7b8b0cfb898475cc821d45b2c9738bf4708696e0b1612766308304cd71d996da5ae4d2e991464440b779f16da1c3a590eebfcf0fb19cc60409840a006443012dd227b3791be449161c062d361eeb4fa9c59f50337d2b4a3b3a1b29a82744a51d975549674c1c24c5ba1adb0a0ada0245bb96e07b2283b176255afd2957a93a82e52e6239f7a64519a321606133be3889d0b5724ee9469b9da98284b436a7acb563c46c70587205cfa14f36563f65c13eac54aeebdcd9a9930b5b545963527622e36dd963b3c112533a96df498b6577da746a1f7b61a88000de1de5a6a7baaff3f623331282c28d760e8a1b701e000e3f458d09018990edad967efe527378d12aa1c09d8f51b825d245bcf42dc04dd8753a9422327e8e251aa90501fd29a61b0899197db0344b725c0613cd7aa64d916633a1869bd85735755772df7dffef873472fff6df1c7c7db5f8509bb54d6020000"

        let tronSdk = KeystoneTronSDK()
        let ur = try! UR(type: "keystone-sign-result", cborData: tronSignatureHex.hexadecimal)
        let tronSignature = try! tronSdk.parseSignature(ur: ur)

        XCTAssertEqual(tronSignature.requestId, "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d")
        XCTAssertEqual(tronSignature.signature, "42a9ece5a555a9437de74108d0fb5320f20835e108b961bb8b230228ea07c485412625863391d49692be558067f9e00559641f5ee63d8ab09275a51afe555b7e01")
    }
    
    func testGenerateSignRequest() {
        let tronSignRequest = TronSignRequest(
            requestId: "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
            signData: "0a0207902208e1b9de559665c6714080c49789bb2c5aae01081f12a9010a31747970652e676f6f676c65617069732e636f6d2f70726f746f636f6c2e54726967676572536d617274436f6e747261637412740a15418dfec1cde1fe6a9ec38a16c7d67073e3020851c0121541a614f803b6fd780986a42c78ec9c7f77e6ded13c2244a9059cbb0000000000000000000000009c0279f1bda9fc40a85f1b53c306602864533e73000000000000000000000000000000000000000000000000000000000098968070c0b6e087bb2c90018094ebdc03",
            path: "m/44'/195'/0'/0/0",
            xfp: "F23F9FD2"
        )

        let tronSdk = KeystoneTronSDK()
        let tronSignRequestEncoder = try! tronSdk.generateSignRequest(tronSignRequest: tronSignRequest)
        
        let qrCode = tronSignRequestEncoder.nextPart()

        XCTAssertEqual(qrCode, "ur:keystone-sign-request/oyadhkaddsctluayaeaeaeaeaeaeaxkplerygllshncsfgiaiabnwlgmiheygsbtehptlslrzmnetketfdbygeaapaghlfoycwctdlfpldleondereemvtimvocaksaxftkptiskttsbvsbzrorkgaidcecefnkkmodiesesfyluwpyaongyfztncamtfegodkskahyktyimdwhsasoelppsaxlykbjzrehglsttpafljtclsffxledahnfypsaocnvycscslradcsadjknbidbybgpsaerejssogegmmyvwmeuoiarhiydwtskizehhrnkbjsuyjezcmybzmobafgpkiogwwztywniolsrtettsdstnetmoplhlpmpdglvahkwyvagefettlyktsbatykhscpeejsiyhyestayavswpdsecjefrlkpfwlvswffrntolaxurgdltvopthlmtjspdflaxbnjsetguleptvstbhyhyoykbenahlyvtrhctkoutynkbjklbfdkklkcxmdihoxdejpoepdrswlrspsfhjyenurchsbzorlcazoihpaylbtpyidjsluetadaeaeotwstefe")
    }
    
    func testGenerateSignRequestWithToken() {
        let tronSignRequest = TronSignRequest(
            requestId: "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
            signData: "0a0207902208e1b9de559665c6714080c49789bb2c5aae01081f12a9010a31747970652e676f6f676c65617069732e636f6d2f70726f746f636f6c2e54726967676572536d617274436f6e747261637412740a15418dfec1cde1fe6a9ec38a16c7d67073e3020851c0121541a614f803b6fd780986a42c78ec9c7f77e6ded13c2244a9059cbb0000000000000000000000009c0279f1bda9fc40a85f1b53c306602864533e73000000000000000000000000000000000000000000000000000000000098968070c0b6e087bb2c90018094ebdc03",
            path: "m/44'/195'/0'/0/0",
            xfp: "F23F9FD2",
            tokenInfo: TokenInfo(name: "TRON_USDT", symbol: "USDT", decimals: 6)
        )

        let tronSdk = KeystoneTronSDK()
        let tronSignRequestEncoder = try! tronSdk.generateSignRequest(tronSignRequest: tronSignRequest)
        
        let qrCode = tronSignRequestEncoder.nextPart()

        XCTAssertEqual(qrCode, "ur:keystone-sign-request/oyadhkadetctluayaeaeaeaeaeaeaxkpmhrygesrgdceskpamwgmrkghvlgmftmdcxtysemhwsoxhgcewpktpfehenweecmodmmondlbloamecenlgolynahhhkibnemntdrvsvoluaykiaoktemgussseoyfhbanssrvygsdineoyleiytybnsepywkotdybautwtprztnygauykeflbefrpdtebgvsosgsclluatstamrelgaybsckmelabyldbklkfycehnbeadhnaasalygefyjoldaovwsndnhfmopkdwmyvedrsbonidrhsgwftsvowenduysoecfmtsdecybsghfxcwathytknskojswfoeenpllgjzwlfgpelpwnjovaatknnbssihcycwktfnglbahlclcazowewmnnfhftftrsyktnldiytaoxutpytkwywmeelgsnoltnchgwredejppsrdutdavthdgudansloknidaaehimyabwbewzfnylsbnnhyetfdwectckgwbeksprlkbbfekobzykjlrdmolgstidwliarnksksurjnjzbzprdisrcmoltbmsrlnsdpiadtosrysfyllbaewetdkngdgtadaeaednjkclwm")
    }
}
