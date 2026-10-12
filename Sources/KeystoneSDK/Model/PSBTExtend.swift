import Foundation

public struct PSBTExtend: Equatable {
    public let psbt: Data
    /// nil indicates Bitcoin (the coin field is omitted).
    public let coinId: Int32?
}
