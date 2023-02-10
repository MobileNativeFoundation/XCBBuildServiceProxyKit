public struct BuildCancelRequest: SessionMessage, Codable {
    public static let name = "BUILD_CANCEL"

    public var sessionHandle: String
    public var id: Int

    public init(sessionHandle: String, id: Int) {
        self.sessionHandle = sessionHandle
        self.id = id
    }
}
