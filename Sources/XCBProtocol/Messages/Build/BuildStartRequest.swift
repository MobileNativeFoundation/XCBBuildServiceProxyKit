public struct BuildStartRequest: SessionMessage {
    public static let name = "BUILD_START"

    public var sessionHandle: String
    public var id: Int

    public init(sessionHandle: String, id: Int) {
        self.sessionHandle = sessionHandle
        self.id = id
    }
}