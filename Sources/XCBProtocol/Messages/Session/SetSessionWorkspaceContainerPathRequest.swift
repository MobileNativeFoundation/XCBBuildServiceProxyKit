struct SetSessionWorkspaceContainerPathRequest: SessionMessage {
    public static let name = "SET_SESSION_WORKSPACE_CONTAINER_PATH_REQUEST"

    public var sessionHandle: String
    public var containerPath: String

    public init(sessionHandle: String, containerPath: String) {
        self.sessionHandle = sessionHandle
        self.containerPath = containerPath
    }
}
