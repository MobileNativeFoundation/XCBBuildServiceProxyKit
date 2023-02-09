public struct WorkspaceInfoRequest: SessionMessage {
    public static let name = "WORKSPACE_INFO_REQUEST"

    public var sessionHandle: String

    public init(sessionHandle: String) {
        self.sessionHandle = sessionHandle
    }
}
