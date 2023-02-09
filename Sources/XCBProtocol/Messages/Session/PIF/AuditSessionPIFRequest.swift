struct AuditSessionPIFRequest: SessionMessage {
    public static let name = "AUDIT_SESSION_PIF_REQUEST"

    public var sessionHandle: String
    public var pifContents: [UInt8]

    public init(sessionHandle: String, pifContents: [UInt8]) {
        self.sessionHandle = sessionHandle
        self.pifContents = pifContents
    }
}
