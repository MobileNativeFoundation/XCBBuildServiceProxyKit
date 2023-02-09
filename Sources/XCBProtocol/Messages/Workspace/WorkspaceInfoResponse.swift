public struct WorkspaceInfoResponse: Message {
    public static let name = "WORKSPACE_INFO_RESPONSE"

    public var sessionHandle: String
    public var workspaceInfo: WorkspaceInfo

    public init(sessionHandle: String, workspaceInfo: WorkspaceInfo) {
        self.sessionHandle = sessionHandle
        self.workspaceInfo = workspaceInfo
    }

    public struct WorkspaceInfo {
        public var targetInfos: [TargetInfo]

        public init(targetInfos: [TargetInfo]) {
            self.targetInfos = targetInfos
        }

        public struct TargetInfo {
            public var guid: String
            public var targetName: String
            public var projectName: String

            public init(guid: String, targetName: String, projectName: String) {
                self.guid = guid
                self.targetName = targetName
                self.projectName = projectName
            }
        }
    }
}
