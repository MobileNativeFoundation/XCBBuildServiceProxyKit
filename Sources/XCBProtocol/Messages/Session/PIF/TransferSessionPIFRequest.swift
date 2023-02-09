public struct TransferSessionPIFRequest: SessionMessage {
    public static let name = "TRANSFER_SESSION_PIF_REQUEST"

    public var sessionHandle: String
    public var workspaceSignature: String

    public init(sessionHandle: String, workspaceSignature: String) {
        self.sessionHandle = sessionHandle
        self.workspaceSignature = workspaceSignature
    }
}
