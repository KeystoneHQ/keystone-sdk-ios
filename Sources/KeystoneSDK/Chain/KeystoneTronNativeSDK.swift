import Foundation
import URRegistryFFI
import URKit

public class KeystoneTronNativeSDK: KeystoneBaseSDK {
    public func generateSignRequest(tronSignRequest request: TronNativeSignRequest) throws -> UREncoder {
        let result = handle_error(get_result: {
            generate_tron_native_sign_request($0, request.requestId, request.signData,
                request.path, request.xfp, request.dataType, request.address, request.origin)
        })
        return try super.generateSignRequest(signRequest: result)
    }

    public func parseSignature(ur: UR) throws -> Signature {
        let result = handle_error(get_result: {
            parse_tron_native_signature($0, ur.type, ur.cbor.cborData.hexEncodedString())
        })
        return try super.parseSignature(signResult: result)
    }
}
