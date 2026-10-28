import Foundation

public struct TronNativeSignRequest {
    public let requestId: String
    public let signData: String
    public let path: String
    public let xfp: String
    public let dataType: Int32
    public let address: String
    public let origin: String

    public init(requestId: String, signData: String, path: String, xfp: String,
                dataType: Int32 = 1, address: String = "", origin: String = "") {
        self.requestId = requestId
        self.signData = signData
        self.path = path
        self.xfp = xfp
        self.dataType = dataType
        self.address = address
        self.origin = origin
    }
}
