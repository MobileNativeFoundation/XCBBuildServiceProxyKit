// FIXME: JSON Encode
public struct IndexingInfoRequest: SessionMessage, Codable {
    public static let name = "INDEXING_INFO_REQUESTED"

    public var sessionHandle: String
    public var responseChannel: UInt64
    public var request: BuildRequestMessagePayload
    public var targetID: String
    public var filePath: String?
    public var outputPathOnly: Bool
}
