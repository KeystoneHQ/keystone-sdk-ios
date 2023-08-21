//
//  CryptoPath.swift
//  
//
//  Created by LiYan on 8/21/23.
//

import Foundation
import URRegistryFFI

public class CryptoPath {
    public static func parseHDPath(hdPath: String) -> HDPath {
        let parseHDPath = handle_error(
            get_result: { parse_hd_path($0, hdPath) }
        )
        let path = try! KeystoneBaseSDK().jsonDecoder.decode(NativeResult<HDPath>.self, from: Data(parseHDPath.utf8))
        return path.result
    }
}
