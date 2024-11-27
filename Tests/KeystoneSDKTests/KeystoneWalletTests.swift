//
//  KeystoneWalletTests.swift
//  
//
//  Created by LiYan on 3/27/23.
//

import XCTest
import URKit
@testable import KeystoneSDK


final class KeystoneWalletTests: XCTestCase {

    func testParseMultiAccountsWithBTC() {
        let multiAccountsCBORHex = "a4011aa424853c0281d9012fa4035821034af544244d31619d773521a1a366373c485ff89de50bea543c2b14cccfbb6a500458208dc2427d8ab23caab07729f88f089a3cfa2cfffcd7d1e507f983c0d44a5dbd3506d90130a10186182cf500f500f5081a149439dc03686b657973746f6e650565312e302e32"
        
        let keystoneWallet = KeystoneWallet()
        let ur = try! UR(type: "crypto-multi-accounts", cbor: CBOR(multiAccountsCBORHex.hexadecimal))
        let multiAccounts = try! keystoneWallet.parseMultiAccounts(ur: ur)
        let firstHDKey = multiAccounts.keys[0]

        XCTAssertEqual(multiAccounts.device, "keystone")
        XCTAssertEqual(multiAccounts.masterFingerprint, "a424853c")
        XCTAssertEqual(multiAccounts.deviceId, nil)
        XCTAssertEqual(multiAccounts.deviceVersion, "1.0.2")

        XCTAssertEqual(firstHDKey.chain, "BTC")
        XCTAssertEqual(firstHDKey.path, "m/44'/0'/0'")
        XCTAssertEqual(firstHDKey.publicKey, "034af544244d31619d773521a1a366373c485ff89de50bea543c2b14cccfbb6a50")
        XCTAssertEqual(firstHDKey.extendedPublicKey, "xpub6BoYPFH1MivLdh2BWZuRu6LfuaVSkVak5wsDxjjkAWcUM2QPKyeCHXMgDfRJFvKZhqA4vM5vsgcD6C5ot9eThnFHstgPntNzBLUdLeKS7Zt")
        XCTAssertEqual(firstHDKey.extra.okx.chainId, 0)
    }

    func testParseMultiAccountsWithDeviceId() {
        let multiAccountsCBORHex = "a4011ae9181cf30281d9012fa203582102eae4b876a8696134b868f88cc2f51f715f2dbedb7446b8e6edf3d4541c4eb67b06d90130a10188182cf51901f5f500f500f503686b657973746f6e6504782832383437356338643830663663303662616662653436613764313735306633666366323536356637"

        let keystoneWallet = KeystoneWallet()
        let ur = try! UR(type: "crypto-multi-accounts", cbor: CBOR(multiAccountsCBORHex.hexadecimal))
        let multiAccounts = try! keystoneWallet.parseMultiAccounts(ur: ur)

        XCTAssertEqual(multiAccounts.device, "keystone")
        XCTAssertEqual(multiAccounts.deviceId, "28475c8d80f6c06bafbe46a7d1750f3fcf2565f7")
    }

    func testParseMultiAccountsWithAccountNote() {
        let multiAccountsCBORHex = "a4011a707eed6c028ed9012fa902f403582102b54c9a1c653023b3afac6481c056b42c51416847d7dddb182ae7b5ef81ea5ca8045820521f498e1e49d2ef34a4316052c746c31c6d6eee4f0bfa6c30847f694246e57205d90131a201183c020006d90130a30186182cf5183cf500f5021a707eed6c030307d90130a2018400f480f40300081a530a7f9409684b657973746f6e650a706163636f756e742e7374616e64617264d9012fa502f403582103cd7eb86356b3569b68f68f86825469b9103984f24728f922b3ac17cd4bd6703d06d90130a3018a182cf5183cf500f500f400f4021a707eed6c030509684b657973746f6e650a736163636f756e742e6c65646765725f6c697665d9012fa502f403582102d8b2374f5f463f2df8d15eff20ff6713d1ebc721d4810b680e61a0e001f9884206d90130a3018a182cf5183cf501f500f400f4021a707eed6c030509684b657973746f6e650a736163636f756e742e6c65646765725f6c697665d9012fa502f403582102a3b358f96580c821548cd30076858773341508df12cf41e0fbcf9dd5526a6a2b06d90130a3018a182cf5183cf502f500f400f4021a707eed6c030509684b657973746f6e650a736163636f756e742e6c65646765725f6c697665d9012fa502f4035821028ce72734e65cae0486fb8005537ba7769cfa4023e50d9c6dda6c6af56fd2537506d90130a3018a182cf5183cf503f500f400f4021a707eed6c030509684b657973746f6e650a736163636f756e742e6c65646765725f6c697665d9012fa502f403582103e879f1096133be603afffbbca64e79d629ccb32679dc0073060cd830260002d206d90130a3018a182cf5183cf504f500f400f4021a707eed6c030509684b657973746f6e650a736163636f756e742e6c65646765725f6c697665d9012fa502f40358210208f1eaec049506b81554f4298107038f0aba5f2494705ee795e469e7d76ab1c206d90130a3018a182cf5183cf505f500f400f4021a707eed6c030509684b657973746f6e650a736163636f756e742e6c65646765725f6c697665d9012fa502f403582103fd286a7e3bac0eaecd524fee88ef83ac36623774b36f09cda613dc63bae8645206d90130a3018a182cf5183cf506f500f400f4021a707eed6c030509684b657973746f6e650a736163636f756e742e6c65646765725f6c697665d9012fa502f403582103d7f947af61a563fcbb54a0d85d04d0bf6cca151f8c848d44c323c19e37065d9006d90130a3018a182cf5183cf507f500f400f4021a707eed6c030509684b657973746f6e650a736163636f756e742e6c65646765725f6c697665d9012fa502f40358210325348e77be2b0a229171526bd78d67accef936ed2a0ec2ce8573d6f8e4ad405806d90130a3018a182cf5183cf508f500f400f4021a707eed6c030509684b657973746f6e650a736163636f756e742e6c65646765725f6c697665d9012fa502f403582102018cfa7ac39026d55fd65f81ba226a13df16b108e3a79fdf5be3862fd91311c706d90130a3018a182cf5183cf509f500f400f4021a707eed6c030509684b657973746f6e650a736163636f756e742e6c65646765725f6c697665d9012fa702f403582102fe559a4c39eecfa285b71cb983e5070a909eef41d1298df668ec71944b2010980458206fbef226f8f7346b2aa987319f3250c11786867706d544340ca0e771d796ff4605d90131a20100020006d90130a30186182cf500f500f5021a707eed6c0303081a8d7e882809684b657973746f6e65d9012fa702f403582102c735933fd468a5327044b488a506012ef9ada1a55a1ba73d26762038eabd153e0458207769e0d607226c26f571599f47a47ce80327677b6d34e1ddfd00ba1d3a3f6dd705d90131a20100020006d90130a301861831f500f500f5021a707eed6c0303081a3a58db6c09684b657973746f6e65d9012fa702f403582103b90aadf9cb5bcf0a42254d197060a2830cd5f284589c05dc75a2a83e5c045d1c0458205c7aeb9c828446d6a6a3c57e1d121a32e551a371abd5ee520fc7b28faaa77bb105d90131a20100020006d90130a301861854f500f500f5021a707eed6c0303081a9336f8a809684b657973746f6e65036c6b657973746f6e652050726f04782832383437356338643830663663303662616662653436613764313735306633666366323536356637"

        let keystoneWallet = KeystoneWallet()
        let ur = try! UR(type: "crypto-multi-accounts", cbor: CBOR(multiAccountsCBORHex.hexadecimal))
        let multiAccounts = try! keystoneWallet.parseMultiAccounts(ur: ur)
        let firstHDKey = multiAccounts.keys[0]

        XCTAssertEqual(firstHDKey.chain, "ETH")
        XCTAssertEqual(firstHDKey.path, "m/44'/60'/0'")
        XCTAssertEqual(firstHDKey.note, AccountNote.standard.rawValue)

        let secondHDKey = multiAccounts.keys[1]
        XCTAssertEqual(secondHDKey.chain, "ETH")
        XCTAssertEqual(secondHDKey.path, "m/44'/60'/0'/0/0")
        XCTAssertEqual(secondHDKey.note, AccountNote.ledgerLive.rawValue)
    }

    func testParseMultiAccountsWithSOL() {
        let multiAccountsCBORHex = "a3011ae9181cf30281d9012fa203582102eae4b876a8696134b868f88cc2f51f715f2dbedb7446b8e6edf3d4541c4eb67b06d90130a10188182cf51901f5f500f500f503686b657973746f6e65"
        
        let keystoneWallet = KeystoneWallet()
        let ur = try! UR(type: "crypto-multi-accounts", cbor: CBOR(multiAccountsCBORHex.hexadecimal))
        let multiAccounts = try! keystoneWallet.parseMultiAccounts(ur: ur)
        let firstHDKey = multiAccounts.keys[0]

        XCTAssertEqual(multiAccounts.device, "keystone")
        XCTAssertEqual(multiAccounts.masterFingerprint, "e9181cf3")

        XCTAssertEqual(firstHDKey.chain, "SOL")
        XCTAssertEqual(firstHDKey.path, "m/44'/501'/0'/0'")
        XCTAssertEqual(firstHDKey.publicKey, "02eae4b876a8696134b868f88cc2f51f715f2dbedb7446b8e6edf3d4541c4eb67b")
        XCTAssertEqual(firstHDKey.extendedPublicKey, "")
    }
    
    func testParseZcashAccounts() {
        let zcashAccountsCBORHex = "a2015820af5d9c247e91d0cbf603f6f6f49cfc218eabf9a2c1d886ce94fc167d6da7e6640281d9c033a301d9012fa3035821026a2281be37e884fbf0a1d688f76ea5537a74b19230311bc9a82cf43e588d628d045820aa46fcc6aeec9beef1b79b614cdf5093a323964dcf82a86842a82b5ccfd7171e06d90130a10186182cf51885f500f502d9c032a201d90130a101861820f51885f500f502586083ceb48bb24a4debb403c3cc02043f5157ec4f084b8fb359a58f53ab4cd3741b339461f1504081a0765b12b87cac9c4a3baa55b155192d3cfd98a7517b8a59019744b22b89ba0daaa32de9d883a727be7e2ca09446f87efe0e5b29ce98c65f190366363636363636"
        
        let keystoneWallet = KeystoneWallet()
        let ur = try! UR(type: "zcash-accounts", cbor: CBOR(zcashAccountsCBORHex.hexadecimal))
        
        let zcashAccounts = try! keystoneWallet.parseZcashAccounts(ur: ur)
        
        let account = zcashAccounts.accounts[0]
        
        XCTAssertEqual(zcashAccounts.seedFingerprint, "af5d9c247e91d0cbf603f6f6f49cfc218eabf9a2c1d886ce94fc167d6da7e664")
        XCTAssertEqual(account.name, "666666")

        XCTAssertEqual(account.transparent?.path, "44'/133'/0'")
        XCTAssertEqual(account.transparent?.xpub, "xpub6BemYiVNp19a1pwFbJgXWyJe7gKX2i9yv3xVkvpzHTikk1HfCpmhKqzFCNr5ctbipukfd7AbJFmCB13StCmSrqZHucLbBA4EWt89fiZA83x")
        
        XCTAssertEqual(account.orchard.path, "32'/133'/0'")
        XCTAssertEqual(account.orchard.fvk, "83ceb48bb24a4debb403c3cc02043f5157ec4f084b8fb359a58f53ab4cd3741b339461f1504081a0765b12b87cac9c4a3baa55b155192d3cfd98a7517b8a59019744b22b89ba0daaa32de9d883a727be7e2ca09446f87efe0e5b29ce98c65f19")
        
    }
}
