public struct IndexingInfoResponse: Message {
    public static let name = "INDEXING_INFO_RECEIVED"

    public var targetID: String
    public var data: ByteString
    
    public init(targetID: String, data: ByteString) {
        self.targetID = targetID
        self.data = data
    }
}
